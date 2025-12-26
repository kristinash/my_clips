

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


(deffacts initial-data
    (ioproxy (fact-id 112))
    
    ;
; Автоматически сгенерированные ингредиенты
;
    (ingredient (name "Мука пшеничная в/с"))
    (ingredient (name "Вода фильтрованная"))
    (ingredient (name "Яйца категории С0"))
    (ingredient (name "Соль йодированная"))
    (ingredient (name "Сахар тростниковый"))
    (ingredient (name "Дрожжи сухие активные"))
    (ingredient (name "Молоко пастеризованное"))
    (ingredient (name "Масло сливочное 82%"))
    (ingredient (name "Томаты спелые"))
    (ingredient (name "Сыр Моцарелла"))
    (ingredient (name "Говядина вырезка"))
    (ingredient (name "Рис басмати"))
    (ingredient (name "Лук красный"))
    (ingredient (name "Чеснок свежий"))
    (ingredient (name "Перец черный горошек"))
    (ingredient (name "Масло оливковое extra virgin"))
    (ingredient (name "Уксус бальзамический"))
    (ingredient (name "Лимоны свежие"))
    (ingredient (name "Петрушка кудрявая"))
    (ingredient (name "Базилик свежий"))
    (ingredient (name "Орегано сушеный"))
    (ingredient (name "Тимьян свежий"))
    (ingredient (name "Розмарин"))
    (ingredient (name "Мед цветочный"))
    (ingredient (name "Горчица дижонская"))
    (ingredient (name "Смесь муки и соли"))
    (ingredient (name "Солевой раствор"))
    (ingredient (name "Сахарный сироп"))
    (ingredient (name "Яичная смесь"))
    (ingredient (name "Молочная основа"))
    (ingredient (name "Томатная паста"))
    (ingredient (name "Чесночная паста"))
    (ingredient (name "Травяная смесь итальянская"))
    (ingredient (name "Травяная смесь прованс"))
    (ingredient (name "Маринад базовый"))
    (ingredient (name "Заправка винегрет"))
    (ingredient (name "Соусная основа"))
    (ingredient (name "Кляр жидкий"))
    (ingredient (name "Панировка"))
    (ingredient (name "Бульонная основа"))
    (ingredient (name "Сметанная смесь"))
    (ingredient (name "Сырная стружка"))
    (ingredient (name "Овощная нарезка"))
    (ingredient (name "Фруктовая цедра"))
    (ingredient (name "Специальная соль"))
    (ingredient (name "Тесто дрожжевое базовое"))
    (ingredient (name "Тесто слоеное"))
    (ingredient (name "Тесто песочное"))
    (ingredient (name "Соус томатный базовый"))
    (ingredient (name "Соус сырный"))
    (ingredient (name "Соус белый"))
    (ingredient (name "Фарш мясной подготовленный"))
    (ingredient (name "Фарш овощной"))
    (ingredient (name "Бульон куриный процеженный"))
    (ingredient (name "Бульон овощной ароматный"))
    (ingredient (name "Маринад сложный"))
    (ingredient (name "Кляр воздушный"))
    (ingredient (name "Крем заварной базовый"))
    (ingredient (name "Глазурь зеркальная"))
    (ingredient (name "Овощи бланшированные"))
    (ingredient (name "Овощи обжаренные"))
    (ingredient (name "Мясо маринованное"))
    (ingredient (name "Рыба подготовленная"))
    (ingredient (name "Тесто раскатанное"))
    (ingredient (name "Начинка сладкая"))
    (ingredient (name "Тесто для пиццы выброженное"))
    (ingredient (name "Тесто для пасты"))
    (ingredient (name "Соус томатный ароматный"))
    (ingredient (name "Соус бешамель"))
    (ingredient (name "Соус голландез"))
    (ingredient (name "Фарш для пельменей"))
    (ingredient (name "Фарш для котлет"))
    (ingredient (name "Бульон концентрированный"))
    (ingredient (name "Маринад пряный"))
    (ingredient (name "Кляр пивной"))
    (ingredient (name "Крем дипломат"))
    (ingredient (name "Глазурь шоколадная"))
    (ingredient (name "Овощи тушеные"))
    (ingredient (name "Овочи гриль"))
    (ingredient (name "Мясо панированное"))
    (ingredient (name "Рыба в кляре"))
    (ingredient (name "Тесто формованное"))
    (ingredient (name "Начинка мясная"))
    (ingredient (name "Начинка овощная"))
    (ingredient (name "Основа для десерта"))
    (ingredient (name "Основа пиццы готовая"))
    (ingredient (name "Паста свежая"))
    (ingredient (name "Соус для пасты"))
    (ingredient (name "Соус для мяса"))
    (ingredient (name "Котлеты сырые"))
    (ingredient (name "Гарнир рисовый подготовленный"))
    (ingredient (name "Овощи для салата"))
    (ingredient (name "Мясо для жарки"))
    (ingredient (name "Рыба для запекания"))
    (ingredient (name "Тесто для выпечки"))
    (ingredient (name "Крем кондитерский"))
    (ingredient (name "Овощная смесь тушеная"))
    (ingredient (name "Мясная смесь фаршированная"))
    (ingredient (name "Соусная композиция"))
    (ingredient (name "Десертная основа"))
    (ingredient (name "Пицца Маргарита свежая"))
    (ingredient (name "Паста Карбонара"))
    (ingredient (name "Салат Цезарь классический"))
    (ingredient (name "Суп Том Ям"))
    (ingredient (name "Стейк Рибай medium rare"))
    (ingredient (name "Роллы Калифорния"))
    (ingredient (name "Бургер Чизбургер"))
    (ingredient (name "Тако с говядиной"))
    (ingredient (name "Рамен с курицей"))
    (ingredient (name "Плов узбекский"))
    (ingredient (name "Лазанья мясная"))
    (ingredient (name "Пельмени сибирские"))
    (ingredient (name "Курица гриль"))
    (ingredient (name "Рыба запеченная с лимоном"))
    (ingredient (name "Омлет с овощами"))
    (ingredient (name "Пицца Маргарита запеченная"))
    (ingredient (name "Паста Карбонара с трюфелем"))
    (ingredient (name "Салат Цезарь с креветками"))
    (ingredient (name "Суп Том Ям кокосовый"))
    (ingredient (name "Стейк Рибай с соусом"))
    (ingredient (name "Роллы Калифорния премиум"))
    (ingredient (name "Бургер Чизбургер двойной"))
    (ingredient (name "Тако с говядиной острейшие"))
    (ingredient (name "Рамен с курицей пикантный"))
    (ingredient (name "Плов узбекский праздничный"))
    (ingredient (name "Итальянский ужин премиум"))
    (ingredient (name "Азиатский сет делюкс"))
    (ingredient (name "Мексиканская фиеста"))
    (ingredient (name "Праздничный гала-ужин"))
    (ingredient (name "Семейный обед выходного дня"))
    (ingredient (name "Романтический ужин"))
    (ingredient (name "Бизнес-ланч премиум"))
    (ingredient (name "Детский праздничный набор"))
    (ingredient (name "Вегетарианское комбо"))
    (ingredient (name "Шведский стол домашний"))
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


(defrule rule-r001
    (declare (salience 10))
    (ingredient (name "Мука пшеничная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Смесь муки и соли") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 9) 0.52))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Смесь муки и соли CF=" ?res))))
    )
)

