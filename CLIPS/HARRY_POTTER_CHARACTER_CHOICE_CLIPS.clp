;; Экспертная система на CLIPS - подбор персонажа из Гарри Поттера


;; Шаблон составного факта - персонаж
(deftemplate character
   (slot name)
   (slot house)
   (slot gender)
   (slot adventures)
   (slot study)
   (slot sports)
   (slot rules)
   (slot ambition)
   (slot leadership)
   (slot extravagance)
   (slot animals)
   (slot friendship)
   (slot power)
   (slot intuition)
   (slot score (default 0))                                                      ;; для определения количества совпадений с пользователем
)

;; Факты о персонажах, заполняем базу знаний
(deffacts characters
   (character (name "Гарри Поттер") (house красный) (gender м)
              (adventures да) (study нет) (sports да) (rules нет)
              (ambition нет) (leadership да) (extravagance нет)
              (animals да) (friendship да) (power нет) (intuition да)
   )
   (character (name "Рон Уизли") (house красный) (gender м)
              (adventures да) (study нет) (sports да) (rules нет)
              (ambition нет) (leadership нет) (extravagance нет)
              (animals да) (friendship да) (power нет) (intuition да)
   )
   (character (name "Фред Уизли") (house красный) (gender м)
              (adventures да) (study нет) (sports да) (rules нет)
              (ambition да) (leadership да) (extravagance да)
              (animals нет) (friendship да) (power нет) (intuition да)
   )
   (character (name "Джордж Уизли") (house красный) (gender м)
              (adventures да) (study нет) (sports да) (rules нет)
              (ambition да) (leadership нет) (extravagance да)
              (animals нет) (friendship да) (power нет) (intuition да)
   )
   (character (name "Рубеус Хагрид") (house красный) (gender м)
              (adventures да) (study нет) (sports нет) (rules нет)
              (ambition нет) (leadership нет) (extravagance да)
              (animals да) (friendship да) (power нет) (intuition да)
   )
   (character (name "Альбус Дамблдор") (house красный) (gender м)
              (adventures да) (study да) (sports нет) (rules нет)
              (ambition да) (leadership да) (extravagance да)
              (animals нет) (friendship да) (power нет) (intuition нет)
   )
   (character (name "Невилл Долгопупс") (house красный) (gender м)
              (adventures нет) (study да) (sports нет) (rules да)
              (ambition нет) (leadership нет) (extravagance нет)
              (animals нет) (friendship да) (power нет) (intuition нет)
   )
   (character (name "Гермиона Грейнджер") (house красный) (gender ж)
              (adventures нет) (study да) (sports нет) (rules да)
              (ambition да) (leadership да) (extravagance нет)
              (animals да) (friendship да) (power нет) (intuition нет)
   )
   (character (name "Минерва Макгонагалл") (house красный) (gender ж)
              (adventures нет) (study да) (sports да) (rules да)
              (ambition да) (leadership да) (extravagance нет)
              (animals нет) (friendship да) (power нет) (intuition нет)
   )
   (character (name "Джинни Уизли") (house красный) (gender ж)
              (adventures да) (study нет) (sports да) (rules нет)
              (ambition нет) (leadership нет) (extravagance нет)
              (animals нет) (friendship да) (power нет) (intuition да)
   )
   (character (name "Сиверус Снегг") (house зелёный) (gender м)
              (adventures нет) (study да) (sports нет) (rules нет)
              (ambition да) (leadership нет) (extravagance да)
              (animals нет) (friendship нет) (power нет) (intuition нет)
   )
   (character (name "Волан-де-Морт") (house зелёный) (gender м)
              (adventures нет) (study да) (sports нет) (rules нет)
              (ambition да) (leadership да) (extravagance да)
              (animals нет) (friendship нет) (power да) (intuition нет)
   )
   (character (name "Драко Малфой") (house зелёный) (gender м)
              (adventures нет) (study нет) (sports да) (rules нет)
              (ambition да) (leadership да) (extravagance нет)
              (animals нет) (friendship нет) (power да) (intuition да)
   )
   (character (name "Панси Паркинсон") (house зелёный) (gender ж)
              (adventures нет) (study нет) (sports нет) (rules да)
              (ambition да) (leadership нет) (extravagance нет)
              (animals нет) (friendship нет) (power нет) (intuition нет)
   )
   (character (name "Луна Лавгуд") (house синий) (gender ж)
              (adventures да) (study нет) (sports нет) (rules нет)
              (ambition нет) (leadership нет) (extravagance да)
              (animals да) (friendship да) (power нет) (intuition да)
   )
   (character (name "Чо Чанг") (house синий) (gender ж)
              (adventures нет) (study да) (sports да) (rules да)
              (ambition нет) (leadership нет) (extravagance нет)
              (animals нет) (friendship да) (power нет) (intuition нет)
   )
   (character (name "Седрик Диггори") (house жёлтый) (gender м)
              (adventures да) (study да) (sports да) (rules да)
              (ambition да) (leadership да) (extravagance нет)
              (animals нет) (friendship да) (power нет) (intuition нет)
   )
   (character (name "Ханна Эббот") (house жёлтый) (gender ж)
              (adventures да) (study да) (sports нет) (rules да)
              (ambition нет) (leadership нет) (extravagance нет)
              (animals да) (friendship да) (power нет) (intuition нет)
   )
)

