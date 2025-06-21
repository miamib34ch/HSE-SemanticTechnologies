;;**********************************************************
;;*    Определяем формат пиццы и добавляем в базу знаний   *
;;**********************************************************

;; добавляем в базу знаний ингредиенты (простые факты)
(deffacts any-ingredients 
  (best-main any)
  (best-add  any)
  (best-special any)
)

;; определяем шаблон составного факта
(deftemplate pizza
  (slot name (default ?NONE))                                                       ;; определяем поля структуры
  (slot main (default any))
  (slot add (default any))
  (slot special (default any))
)

;; добавляем в базу знаний меню пицц (составные факты)
(deffacts the-pizza-list 
  (pizza (name Sea-pizza) 
         (main fish) 
         (add shrimp)                                                               ;; поля, которые не передаём, заполнятся по-умолчанию   
  )                                
  (pizza (name Potato-with-salmon) 
         (main fish) 
         (add potatoes)
  )
  (pizza (name Branded-pizza) 
         (main pepperoni) 
         (special champignons)
  )
  (pizza (name Fire) 
         (main pepperoni) 
         (add jalapeno)
  )
  (pizza (name Pepperoni) 
         (main pepperoni)
  )
  (pizza (name Chicago) 
         (main pepperoni) 
         (add onion) 
         (special pepper)
  )
  (pizza (name Mexican) 
         (main pepperoni) 
         (add jalapeno) 
         (special tabasco)
  )
  (pizza (name Americano) 
         (main pepperoni) 
         (add onion)
  )
  (pizza (name French) 
         (main cheese) 
         (add blue-cheese)
  )
  (pizza (name Mascarpone) 
         (main cheese) 
         (special nuts)
  )
  (pizza (name Rockforte) 
         (main cheese) 
         (add blue-cheese) 
         (special pineapple)
  )
  (pizza (name OnlyCheese) 
         (main cheese)
  )
  (pizza (name Assorted) 
         (main chicken) 
         (add tomatoes) 
         (special champignons)
  )
  (pizza (name Village) 
         (main chicken) 
         (add champignons) 
         (special opyata)
  )
  (pizza (name Julien) 
         (main chicken) 
         (add champignons) 
         (special garlic)
  )
  (pizza (name Chicken) 
         (main chicken) 
         (add tomatoes)
  )
  (pizza (name ChickenPineapple) 
         (main chicken) 
         (special pineapple)
  )
)



;;**********************************************************
;;*       Определяем функцию для задавания вопросов        *
;;**********************************************************

(deffunction ask-question (?question $?allowed-values)                              ;; на вход которой поступает вопрос (обязательный параметр) и допустимые варианты ответов (групповой параметр)
  (printout t ?question)                                                            ;; печать вопроса
  (bind ?answer (read))                                                             ;; считываем введённый ответ
  (if                                                                               ;; проверяем введённое значение, если это строка, то символы преобразуются в строчные
    (lexemep ?answer) 
   then 
    (bind ?answer (lowcase ?answer))
  )                     
  (while (not (member$ ?answer ?allowed-values)) do                                 ;; цикл, суть которого заключается в следующем: пока пользователь не введёт допустимый ответ, система будет повторять вопрос
    (printout t ?question)
    (bind ?answer (read))
    (if 
      (lexemep ?answer) 
     then 
      (bind ?answer (lowcase ?answer))
    )
  )
  ?answer
)



;;**********************************************************
;;*   Задаём правила - спрашиваем вопросы у пользователя   *
;;**********************************************************

(defrule likes-vegetarian
  (not (vegetarian ?))                                                              ;; проверяем, что у нас нет такого факта
  =>
  ;; в качестве следствия сообщаем системе, что введённый ответ нужно записать в базу фактов по соответствующим названием (vegetarian)
  ;; в качестве подсказки для пользователя после вопроса лучше указать, какие ответы вы ожидаете
  (assert (vegetarian (ask-question "Предпочитаете вегетарианскую пиццу? yes/no " yes no)))
)

(defrule likes-seafood
  (and (vegetarian no) (not (seafood ?)))                                           ;; несколько условий через and
  =>
  (assert (seafood (ask-question "Любите морепродукты? yes/no " yes no)))
)

(defrule prefers-main
  (and (vegetarian no) (seafood no))
  =>
  (assert (best-main (ask-question "Предпочитаете пепперони или курицу? pepperoni/chicken " pepperoni chicken)))
)