(defrule rule-r002
    (declare (salience 10))
    (ingredient (name "Вода фильтрованная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Солевой раствор") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 6) 0.23))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Солевой раствор CF=" ?res))))
    )
)

(defrule rule-r003
    (declare (salience 10))
    (ingredient (name "Вода фильтрованная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Сахарный сироп") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 6) 0.94))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Сахарный сироп CF=" ?res))))
    )
)

(defrule rule-r004
    (declare (salience 10))
    (ingredient (name "Яйца категории С0") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Яичная смесь") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 2) 0.71))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Яичная смесь CF=" ?res))))
    )
)

(defrule rule-r005
    (declare (salience 10))
    (ingredient (name "Молоко пастеризованное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Молочная основа") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 5) 0.38))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Молочная основа CF=" ?res))))
    )
)

(defrule rule-r006
    (declare (salience 10))
    (ingredient (name "Томаты спелые") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Томатная паста") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 5) 0.76))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Томатная паста CF=" ?res))))
    )
)

(defrule rule-r007
    (declare (salience 10))
    (ingredient (name "Чеснок свежий") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Чесночная паста") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 4) 0.77))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Чесночная паста CF=" ?res))))
    )
)

(defrule rule-r008
    (declare (salience 10))
    (ingredient (name "Базилик свежий") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Орегано сушеный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Тимьян свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Травяная смесь итальянская") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 8 ?c3 10) 0.28))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Травяная смесь итальянская CF=" ?res))))
    )
)

(defrule rule-r009
    (declare (salience 10))
    (ingredient (name "Тимьян свежий") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Розмарин") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Петрушка кудрявая") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Травяная смесь прованс") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 10 ?c3 2) 0.76))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Травяная смесь прованс CF=" ?res))))
    )
)

(defrule rule-r010
    (declare (salience 10))
    (ingredient (name "Уксус бальзамический") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лимоны свежие") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Маринад базовый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 1 ?c3 7) 0.83))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Маринад базовый CF=" ?res))))
    )
)

(defrule rule-r011
    (declare (salience 10))
    (ingredient (name "Масло оливковое") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Уксус бальзамический") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лимоны свежие") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Заправка винегрет") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 5 ?c3 6) 0.56))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Заправка винегрет CF=" ?res))))
    )
)

(defrule rule-r012
    (declare (salience 10))
    (ingredient (name "Томатная паста") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соусная основа") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 8 ?c3 6) 0.45))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соусная основа CF=" ?res))))
    )
)

(defrule rule-r013
    (declare (salience 10))
    (ingredient (name "Мука пшеничная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Кляр жидкий") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 1 ?c3 1) 0.79))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Кляр жидкий CF=" ?res))))
    )
)

(defrule rule-r014
    (declare (salience 10))
    (ingredient (name "Мука пшеничная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Панировка") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 1 ?c3 1) 0.16))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Панировка CF=" ?res))))
    )
)