;; Флаг завершённых вопросов, для предотвращения повторных вопросов
(deftemplate answered (slot question))


;; Функции для задавания вопросов
(deffunction askYesNo (?prompt)
   (printout t ?prompt " (да/нет): ")
   (bind ?answer (read))
   (if (or (eq ?answer да) (eq ?answer нет))
       then (return ?answer)
       else 
         (printout t "Введите 'да' или 'нет'." crlf)
         (return (askYesNo ?prompt))
   )
)

(deffunction askHouse ()
   (printout t "Ваш любимый цвет?" crlf
               "красный / зелёный / синий / жёлтый: ")
   (bind ?col (read))
   (if (or (eq ?col красный) (eq ?col зелёный) (eq ?col синий) (eq ?col жёлтый))
       then (return ?col)
       else
         (printout t "Выберите один из перечисленных." crlf)
         (return (askHouse))
   )
)

(deffunction askGender ()
   (printout t "Ваш пол (м/ж): ")
   (bind ?g (read))
   (if (or (eq ?g м) (eq ?g ж))
       then (return ?g)
       else
         (printout t "Введите 'м' или 'ж'." crlf)
         (return (askGender))
   )
)


;; Задаём правила - вопросы пользователю
(defrule ask-house
   (not (answered (question house)))
   =>
   (assert (user-house (askHouse)))
   (assert (answered (question house)))
)

(defrule ask-gender
   (not (answered (question gender)))
   =>
   (assert (user-gender (askGender)))
   (assert (answered (question gender)))
)

(defrule ask-adventures
   (not (answered (question adventures)))
   =>
   (assert (user-adventures (askYesNo "Нравятся ли тебе приключения?")))
   (assert (answered (question adventures)))
)

(defrule ask-study
   (not (answered (question study)))
   =>
   (assert (user-study (askYesNo "Любишь учиться?")))
   (assert (answered (question study)))
)

(defrule ask-sports
   (not (answered (question sports)))
   =>
   (assert (user-sports (askYesNo "Увлекаешься ли спортом?")))
   (assert (answered (question sports)))
)

(defrule ask-rules
   (not (answered (question rules)))
   =>
   (assert (user-rules (askYesNo "Строго ли соблюдаешь правила?")))
   (assert (answered (question rules)))
)

(defrule ask-ambition
   (not (answered (question ambition)))
   =>
   (assert (user-ambition (askYesNo "Амбициозный ли ты?")))
   (assert (answered (question ambition)))
)

