; ====================================================
; 1. ШАБЛОНЫ И ФУНКЦИИ
; ====================================================

(deftemplate input-question 
    (slot name) 
    (slot certainty (type NUMBER))
)

(deftemplate ioproxy 
    (slot fact-id) 
    (multislot messages) 
    (slot mode (default 0))
)

(deftemplate ingredient 
    (slot name) 
    (slot certainty (default 0.0))
)

(deftemplate token 
    (slot name)
)

(deftemplate sendmessage 
    (slot value)
)

(deffunction max-certainty (?old-cf ?new-cf)
   (if (> ?new-cf ?old-cf) 
       then ?new-cf 
       else ?old-cf)
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

; ====================================================
; 2. НАЧАЛЬНЫЕ ДАННЫЕ
; ====================================================

(deffacts initial-data
    (ioproxy (fact-id 112))
    ; Базовые продукты
    (ingredient (name "Мука пшеничная") (certainty 0.0))
    (ingredient (name "Вода") (certainty 0.0))
    (ingredient (name "Дрожжи") (certainty 0.0))
    (ingredient (name "Соль") (certainty 0.0))
    (ingredient (name "Томаты") (certainty 0.0))
    (ingredient (name "Томатная паста") (certainty 0.0))
    (ingredient (name "Чеснок") (certainty 0.0))
    (ingredient (name "Базилик") (certainty 0.0))
    (ingredient (name "Масло оливковое") (certainty 0.0))
    (ingredient (name "Сыр Моцарелла") (certainty 0.0))
    (ingredient (name "Сыр Российский") (certainty 0.0))
    ; Целевые результаты
    (ingredient (name "Тесто для пиццы") (certainty 0.0))
    (ingredient (name "Соус томатный") (certainty 0.0))
    (ingredient (name "Пицца Маргарита") (certainty 0.0))
    ; Токены для однократного срабатывания вариантов
    (token (name "t-dough-std"))
    (token (name "t-sauce-fresh")) 
    (token (name "t-sauce-fast"))
    (token (name "t-pizza-premium")) 
    (token (name "t-pizza-budget"))
)

; ====================================================
; 3. ЛОГИКА ПРИГОТОВЛЕНИЯ С ВЫВОДОМ ИНГРЕДИЕНТОВ
; ====================================================

; Синхронизация ввода из C#
(defrule match-ingredients
    (declare (salience 100))
    ?f <- (ingredient (name ?name) (certainty ?old-c))
    ?q <- (input-question (name ?n&?name) (certainty ?new-c))
    =>
    (modify ?f (certainty ?new-c))
    (retract ?q)
)

; --- ТЕСТО ---
(defrule make-pizza-dough-std
    ?tk <- (token (name "t-dough-std"))
    (ingredient (name "Мука пшеничная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Вода") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Дрожжи") (certainty ?c3&:(> ?c3 0.1)))
    (ingredient (name "Соль") (certainty ?c4&:(> ?c4 0.1)))
    ?f <- (ingredient (name "Тесто для пиццы") (certainty ?cur-c))
    =>
    (retract ?tk)
    (bind ?rule-cf 0.95)
    (bind ?avg-cf (weighted-avg ?c1 10 ?c2 2 ?c3 2 ?c4 1))
    (bind ?res (* ?avg-cf ?rule-cf))
    (bind ?cnew (max-certainty ?cur-c ?res))
    (modify ?f (certainty ?cnew))
    (assert (sendmessage 
        (value (str-cat 
            "ТЕСТО: [Мука пшеничная + Вода + Дрожжи + Соль] -> Тесто для пиццы (CF=" ?cnew ")"
        ))
    ))
)

; --- СОУС (Вариант 1: Свежий) ---
(defrule make-sauce-fresh
    ?tk <- (token (name "t-sauce-fresh"))
    (ingredient (name "Томаты") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Базилик") (certainty ?c3&:(> ?c3 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c4&:(> ?c4 0.1)))
    ?f <- (ingredient (name "Соус томатный") (certainty ?cur-c))
    =>
    (retract ?tk)
    (bind ?rule-cf 1.0)
    (bind ?avg-cf (weighted-avg ?c1 10 ?c2 1 ?c3 1 ?c4 3))
    (bind ?res (* ?avg-cf ?rule-cf))
    (bind ?cnew (max-certainty ?cur-c ?res))
    (modify ?f (certainty ?cnew))
    (assert (sendmessage 
        (value (str-cat 
            "СОУС: [Томаты + Чеснок + Базилик + Масло оливковое] -> Соус томатный (свежий) (CF=" ?cnew ")"
        ))
    ))
)

; --- СОУС (Вариант 2: Быстрый) ---
(defrule make-sauce-fast
    ?tk <- (token (name "t-sauce-fast"))
    (ingredient (name "Томатная паста") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Вода") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Соус томатный") (certainty ?cur-c))
    =>
    (retract ?tk)
    (bind ?rule-cf 0.6)
    (bind ?avg-cf (weighted-avg ?c1 10 ?c2 5))
    (bind ?res (* ?avg-cf ?rule-cf))
    (bind ?cnew (max-certainty ?cur-c ?res))
    (modify ?f (certainty ?cnew))
    (assert (sendmessage 
        (value (str-cat 
            "СОУС: [Томатная паста + Вода] -> Соус томатный (быстрый) (CF=" ?cnew ")"
        ))
    ))
)

; --- ПИЦЦА МАРГАРИТА (Рецепт 1: с Моцареллой) ---
(defrule make-margherita-premium
    ?tk <- (token (name "t-pizza-premium"))
    (ingredient (name "Тесто для пиццы") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус томатный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Пицца Маргарита") (certainty ?cur-c))
    =>
    (retract ?tk)
    (bind ?rule-cf 1.0)
    (bind ?avg-cf (weighted-avg ?c1 5 ?c2 5 ?c3 10))
    (bind ?res (* ?avg-cf ?rule-cf))
    (bind ?cnew (max-certainty ?cur-c ?res))
    (modify ?f (certainty ?cnew))
    (assert (sendmessage 
        (value (str-cat 
            "ПИЦЦА: [Тесто для пиццы + Соус томатный + Сыр Моцарелла] -> Пицца Маргарита (CF=" ?cnew ")"
        ))
    ))
)

; --- ПИЦЦА МАРГАРИТА (Рецепт 2: с Российским сыром) ---
(defrule make-margherita-budget
    ?tk <- (token (name "t-pizza-budget"))
    (ingredient (name "Тесто для пиццы") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус томатный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Российский") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Пицца Маргарита") (certainty ?cur-c))
    =>
    (retract ?tk)
    (bind ?rule-cf 0.7)
    (bind ?avg-cf (weighted-avg ?c1 5 ?c2 5 ?c3 10))
    (bind ?res (* ?avg-cf ?rule-cf))
    (bind ?cnew (max-certainty ?cur-c ?res))
    (modify ?f (certainty ?cnew))
    (assert (sendmessage 
        (value (str-cat 
            "ПИЦЦА: [Тесто для пиццы + Соус томатный + Сыр Российский] -> Пицца Маргарита (CF=" ?cnew ")"
        ))
    ))
)

; ====================================================
; 4. ВЫВОД СООБЩЕНИЙ В ПРОКСИ
; ====================================================

(defrule update-proxy-messages
    (declare (salience -10))
    ?msg <- (sendmessage (value ?text))
    ?proxy <- (ioproxy (messages $?list))
    =>
    (modify ?proxy (messages $?list ?text))
    (retract ?msg)
)