(defrule rule-r015
    (declare (salience 10))
    (ingredient (name "Вода фильтрованная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лук красный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бульонная основа") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 5 ?c3 2) 0.27))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бульонная основа CF=" ?res))))
    )
)

(defrule rule-r016
    (declare (salience 10))
    (ingredient (name "Молоко пастеризованное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Сметанная смесь") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 8 ?c3 5) 0.22))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Сметанная смесь CF=" ?res))))
    )
)

(defrule rule-r017
    (declare (salience 10))
    (ingredient (name "Сыр Моцарелла") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Сырная стружка") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 1 ?c3 5) 0.15))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Сырная стружка CF=" ?res))))
    )
)

(defrule rule-r018
    (declare (salience 10))
    (ingredient (name "Томаты спелые") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лук красный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Петрушка кудрявая") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощная нарезка") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 10 ?c3 2) 0.5))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощная нарезка CF=" ?res))))
    )
)

(defrule rule-r019
    (declare (salience 10))
    (ingredient (name "Лимоны свежие") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Мед цветочный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Фруктовая цедра") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 6 ?c3 9) 0.25))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Фруктовая цедра CF=" ?res))))
    )
)

(defrule rule-r020
    (declare (salience 10))
    (ingredient (name "Соль йодированная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Специальная соль") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 5 ?c3 7) 0.21))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Специальная соль CF=" ?res))))
    )
)

(defrule rule-r021
    (declare (salience 10))
    (ingredient (name "Сахар тростниковый") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Мед цветочный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Сахарный сироп") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 3 ?c3 1) 0.93))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Сахарный сироп CF=" ?res))))
    )
)

(defrule rule-r022
    (declare (salience 10))
    (ingredient (name "Яйца категории С0") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Яичная смесь") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 1 ?c3 6) 0.38))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Яичная смесь CF=" ?res))))
    )
)

(defrule rule-r023
    (declare (salience 10))
    (ingredient (name "Масло сливочное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Молочная основа") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 2 ?c3 7) 0.11))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Молочная основа CF=" ?res))))
    )
)

(defrule rule-r024
    (declare (salience 10))
    (ingredient (name "Томаты спелые") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Томатная паста") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 10 ?c3 2) 0.93))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Томатная паста CF=" ?res))))
    )
)

(defrule rule-r025
    (declare (salience 10))
    (ingredient (name "Говядина вырезка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Маринад базовый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 9 ?c3 1) 0.19))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Маринад базовый CF=" ?res))))
    )
)

(defrule rule-r026
    (declare (salience 10))
    (ingredient (name "Рис басмати") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бульонная основа") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 9 ?c3 6) 0.2))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бульонная основа CF=" ?res))))
    )
)

(defrule rule-r027
    (declare (salience 10))
    (ingredient (name "Лук красный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощная нарезка") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 7 ?c3 10) 0.48))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощная нарезка CF=" ?res))))
    )
)

(defrule rule-r028
    (declare (salience 10))
    (ingredient (name "Перец черный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Орегано сушеный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Специальная соль") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 10 ?c3 5) 0.71))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Специальная соль CF=" ?res))))
    )
)

(defrule rule-r029
    (declare (salience 10))
    (ingredient (name "Лимоны свежие") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Заправка винегрет") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 2 ?c3 5) 0.96))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Заправка винегрет CF=" ?res))))
    )
)

(defrule rule-r030
    (declare (salience 10))
    (ingredient (name "Петрушка кудрявая") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Базилик свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Травяная смесь итальянская") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 8 ?c3 5) 0.77))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Травяная смесь итальянская CF=" ?res))))
    )
)

(defrule rule-r031
    (declare (salience 10))
    (ingredient (name "Смесь муки и соли") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Дрожжи сухие") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тесто дрожжевое базовое") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 7 ?c3 9) 0.74))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто дрожжевое базовое CF=" ?res))))
    )
)

(defrule rule-r032
    (declare (salience 10))
    (ingredient (name "Смесь муки и соли") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тесто слоеное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 6 ?c3 2) 0.15))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто слоеное CF=" ?res))))
    )
)

(defrule rule-r033
    (declare (salience 10))
    (ingredient (name "Смесь муки и соли") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тесто песочное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 7 ?c3 8) 0.44))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто песочное CF=" ?res))))
    )
)

(defrule rule-r034
    (declare (salience 10))
    (ingredient (name "Томатная паста") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус томатный базовый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 2 ?c3 2) 0.73))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус томатный базовый CF=" ?res))))
    )
)

(defrule rule-r035
    (declare (salience 10))
    (ingredient (name "Сырная стружка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус сырный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 10 ?c3 6) 0.24))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус сырный CF=" ?res))))
    )
)

(defrule rule-r036
    (declare (salience 10))
    (ingredient (name "Смесь муки и соли") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус белый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 4 ?c3 3) 0.54))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус белый CF=" ?res))))
    )
)

(defrule rule-r037
    (declare (salience 10))
    (ingredient (name "Говядина вырезка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лук красный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Фарш мясной подготовленный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 2 ?c3 10) 0.79))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Фарш мясной подготовленный CF=" ?res))))
    )
)