(defrule ask-leadership
   (not (answered (question leadership)))
   =>
   (assert (user-leadership (askYesNo "Любишь быть в центре внимания?")))
   (assert (answered (question leadership)))
)

(defrule ask-extravagance
   (not (answered (question extravagance)))
   =>
   (assert (user-extravagance (askYesNo "Считают ли тебя странным?")))
   (assert (answered (question extravagance)))
)

(defrule ask-animals
   (not (answered (question animals)))
   =>
   (assert (user-animals (askYesNo "Любишь ли животных и магических существ?")))
   (assert (answered (question animals)))
)

(defrule ask-friendship
   (not (answered (question friendship)))
   =>
   (assert (user-friendship (askYesNo "Дорожишь ли ты дружбой и верностью друзьям?")))
   (assert (answered (question friendship)))
)

(defrule ask-power
   (not (answered (question power)))
   =>
   (assert (user-power (askYesNo "Стремишься ли ты к власти и влиянию?")))
   (assert (answered (question power)))
)

(defrule ask-intuition
   (not (answered (question intuition)))
   =>
   (assert (user-intuition (askYesNo "Ты полагаешься на интуицию больше, чем на логику?")))
   (assert (answered (question intuition)))
)


;; Правила начисления баллов, (salience -1) чтобы выполнялось после вопросов
(defrule score-adventures
   (declare (salience -1))
   ?u <- (user-adventures ?val)                                                  ;; сохраняем ссылку для последующего удаления + добавляем локальную переменную значения
   (user-house ?uh) (user-gender ?ug)                                            ;; добавляем ещё локальные переменные, на прямую использовать факты в сравнении нельзя
   ?c <- (character (house ?uh) (gender ?ug) (adventures ?val) (score ?s))       ;; фильтруем всех персонажей по трём критериям
   =>
   (modify ?c (score (+ ?s 1)))                                                  ;; увеличиваем у найденных персонажей совпадения на 1
   (retract ?u)                                                                  ;; удаляем значение, чтобы начисление баллов больше не вызывалось
)

(defrule score-study
   (declare (salience -1))
   ?u <- (user-study ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (study ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-sports
   (declare (salience -1))
   ?u <- (user-sports ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (sports ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-rules
   (declare (salience -1))
   ?u <- (user-rules ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (rules ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-ambition
   (declare (salience -1))
   ?u <- (user-ambition ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (ambition ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-leadership
   (declare (salience -1))
   ?u <- (user-leadership ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (leadership ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-extravagance
   (declare (salience -1))
   ?u <- (user-extravagance ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (extravagance ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-animals
   (declare (salience -1))
   ?u <- (user-animals ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (animals ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-friendship
   (declare (salience -1))
   ?u <- (user-friendship ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (friendship ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-power
   (declare (salience -1))
   ?u <- (user-power ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (power ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)

(defrule score-intuition
   (declare (salience -1))
   ?u <- (user-intuition ?val)
   (user-house ?uh) (user-gender ?ug)
   ?c <- (character (house ?uh) (gender ?ug) (intuition ?val) (score ?s))
   =>
   (modify ?c (score (+ ?s 1)))
   (retract ?u)
)


;; Итоговый выбор персонажа
(defrule choose-character
   (declare (salience -2))
   ?best <- (character (score ?sc) (name ?nm))
   (not (character (score ?sc2&:(> ?sc2 ?sc))))                                  ;; проверяем на персонажа с наибольшим score - если найдётся персонаж с score больше чем текущий, то вывод для текущего не срабатывает
   =>
   (printout t crlf "*** Результат ***" crlf
             "Персонаж, наиболее похожий на вас: " ?nm crlf)
   (halt)                                                                        ;; прерываем программу после первого вывода, чтобы, если найдены одинаковые максимальные score, программа написала только одного персонажа
)
