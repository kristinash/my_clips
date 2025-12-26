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

; Функция максимума с ограничением до 1.0
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

; Правило спрашивает про настроение в самом начале
(defrule ask-user-mood
   (declare (salience 150))
   ?proxy <- (ioproxy (mode 0))
   (not (mood-factor))
   =>
   (modify ?proxy 
       (mode 1)
       (current-ask "MOOD_QUESTION")
       (messages (create$ "Какое у вас сегодня настроение?"))
       (answers (create$ "Хорошее" "Плохое")))
)

; Обработка ответа про настроение
(defrule handle-mood-answer
   (declare (salience 200))
   ?q <- (input-question (name "MOOD_QUESTION") (certainty ?val))
   ?proxy <- (ioproxy (current-ask "MOOD_QUESTION"))
   =>
   (bind ?bonus (if (> ?val 0) then 0.1 else -0.1))
   (assert (mood-factor (value ?bonus)))
   ; Важно: сбрасываем mode в 0 и очищаем ключ вопроса
   (modify ?proxy (mode 0) (current-ask none))
   (retract ?q)
)

; Сопоставление ингредиентов, выбранных в ListView
(defrule match-ingredients
    (declare (salience 100))
    ?f <- (ingredient (name ?name))
    ?q <- (input-question (name ?n&?name) (certainty ?new-c))
    =>
    (modify ?f (certainty ?new-c))
    (retract ?q)
)

(defrule print-report-header
    (declare (salience -5))
    (exists (ingredient (type result)))
    (not (header-done))
    =>
    (assert (header-done))
    (assert (sendmessage (value "--------------------------")))
    (assert (sendmessage (value "--- ФИНАЛЬНЫЙ ОТЧЕТ ---")))
)

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