(defrule rule-r038
    (declare (salience 10))
    (ingredient (name "Лук красный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Томаты спелые") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Петрушка кудрявая") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Фарш овощной") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 4 ?c3 3) 0.48))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Фарш овощной CF=" ?res))))
    )
)

(defrule rule-r039
    (declare (salience 10))
    (ingredient (name "Бульонная основа") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Говядина вырезка") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лук красный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бульон куриный процеженный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 4 ?c3 2) 0.41))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бульон куриный процеженный CF=" ?res))))
    )
)

(defrule rule-r040
    (declare (salience 10))
    (ingredient (name "Бульонная основа") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лук красный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Томаты спелые") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бульон овощной ароматный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 9 ?c3 4) 0.7))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бульон овощной ароматный CF=" ?res))))
    )
)

(defrule rule-r041
    (declare (salience 10))
    (ingredient (name "Маринад базовый") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Маринад сложный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 2 ?c3 4) 0.25))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Маринад сложный CF=" ?res))))
    )
)

(defrule rule-r042
    (declare (salience 10))
    (ingredient (name "Кляр жидкий") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Кляр воздушный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 5 ?c3 2) 0.61))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Кляр воздушный CF=" ?res))))
    )
)

(defrule rule-r043
    (declare (salience 10))
    (ingredient (name "Сахарный сироп") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Крем заварной базовый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 7 ?c3 10) 0.54))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Крем заварной базовый CF=" ?res))))
    )
)

(defrule rule-r044
    (declare (salience 10))
    (ingredient (name "Сахарный сироп") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Глазурь зеркальная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 2 ?c3 6) 0.11))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Глазурь зеркальная CF=" ?res))))
    )
)

(defrule rule-r045
    (declare (salience 10))
    (ingredient (name "Овощная нарезка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощи бланшированные") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 7 ?c3 7) 0.56))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощи бланшированные CF=" ?res))))
    )
)

(defrule rule-r046
    (declare (salience 10))
    (ingredient (name "Овощная нарезка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощи обжаренные") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 3 ?c3 7) 0.74))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощи обжаренные CF=" ?res))))
    )
)

(defrule rule-r047
    (declare (salience 10))
    (ingredient (name "Говядина вырезка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Маринад сложный") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Мясо маринованное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 10) 0.16))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Мясо маринованное CF=" ?res))))
    )
)

(defrule rule-r048
    (declare (salience 10))
    (ingredient (name "Говядина вырезка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Маринад базовый") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Рыба подготовленная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 8) 0.8))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Рыба подготовленная CF=" ?res))))
    )
)

(defrule rule-r049
    (declare (salience 10))
    (ingredient (name "Тесто дрожжевое базовое") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Тесто раскатанное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 5) 0.55))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто раскатанное CF=" ?res))))
    )
)

(defrule rule-r050
    (declare (salience 10))
    (ingredient (name "Сахар тростниковый") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Мед цветочный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Начинка сладкая") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 6 ?c3 2) 0.72))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Начинка сладкая CF=" ?res))))
    )
)

(defrule rule-r051
    (declare (salience 10))
    (ingredient (name "Смесь муки и соли") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Дрожжи сухие") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тесто дрожжевое базовое") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 2 ?c3 7) 0.45))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто дрожжевое базовое CF=" ?res))))
    )
)

(defrule rule-r052
    (declare (salience 10))
    (ingredient (name "Томатная паста") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус томатный базовый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 9 ?c3 10) 0.36))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус томатный базовый CF=" ?res))))
    )
)

(defrule rule-r053
    (declare (salience 10))
    (ingredient (name "Сырная стружка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Молочная основа") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус сырный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 9 ?c3 1) 0.78))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус сырный CF=" ?res))))
    )
)

(defrule rule-r054
    (declare (salience 10))
    (ingredient (name "Яичная смесь") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус белый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 7 ?c3 1) 0.51))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус белый CF=" ?res))))
    )
)

(defrule rule-r055
    (declare (salience 10))
    (ingredient (name "Фарш мясной подготовленный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Специальная соль") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Фарш для пельменей") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 2 ?c3 6) 0.71))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Фарш для пельменей CF=" ?res))))
    )
)

(defrule rule-r056
    (declare (salience 10))
    (ingredient (name "Фарш овощной") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Начинка овощная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 4 ?c3 9) 0.98))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Начинка овощная CF=" ?res))))
    )
)

(defrule rule-r057
    (declare (salience 10))
    (ingredient (name "Бульон куриный процеженный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Специальная соль") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бульон концентрированный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 9 ?c3 6) 0.69))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бульон концентрированный CF=" ?res))))
    )
)

(defrule rule-r058
    (declare (salience 10))
    (ingredient (name "Бульон овощной ароматный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощи тушеные") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 9 ?c3 9) 0.21))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощи тушеные CF=" ?res))))
    )
)

(defrule rule-r059
    (declare (salience 10))
    (ingredient (name "Маринад сложный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Орегано сушеный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Тимьян свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Маринад пряный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 5 ?c3 2) 0.2))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Маринад пряный CF=" ?res))))
    )
)

