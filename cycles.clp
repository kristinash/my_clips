(defrule make-sauce-fast-CYCLE
    (declare (salience 10))
    (ingredient (name "Томатная паста") (certainty ?c1))
    (ingredient (name "Вода") (certainty ?c2))
    ?f <- (ingredient (name "Соус томатный") (certainty ?cur-c))
    (test (> (max-certainty ?cur-c (+ ?cur-c 0.1)) ?cur-c))
    =>
    (bind ?new-val (max-certainty ?cur-c (+ ?cur-c 0.1))) 
    (modify ?f (certainty ?new-val) (type result))
    (assert (sendmessage (value (str-cat "ДЕЙСТВИЕ: Соус вырос до " ?new-val))))
)

(defrule make-paste-CYCLE
    (declare (salience 11))
    ; Теперь это правило зависит от измененного соуса
    (ingredient (name "Соус томатный") (certainty ?c1))
    (ingredient (name "Вода") (certainty ?c2))
    ; Находим пасту для изменения
    ?f <- (ingredient (name "Томатная паста") (certainty ?cur-c))
    (test (> (max-certainty ?cur-c (+ ?cur-c 0.1)) ?cur-c))
    =>
    (bind ?new-val (max-certainty ?cur-c (+ ?cur-c 0.1)))
    (modify ?f (certainty ?new-val) (type result))
    (assert (sendmessage (value (str-cat "ДЕЙСТВИЕ: Паста выросла до " ?new-val))))
)

---------------------------------------------------------------------
    (ingredient (name "a") (certainty 0.0))
    (ingredient (name "b") (certainty 0.0))
    (ingredient (name "c") (certainty 0.0))
    (ingredient (name "d") (certainty 0.0))
    (ingredient (name "k") (certainty 0.0))


; --- Правило 1: a + b = c ---
; Логика: берем значения a и b, складываем и обновляем c
(defrule rule_A_plus_B_to_C
    (declare (salience 10))
    (ingredient (name "a") (certainty ?ca))
    (ingredient (name "b") (certainty ?cb))
    ?f-c <- (ingredient (name "c") (certainty ?cc))
    ; Проверка, чтобы не модифицировать зря, если значение не растет
    (test (> (max-certainty ?cc (+ ?ca ?cb)) ?cc))
    =>
    (bind ?new-c (max-certainty ?cc (+ ?ca ?cb)))
    (modify ?f-c (certainty ?new-c) (type result))
    (assert (sendmessage (value (str-cat "ЦИКЛ: a(" ?ca ") + b(" ?cb ") -> c новое CF=" ?new-c))))
)

; --- Правило 2: d + k = a ---
; Логика: d и k обновляют значение a, что может снова запустить Правило 1
(defrule rule_D_plus_K_to_A
    (declare (salience 10))
    (ingredient (name "d") (certainty ?cd))
    (ingredient (name "k") (certainty ?ck))
    ?f-a <- (ingredient (name "a") (certainty ?ca))
    (test (> (max-certainty ?ca (+ ?cd ?ck)) ?ca))
    =>
    (bind ?new-a (max-certainty ?ca (+ ?cd ?ck)))
    (modify ?f-a (certainty ?new-a) (type result))
    (assert (sendmessage (value (str-cat "ЦИКЛ: d(" ?cd ") + k(" ?ck ") -> a новое CF=" ?new-a))))
)

    
=== ЛОГ ВЫПОЛНЕНИЯ СИСТЕМЫ ===

  [Действие] ЦИКЛ: a(0.1) + b(0.3) -> c новое CF=0.4
  [Действие] ЦИКЛ: d(0.5) + k(0.3) -> a новое CF=0.8
  [Действие] ЦИКЛ: a(0.8) + b(0.3) -> c новое CF=1.0
--------------------------
--- ФИНАЛЬНЫЙ ОТЧЕТ ---
  [Результат] ИТОГО: a (CF=0.8)
  [Результат] ИТОГО: c (CF=1.0)