(defrule extra-cheese
  (not (extra-cheese ?))
  =>
  (assert (extra-cheese (ask-question "Желаете дополнительную порцию сыра? yes/no " yes no)))
)

(defrule likes-mushrooms
  (and (or (best-main pepperoni) (best-main chicken)) (not (mushrooms ?)))          ;; одно из условий с or
  =>
  (assert (mushrooms (ask-question "Любите грибы? yes/no " yes no)))
)

(defrule likes-spicy
  (and (or (best-main pepperoni) (best-main chicken)) (not (spicy ?)))
  =>
  (assert (spicy (ask-question "Любите поострее? yes/no " yes no)))
)

(defrule likes-nuts
  (not (nuts ?))
  =>
  (assert (nuts (ask-question "Любите орешки? yes/no " yes no)))
)

(defrule likes-pineapple
  (not (pineapple ?))
  =>
  (assert (pineapple (ask-question "Любите ананасы? yes/no " yes no)))
)



;;**********************************************************
;;*        Задаём оставшиеся факты на основе правил        *
;;**********************************************************

(defrule best-main-cheese
  (vegetarian yes)
  =>
  (assert (best-main cheese))
)

(defrule best-main-fish
  (seafood yes)
  =>
  (assert (best-main fish))
)

(defrule best-add-potatoes
  (and (best-main fish) (extra-cheese no))
  =>
  (assert (best-add potatoes))
)

(defrule best-add-shrimp
  (and (best-main fish) (extra-cheese yes))
  =>
  (assert (best-add shrimp))
)

(defrule best-add-blue-cheese
  (and (best-main cheese) (extra-cheese yes))
  =>
  (assert (best-add blue-cheese))
)

(defrule best-add-onion
  (and (best-main pepperoni) (extra-cheese yes))
  =>
  (assert (best-add onion))
)

(defrule best-add-jalapeno
  (and (best-main pepperoni) (extra-cheese no))
  =>
  (assert (best-add jalapeno))
)

(defrule best-add-tomatoes
  (and (best-main chicken) (extra-cheese no))
  =>
  (assert (best-add tomatoes))
)

(defrule best-add-champignons
  (and (extra-cheese yes) (mushrooms yes))
  =>
  (assert (best-add champignons))
)

(defrule best-special-tabasco
  (and (best-add jalapeno) (spicy yes))
  =>
  (assert (best-special tabasco))
)

(defrule best-special-nuts
  (nuts yes)
  =>
  (assert (best-special nuts))
)

(defrule best-special-pineapple
  (pineapple yes)
  =>
  (assert (best-special pineapple))
)

(defrule best-special-pepper
  (and (best-add onion) (spicy yes))
  =>
  (assert (best-special pepper))
)

(defrule best-special-champignons
  (and (best-add tomatoes) (mushrooms yes))
  =>
  (assert (best-special champignons))
)

(defrule best-special-garlic
  (and (best-add champignons) (spicy yes))
  =>
  (assert (best-special garlic))
)

(defrule best-special-opyata
  (and (best-add champignons) (spicy no))
  =>
  (assert (best-special opyata))
)


;;**********************************************************
;;*         На основе всех фактов определяем пиццу         *
;;**********************************************************

;; определяем итоговую пиццу
(defrule pizza-check
  (pizza (name ?name) (main ?m) (add ?a) (special ?s))                              ;; определяем параметры пиццы
  (best-main ?m)                                                                    ;; сравниваем параметры с фактами
  (best-add ?a)
  (best-special ?s)
  =>
  (assert (final-pizza ?name))
)

;; обрабатываем ситуацию с отсуствием пиццы
(defrule no-pizza
  (declare (salience -1))                                                           ;; устанавливаем приоритет -1, чтобы проверка отсуствия нужной пиццы проходила в конце
  (not (final-pizza ?))
  =>
  (assert (final-pizza "У нас нет подходящей для вас пиццы"))
)

(defrule print-pizza
  (declare (salience -2))                                                           ;; приоритет ещё меньше, чтобы в самом конце выполнялось
  (final-pizza ?name)	
  =>
  (printout t crlf "Подходящая под условия пицца: ")                                ;; crlf - перевод строки
  (format t "%s%n" ?name)
  (halt)
)