(defrule rule-r060
    (declare (salience 10))
    (ingredient (name "Кляр воздушный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Панировка") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Кляр пивной") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 7 ?c3 10) 0.11))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Кляр пивной CF=" ?res))))
    )
)

(defrule rule-r061
    (declare (salience 10))
    (ingredient (name "Тесто дрожжевое базовое") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Дрожжи сухие") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тесто для пиццы выброженное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 10 ?c3 3) 0.66))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто для пиццы выброженное CF=" ?res))))
    )
)

(defrule rule-r062
    (declare (salience 10))
    (ingredient (name "Смесь муки и соли") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тесто для пасты") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 8 ?c3 1) 0.99))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто для пасты CF=" ?res))))
    )
)

(defrule rule-r063
    (declare (salience 10))
    (ingredient (name "Соус томатный базовый") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус томатный ароматный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 8 ?c3 7) 0.55))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус томатный ароматный CF=" ?res))))
    )
)

(defrule rule-r064
    (declare (salience 10))
    (ingredient (name "Соус белый") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сырная стружка") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус бешамель") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 4 ?c3 2) 0.5))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус бешамель CF=" ?res))))
    )
)

(defrule rule-r065
    (declare (salience 10))
    (ingredient (name "Яичная смесь") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лимоны свежие") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус голландез") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 5 ?c3 6) 0.2))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус голландез CF=" ?res))))
    )
)

(defrule rule-r066
    (declare (salience 10))
    (ingredient (name "Фарш мясной подготовленный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лук красный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Фарш для пельменей") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 8 ?c3 7) 0.47))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Фарш для пельменей CF=" ?res))))
    )
)

(defrule rule-r067
    (declare (salience 10))
    (ingredient (name "Фарш мясной подготовленный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Панировка") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Фарш для котлет") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 3 ?c3 4) 0.85))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Фарш для котлет CF=" ?res))))
    )
)

(defrule rule-r068
    (declare (salience 10))
    (ingredient (name "Бульон куриный процеженный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бульон концентрированный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 2 ?c3 6) 0.65))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бульон концентрированный CF=" ?res))))
    )
)

(defrule rule-r069
    (declare (salience 10))
    (ingredient (name "Маринад сложный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Базилик свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Орегано сушеный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Маринад пряный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 3 ?c3 5) 0.89))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Маринад пряный CF=" ?res))))
    )
)

(defrule rule-r070
    (declare (salience 10))
    (ingredient (name "Кляр воздушный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Дрожжи сухие") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Кляр пивной") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 8 ?c3 10) 0.55))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Кляр пивной CF=" ?res))))
    )
)

(defrule rule-r071
    (declare (salience 10))
    (ingredient (name "Крем заварной базовый") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Мед цветочный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Крем дипломат") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 4 ?c3 1) 0.6))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Крем дипломат CF=" ?res))))
    )
)

(defrule rule-r072
    (declare (salience 10))
    (ingredient (name "Глазурь зеркальная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Глазурь шоколадная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 3 ?c3 8) 0.9))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Глазурь шоколадная CF=" ?res))))
    )
)

(defrule rule-r073
    (declare (salience 10))
    (ingredient (name "Овощи бланшированные") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощи тушеные") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 1 ?c3 5) 0.79))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощи тушеные CF=" ?res))))
    )
)

(defrule rule-r074
    (declare (salience 10))
    (ingredient (name "Овощи обжаренные") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощи гриль") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 8 ?c3 3) 0.48))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощи гриль CF=" ?res))))
    )
)

(defrule rule-r075
    (declare (salience 10))
    (ingredient (name "Мясо маринованное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Панировка") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Мясо панированное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 2 ?c3 4) 0.98))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Мясо панированное CF=" ?res))))
    )
)

(defrule rule-r076
    (declare (salience 10))
    (ingredient (name "Рыба подготовленная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Кляр жидкий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Рыба в кляре") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 7 ?c3 8) 0.64))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Рыба в кляре CF=" ?res))))
    )
)

(defrule rule-r077
    (declare (salience 10))
    (ingredient (name "Тесто раскатанное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Тесто формованное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 3) 0.64))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто формованное CF=" ?res))))
    )
)

(defrule rule-r078
    (declare (salience 10))
    (ingredient (name "Фарш для пельменей") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лук красный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Начинка мясная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 10 ?c3 5) 0.41))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Начинка мясная CF=" ?res))))
    )
)

(defrule rule-r079
    (declare (salience 10))
    (ingredient (name "Фарш овощной") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Томаты спелые") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Петрушка кудрявая") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Начинка овощная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 5 ?c3 6) 0.52))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Начинка овощная CF=" ?res))))
    )
)

(defrule rule-r080
    (declare (salience 10))
    (ingredient (name "Начинка сладкая") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Основа для десерта") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 3 ?c3 2) 0.68))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Основа для десерта CF=" ?res))))
    )
)

(defrule rule-r081
    (declare (salience 10))
    (ingredient (name "Тесто для пиццы выброженное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус томатный ароматный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Основа пиццы готовая") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 7 ?c3 9) 0.51))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Основа пиццы готовая CF=" ?res))))
    )
)

