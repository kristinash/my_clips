(deftemplate input-question 
    (slot name) 
    (slot certainty (type NUMBER))
)

(deftemplate ioproxy 
    (slot fact-id) 
    (slot mode (default 0))          
    (slot current-ask (default none)) 
    (multislot messages)              
    (multislot answers)               
)

(deftemplate ingredient 
    (slot name) 
    (slot certainty (default 0.0)) 
    (slot type (default raw)) 
)

(deftemplate mood-factor
    (slot value (type NUMBER) (default 0.0))
)

(deftemplate sendmessage 
    (slot value)
)

; --- Функции расчета ---
(deffunction max-certainty (?old-cf ?new-cf)
   (min 1.0 (if (> ?new-cf ?old-cf) 
                then ?new-cf 
                else ?old-cf))
)

(deffunction weighted-avg ($?data)
   (bind ?sum-products 0.0) 
   (bind ?sum-weights 0.0) 
   (bind ?i 1)
   (while (<= ?i (length$ ?data))
      (bind ?val (nth$ ?i ?data))
      (bind ?weight (nth$ (+ ?i 1) ?data))
      (bind ?sum-products (+ ?sum-products (* ?val ?weight)))
      (bind ?sum-weights (+ ?sum-weights ?weight))
      (bind ?i (+ ?i 2)))
   (if (> ?sum-weights 0) 
       then (/ ?sum-products ?sum-weights) 
       else 0.0)
)

; --- Начальные данные ---
(deffacts initial-data
    (ioproxy (fact-id 112))
    (ingredient (name "Мука пшеничная"))
    (ingredient (name "Вода"))
    (ingredient (name "Дрожжи"))
    (ingredient (name "Соль"))
    (ingredient (name "Томаты"))
    (ingredient (name "Томатная паста"))
    (ingredient (name "Чеснок"))
    (ingredient (name "Базилик"))
    (ingredient (name "Масло оливковое"))
    (ingredient (name "Сыр Моцарелла"))
    (ingredient (name "Сыр Российский"))
    (ingredient (name "Тесто для пиццы"))
    (ingredient (name "Соус томатный"))
    (ingredient (name "Пицца Маргарита"))
)

; --- Механизм ioproxy ---

; Очистка прокси перед новым шагом
(defrule clear-proxy-messages
    (declare (salience 91))
    ?f <- (clearmessage)
    ?proxy <- (ioproxy)
    =>
    (modify ?proxy (messages) (answers))
    (retract ?f)
)

; Правило вопроса (сработает только если НЕТ mood-factor)
(defrule ask-user-mood
   (declare (salience 150))
   ?proxy <- (ioproxy (mode 0))
   (not (mood-factor))
   =>
   (modify ?proxy 
       (mode 1)
       (current-ask "MOOD_QUESTION")
       (messages "У вас сегодня хорошее настроение?")
       (answers "Да" "Нет"))
   (halt)
)

; Правило обработки ответа (Создает mood-factor, чтобы первое правило больше не сработало)
(defrule handle-mood-voice
   (declare (salience 200))
   ?ans <- (answer ?val)
   ?proxy <- (ioproxy (current-ask "MOOD_QUESTION"))
   =>
   (bind ?bonus (if (or (eq ?val "Да") (eq ?val "да")) then 0.1 else -0.1))
   (assert (mood-factor (value ?bonus)))
   (modify ?proxy (mode 0) (current-ask none) (messages) (answers))
   (retract ?ans)
)

; Синхронизация ингредиентов из ListView
(defrule match-ingredients
    (declare (salience 100))
    ?f <- (ingredient (name ?name))
    ?q <- (input-question (name ?n&?name) (certainty ?new-c))
    =>
    (modify ?f (certainty ?new-c))
    (retract ?q)
)

; --- Правила приготовления ---

(defrule make-pizza-dough-std
    (declare (salience 10))
    (ingredient (name "Мука пшеничная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Вода") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Дрожжи") (certainty ?c3&:(> ?c3 0.1)))
    (ingredient (name "Соль") (certainty ?c4&:(> ?c4 0.1)))
    ?f <- (ingredient (name "Тесто для пиццы") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 2 ?c3 2 ?c4 1) 0.95))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто (стандарт) CF=" ?res))))
    )
)

(defrule make-sauce-fresh
    (declare (salience 10))
    (ingredient (name "Томаты") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Базилик") (certainty ?c3&:(> ?c3 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c4&:(> ?c4 0.1)))
    ?f <- (ingredient (name "Соус томатный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 1 ?c3 1 ?c4 3) 1.0))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус (свежий) CF=" ?res))))
    )
)

(defrule make-margherita-premium
    (declare (salience 10))
    (ingredient (name "Тесто для пиццы") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус томатный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Пицца Маргарита") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 5 ?c3 10) 1.0))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Пицца (премиум) CF=" ?res))))
    )
)

; --- Отчетность ---

(defrule generate-final-report
    (declare (salience -10))
    (ingredient (name ?name) (certainty ?c&:(> ?c 0.0)) (type result))
    (mood-factor (value ?m))
    =>
    (bind ?final-cf (max 0.0 (min 1.0 (+ ?c ?m))))
    (assert (sendmessage (value (str-cat "ИТОГО: " ?name " (CF=" ?final-cf ") [Настроение: " ?m "]"))))
)

(defrule collect-messages-to-proxy
    (declare (salience -100)) 
    ?msg <- (sendmessage (value ?text))
    ?proxy <- (ioproxy (messages $?current-msgs))
    =>
    (modify ?proxy (messages $?current-msgs ?text))
    (retract ?msg)
)