(defrule rule-r082
    (declare (salience 10))
    (ingredient (name "Тесто для пасты") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Паста свежая") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 4 ?c3 2) 0.56))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Паста свежая CF=" ?res))))
    )
)

(defrule rule-r083
    (declare (salience 10))
    (ingredient (name "Соус томатный ароматный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус для пасты") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 9 ?c3 2) 0.91))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус для пасты CF=" ?res))))
    )
)

(defrule rule-r084
    (declare (salience 10))
    (ingredient (name "Соус бешамель") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соус для мяса") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 1 ?c3 5) 0.96))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соус для мяса CF=" ?res))))
    )
)

(defrule rule-r085
    (declare (salience 10))
    (ingredient (name "Фарш для котлет") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Панировка") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Котлеты сырые") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 2 ?c3 9) 0.89))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Котлеты сырые CF=" ?res))))
    )
)

(defrule rule-r086
    (declare (salience 10))
    (ingredient (name "Рис басмати") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Бульон концентрированный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Гарнир рисовый подготовленный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 3 ?c3 2) 0.69))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Гарнир рисовый подготовленный CF=" ?res))))
    )
)

(defrule rule-r087
    (declare (salience 10))
    (ingredient (name "Овощная нарезка") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Заправка винегрет") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощи для салата") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 8 ?c3 6) 0.17))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощи для салата CF=" ?res))))
    )
)

(defrule rule-r088
    (declare (salience 10))
    (ingredient (name "Мясо маринованное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Маринад пряный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Мясо для жарки") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 5 ?c3 2) 0.27))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Мясо для жарки CF=" ?res))))
    )
)

(defrule rule-r089
    (declare (salience 10))
    (ingredient (name "Рыба подготовленная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Кляр пивной") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Рыба для запекания") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 5 ?c3 8) 0.6))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Рыба для запекания CF=" ?res))))
    )
)

(defrule rule-r090
    (declare (salience 10))
    (ingredient (name "Тесто формованное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тесто для выпечки") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 3 ?c3 9) 0.97))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто для выпечки CF=" ?res))))
    )
)

(defrule rule-r091
    (declare (salience 10))
    (ingredient (name "Крем дипломат") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Мед цветочный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Крем кондитерский") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 6 ?c3 7) 0.97))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Крем кондитерский CF=" ?res))))
    )
)

(defrule rule-r092
    (declare (salience 10))
    (ingredient (name "Овощи тушеные") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Овощная смесь тушеная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 3 ?c3 7) 0.85))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Овощная смесь тушеная CF=" ?res))))
    )
)

(defrule rule-r093
    (declare (salience 10))
    (ingredient (name "Начинка мясная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Лук красный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Мясная смесь фаршированная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 5 ?c3 1) 0.83))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Мясная смесь фаршированная CF=" ?res))))
    )
)

(defrule rule-r094
    (declare (salience 10))
    (ingredient (name "Соус голландез") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус для пасты") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Соусная композиция") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 5 ?c3 7) 0.62))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Соусная композиция CF=" ?res))))
    )
)

(defrule rule-r095
    (declare (salience 10))
    (ingredient (name "Основа для десерта") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сахар тростниковый") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Яйца категории С0") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Десертная основа") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 6 ?c3 7) 0.61))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Десертная основа CF=" ?res))))
    )
)

(defrule rule-r096
    (declare (salience 10))
    (ingredient (name "Основа пиццы готовая") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Томаты спелые") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Пицца Маргарита свежая") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 9 ?c3 4) 0.82))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Пицца Маргарита свежая CF=" ?res))))
    )
)

(defrule rule-r097
    (declare (salience 10))
    (ingredient (name "Паста свежая") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус для пасты") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Паста Карбонара") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 7 ?c3 6) 0.57))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Паста Карбонара CF=" ?res))))
    )
)

(defrule rule-r098
    (declare (salience 10))
    (ingredient (name "Овощи для салата") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Котлеты сырые") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сырная стружка") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Салат Цезарь классический") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 7 ?c3 8) 0.28))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Салат Цезарь классический CF=" ?res))))
    )
)

(defrule rule-r099
    (declare (salience 10))
    (ingredient (name "Бульон куриный процеженный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лимоны свежие") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Суп Том Ям") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 8 ?c3 4) 0.19))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Суп Том Ям CF=" ?res))))
    )
)

(defrule rule-r100
    (declare (salience 10))
    (ingredient (name "Мясо для жарки") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Стейк Рибай medium rare") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 8 ?c3 4) 0.98))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Стейк Рибай medium rare CF=" ?res))))
    )
)

(defrule rule-r101
    (declare (salience 10))
    (ingredient (name "Гарнир рисовый подготовленный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Овощи для салата") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Роллы Калифорния") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 2 ?c3 5) 0.98))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Роллы Калифорния CF=" ?res))))
    )
)

(defrule rule-r102
    (declare (salience 10))
    (ingredient (name "Котлеты сырые") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Тесто для выпечки") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бургер Чизбургер") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 4 ?c3 9) 0.83))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бургер Чизбургер CF=" ?res))))
    )
)

(defrule rule-r103
    (declare (salience 10))
    (ingredient (name "Тесто для выпечки") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Начинка мясная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соус сырный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тако с говядиной") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 10 ?c3 10) 0.44))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тако с говядиной CF=" ?res))))
    )
)

(defrule rule-r104
    (declare (salience 10))
    (ingredient (name "Бульон куриный процеженный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Рыба для запекания") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лук красный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Рамен с курицей") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 6 ?c3 10) 0.87))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Рамен с курицей CF=" ?res))))
    )
)

(defrule rule-r105
    (declare (salience 10))
    (ingredient (name "Гарнир рисовый подготовленный") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Начинка мясная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лук красный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Плов узбекский") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 3 ?c3 4) 0.54))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Плов узбекский CF=" ?res))))
    )
)

(defrule rule-r106
    (declare (salience 10))
    (ingredient (name "Овощная смесь тушеная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Мясная смесь фаршированная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соусная композиция") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Лазанья мясная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 1 ?c3 5) 0.93))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Лазанья мясная CF=" ?res))))
    )
)

(defrule rule-r107
    (declare (salience 10))
    (ingredient (name "Фарш для пельменей") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Тесто раскатанное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Пельмени сибирские") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 8 ?c2 4 ?c3 1) 0.3))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Пельмени сибирские CF=" ?res))))
    )
)

(defrule rule-r108
    (declare (salience 10))
    (ingredient (name "Мясо маринованное") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Овощи гриль") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Курица гриль") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 1 ?c3 9) 0.66))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Курица гриль CF=" ?res))))
    )
)

(defrule rule-r109
    (declare (salience 10))
    (ingredient (name "Рыба в кляре") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Овощи тушеные") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лимоны свежие") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Рыба запеченная с лимоном") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 8 ?c3 1) 0.34))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Рыба запеченная с лимоном CF=" ?res))))
    )
)

(defrule rule-r110
    (declare (salience 10))
    (ingredient (name "Яичная смесь") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Начинка овощная") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Омлет с овощами") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 2 ?c3 10) 0.15))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Омлет с овощами CF=" ?res))))
    )
)

(defrule rule-r111
    (declare (salience 10))
    (ingredient (name "Пицца Маргарита свежая") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Пицца Маргарита запеченная") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 10 ?c3 8) 0.43))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Пицца Маргарита запеченная CF=" ?res))))
    )
)

(defrule rule-r112
    (declare (salience 10))
    (ingredient (name "Паста Карбонара") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сырная стружка") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Орегано сушеный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Паста Карбонара с трюфелем") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 3 ?c3 8) 0.83))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Паста Карбонара с трюфелем CF=" ?res))))
    )
)

(defrule rule-r113
    (declare (salience 10))
    (ingredient (name "Салат Цезарь классический") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Рыба для запекания") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Заправка винегрет") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Салат Цезарь с креветками") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 3 ?c3 8) 0.98))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Салат Цезарь с креветками CF=" ?res))))
    )
)

(defrule rule-r114
    (declare (salience 10))
    (ingredient (name "Суп Том Ям") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Мед цветочный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Суп Том Ям кокосовый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 2 ?c3 1) 0.39))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Суп Том Ям кокосовый CF=" ?res))))
    )
)

(defrule rule-r115
    (declare (salience 10))
    (ingredient (name "Стейк Рибай medium rare") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус для мяса") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Базилик свежий") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Стейк Рибай с соусом") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 8 ?c3 7) 0.58))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Стейк Рибай с соусом CF=" ?res))))
    )
)

(defrule rule-r116
    (declare (salience 10))
    (ingredient (name "Роллы Калифорния") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Роллы Калифорния премиум") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 7 ?c3 4) 0.19))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Роллы Калифорния премиум CF=" ?res))))
    )
)

(defrule rule-r117
    (declare (salience 10))
    (ingredient (name "Бургер Чизбургер") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Котлеты сырые") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бургер Чизбургер двойной") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 6 ?c3 8) 0.18))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бургер Чизбургер двойной CF=" ?res))))
    )
)

(defrule rule-r118
    (declare (salience 10))
    (ingredient (name "Тако с говядиной") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соус сырный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Перец черный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Тако с говядиной острейшие") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 4 ?c3 5) 0.93))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тако с говядиной острейшие CF=" ?res))))
    )
)

(defrule rule-r119
    (declare (salience 10))
    (ingredient (name "Рамен с курицей") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Чеснок свежий") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лимоны свежие") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Рамен с курицей пикантный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 1 ?c3 5) 0.16))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Рамен с курицей пикантный CF=" ?res))))
    )
)

(defrule rule-r120
    (declare (salience 10))
    (ingredient (name "Плов узбекский") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло оливковое") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Плов узбекский праздничный") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 2 ?c2 5 ?c3 4) 0.57))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Плов узбекский праздничный CF=" ?res))))
    )
)

(defrule rule-r121
    (declare (salience 10))
    (ingredient (name "Пицца Маргарита запеченная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Паста Карбонара с трюфелем") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Салат Цезарь с креветками") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Итальянский ужин премиум") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 6 ?c3 3) 0.48))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Итальянский ужин премиум CF=" ?res))))
    )
)

(defrule rule-r122
    (declare (salience 10))
    (ingredient (name "Роллы Калифорния премиум") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Суп Том Ям кокосовый") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Рамен с курицей пикантный") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Азиатский сет делюкс") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 4 ?c3 5) 0.49))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Азиатский сет делюкс CF=" ?res))))
    )
)

(defrule rule-r123
    (declare (salience 10))
    (ingredient (name "Тако с говядиной острейшие") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Бургер Чизбургер двойной") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Тако с говядиной") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Мексиканская фиеста") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 6 ?c3 9) 0.16))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Мексиканская фиеста CF=" ?res))))
    )
)

(defrule rule-r124
    (declare (salience 10))
    (ingredient (name "Стейк Рибай с соусом") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Плов узбекский праздничный") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Пицца Маргарита запеченная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Праздничный гала-ужин") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 9 ?c3 9) 0.12))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Праздничный гала-ужин CF=" ?res))))
    )
)

(defrule rule-r125
    (declare (salience 10))
    (ingredient (name "Лазанья мясная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Салат Цезарь с креветками") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Паста Карбонара с трюфелем") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Семейный обед выходного дня") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 1 ?c2 7 ?c3 1) 0.42))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Семейный обед выходного дня CF=" ?res))))
    )
)

(defrule rule-r126
    (declare (salience 10))
    (ingredient (name "Пицца Маргарита запеченная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Стейк Рибай с соусом") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Десертная основа") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Романтический ужин") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 6 ?c3 2) 0.83))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Романтический ужин CF=" ?res))))
    )
)

(defrule rule-r127
    (declare (salience 10))
    (ingredient (name "Паста Карбонара с трюфелем") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Роллы Калифорния премиум") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Салат Цезарь классический") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Бизнес-ланч премиум") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 8 ?c3 4) 0.77))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Бизнес-ланч премиум CF=" ?res))))
    )
)

(defrule rule-r128
    (declare (salience 10))
    (ingredient (name "Омлет с овощами") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Пельмени сибирские") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Начинка сладкая") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Детский праздничный набор") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 5 ?c2 8 ?c3 9) 0.9))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Детский праздничный набор CF=" ?res))))
    )
)

(defrule rule-r129
    (declare (salience 10))
    (ingredient (name "Салат Цезарь с креветками") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Рыба запеченная с лимоном") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Овощная смесь тушеная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Вегетарианское комбо") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 6 ?c2 4 ?c3 10) 0.67))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Вегетарианское комбо CF=" ?res))))
    )
)

(defrule rule-r130
    (declare (salience 10))
    (ingredient (name "Пицца Маргарита запеченная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Паста Карбонара с трюфелем") (certainty ?c2&:(> ?c2 0.1)))
    (ingredient (name "Лазанья мясная") (certainty ?c3&:(> ?c3 0.1)))
    ?f <- (ingredient (name "Шведский стол домашний") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 7 ?c3 9) 0.15))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Шведский стол домашний CF=" ?res))))
    )
)

(defrule rule-r131
    (declare (salience 10))
    (ingredient (name "Смесь муки и соли") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Вода фильтрованная") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Мука пшеничная в/с") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 2) 0.65))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Мука пшеничная в/с CF=" ?res))))
    )
)

(defrule rule-r132
    (declare (salience 10))
    (ingredient (name "Сахарный сироп") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Соль йодированная") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Сахар тростниковый") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 10 ?c2 5) 0.82))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Сахар тростниковый CF=" ?res))))
    )
)

(defrule rule-r133
    (declare (salience 10))
    (ingredient (name "Яичная смесь") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Молоко пастеризованное") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Яйца категории С0") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 6) 0.91))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Яйца категории С0 CF=" ?res))))
    )
)

(defrule rule-r134
    (declare (salience 10))
    (ingredient (name "Тесто дрожжевое базовое") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Масло сливочное") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Смесь муки и соли") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 7 ?c2 4) 0.61))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Смесь муки и соли CF=" ?res))))
    )
)

(defrule rule-r135
    (declare (salience 10))
    (ingredient (name "Основа пиццы готовая") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Сыр Моцарелла") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Тесто для пиццы выброженное") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 9 ?c2 9) 0.22))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Тесто для пиццы выброженное CF=" ?res))))
    )
)

(defrule rule-r136
    (declare (salience 10))
    (ingredient (name "Пицца Маргарита свежая") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Томаты спелые") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Основа пиццы готовая") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 3 ?c2 5) 0.13))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Основа пиццы готовая CF=" ?res))))
    )
)

(defrule rule-r137
    (declare (salience 10))
    (ingredient (name "Пицца Маргарита запеченная") (certainty ?c1&:(> ?c1 0.1)))
    (ingredient (name "Травяная смесь итальянская") (certainty ?c2&:(> ?c2 0.1)))
    ?f <- (ingredient (name "Пицца Маргарита свежая") (certainty ?cur-c))
    =>
    (bind ?res (* (weighted-avg ?c1 4 ?c2 7) 0.11))
    (if (> ?res ?cur-c) then
        (modify ?f (certainty (max-certainty ?cur-c ?res)) (type result))
        (assert (sendmessage (value (str-cat "ПРОЦЕСС: Пицца Маргарита свежая CF=" ?res))))
    )
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
