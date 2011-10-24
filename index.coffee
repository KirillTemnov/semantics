sys = require "sys"

ruFemNames = ["Августа", "Августина", "Авдотья", "Авелина", "Аврелия", "Аврора", "Агапия", "Агата", "Агафья", "Агафия", "Аглаида", "Аглая", "Агнеса", "Агнесса", "Агния", "Агриппина", "Агрефена", "Ада", "Адель", "Аделия", "Аделаида", "Аза", "Азалия", "Аида", "Акилина", "Акулина", "Аксинья", "Алевтина", "Александра", "Алёна", "Алина", "Алиса", "Алла", "Альбина", "Альвина", "Анастасия", "Анатолия", "Ангелина", "Анжела", "Анимаиса", "Анисия", "Анисья", "Анита", "Анна", "Антонина", "Антонида", "Антония", "Анфиса", "Анфуса", "Анфия", "Ариадна", "Арина", "Аркадия", "Арсения", "Артемия", "Аста", "Астра", "Астрид", "Афанасия", "Афродита", "Аэлита", "Аэлла", "Бажена", "Беата", "Беатриса", "Бела", "Белла", "Берта", "Богдана", "Болеслава", "Борислава", "Бронислава", "Валентина", "Валерия", "Ванда", "Варвара", "Василина", "Василиса", "Васса", "Вацлава", "Вевея", "Венера", "Вера", "Вероника", "Веселина", "Веста", "Видана", "Викторина", "Виктория", "Вилена", "Вилора", "Вилория", "Виола", "Виолетта", "Виоланта", "Виринея", "Виталия", "Виталина", "Влада", "Владилена", "Владимира", "Владислава", "Владлена", "Власта", "Воля", "Всеслава", "Гайя", "Гали", "Галина", "Ганна", "Гаяна", "Гаяния", "Гелена", "Гелия", "Гелла", "Гертруда", "Глафира", "Гликерия", "Глория", "Горислава", "Дайна", "Дана", "Дарья", "Дария", "Дарина", "Дарьяна", "Декабрина", "Дея", "Дия", "Джульетта", "Диана", "Дина", "Диния", "Диодора", "Дионисия", "Добрава", "Домна", "Домина", "Домника", "Доминика", "Донара", "Дорофея", "Доротея", "Ева", "Евгения", "Евдокия", "Евлалия", "Евпраксия", "Евстолия", "Евфалия", "Екатерина", "Елена", "Елизавета", "Еликонида", "Ермиония", "Ефимия", "Евфимия", "Ефросиния", "Евфросиния", "Жанна", "Ждана", "Зара", "Зарема", "Зарина", "Зорина", "Звенислава", "Зинаида", "Зиновия", "Злата", "Зоя", "Иванна", "Ида", "Илария", "Илиана", "Илона", "Инга", "Инесса", "Инна", "Иоанна", "Иона", "Ипатия", "Ипполита", "Ираида", "Ироида", "Ираклия", "Ирина", "Исидора", "Искра", "Ифигения", "Ия", "Калерия", "Калиса", "Капитолина", "Карина", "Каролина", "Катерина", "Кира", "Кирилла", "Клавдия", "Клара", "Клариса", "Кларисса", "Клеопатра", "Конкордия", "Констанция", "Кристина", "Ксения", "Лада", "Лариса", "Лениана", "Ленина", "Леонида", "Леонила", "Леонтия", "Леся", "Ливия", "Лидия", "Лилиана", "Лилия", "Лина", "Лия", "Лея", "Лора", "Луиза", "Лукерия", "Лукиана", "Лукина", "Люцина", "Любава", "Любовь", "Любомира", "Людмила", "Мавра", "Магда", "Магдалина", "Мадлен", "Майя", "Мая", "Мальвина", "Маргарита", "Мариана", "Марьяна", "Марианна", "Мариетта", "Мариэтта", "Марина", "Мария", "Марья", "Мари", "Марлена", "Марта", "Марфа", "Матильда", "Матрёна", "Матрона", "Мелания", "Меланья", "Мелитина", "Милада", "Милана", "Милена", "Милица", "Милия", "Милослава", "Мира", "Мирра", "Мирослава", "Митродора", "Млада", "Мстислава", "Муза", "Нада", "Надежда", "Надия", "Наина", "Нана", "Настасья", "Наталья", "Наталия", "Нелли", "Неонила", "Ника", "Нина", "Нинелла", "Нинель", "Новелла", "Нонна", "Оксана", "Октавия", "Октябрина", "Олеся", "Оливия", "Олимпиада", "Олимпия", "Ольга", "Павла", "Павлина", "Пелагея", "Платонида", "Поликсена", "Полина", "Правдина", "Нора", "Прасковья", "Рада", "Радмила", "Раиса", "Раймонда", "Ревмира", "Регина", "Рената", "Римма", "Рогнеда", "Роза", "Розалия", "Розана", "Ростислава", "Руслана", "Руфина", "Руфь", "Сабина", "Савина", "Саломея", "Соломея", "Светлана", "Светозара", "Светослава", "Свобода", "Святослава", "Севастьяна", "Северина", "Селена", "Селина", "Серафима", "Сильва", "Сильвия", "Симона", "Слава", "Славяна", "Снежана", "Софья", "София", "Станислава", "Стелла", "Степанида", "Стефанида", "Стефания", "Сусанна", "Сосанна", "Сюзанна", "Таира", "Таисия", "Тальяна", "Тамара", "Тамила", "Томила", "Татьяна", "Текуса", "Тереза", "Улита", "Ульяна", "Услада", "Устинья", "Фаина", "Февронья", "Феликсана", "Фелицата", "Фелицитата", "Фелиция", "Федора", "Феодора", "Феодосия", "Феодосья", "Феоктиста", "Феофания", "Феона", "Флавия", "Флора", "Флория", "Флорентина", "Флоренция", "Флориана", "Фотина", "Харита", "Харитина", "Хиония", "Христина", "Цецилия", "Чеслава", "Эвелина", "Эвридика", "Эдда", "Элеонора", "Элина", "Эльвира", "Эльмира", "Эльза", "Эмилия", "Эмма", "Эрика", "Эсфирь", "Юдифь", "Юзефа", "Юлиана", "Юлитта", "Юлия", "Юманита", "Юния", "Юнона", "Юстина", "Ядвига", "Яна", "Янина", "Яромира", "Ярослава"].map (x) -> x.toLowerCase()

ruMaleNames = ["Абрам", "Август", "Авдей", "Адам", "Адольф", "Адриан", "Аким", "Александр", "Алексей", "Альберт", "Альфред", "Анатолий", "Андрей", "Аникита", "Антон", "Ануфрий", "Арам", "Арий", "Аристарх", "Аркадий", "Арнольд", "Арон", "Арсен", "Артем", "Артемий", "Артур", "Аскольд", "Афанасий", "Ахмет", "Ашот","Бенедикт", "Бернар", "Богдан", "Болеслав", "Бонифаций", "Борис", "Борислав", "Бронислав","Вадим", "Валентин", "Валерий", "Вальтер", "Василий", "Велор", "Венедикт", "Вениамин", "Виктор", "Вилли", "Вильгельм", "Виссарион", "Виталий", "Владимир", "Владислав", "Вольдемар", "Всеволод", "Вячеслав","Гавриил", "Гарри", "Геннадий", "Генрих", "Георгий", "Геральд", "Герасим", "Герман", "Глеб", "Гордей", "Градимир", "Григорий", "Гурий","Давыд", "Даниил", "Демид", "Демьян", "Денис", "Дмитрий", "Донат", "Дорофей","Евгений", "Евдоким", "Евстафий", "Егор", "Елисей", "Емельян", "Ермолай", "Ерофей", "Ефим", "Ефрем","Жорж","Захар", "Зигмунд", "Зиновий","Ибрагим", "Иван", "Игнат", "Игорь", "Измаил", "Израиль", "Илларион", "Илья", "Иннокентий", "Ион", "Иосиф", "Ираклий", "Исай","Казимир", "Карен", "Карл", "Кирилл", "Клавдий", "Клемент", "Клим", "Кондрат", "Конкордий", "Константин", "Кузьма","Лазарь", "Лев", "Леван", "Леонард", "Леонид", "Леонтий", "Леопольд", "Лука", "Любомир", "Людвиг","Май", "Макар", "Максим", "Максимилиан", "Марат", "Мариан", "Марк", "Мартин", "Матвей", "Мераб", "Мечеслав", "Мирон", "Мирослав", "Михаил", "Модест", "Моисей", "Мурат","Назар", "Натан", "Наум", "Никита", "Никифор", "Николай", "Никон", "Нисон", "Нифонт","Олег", "Олесь", "Онисим", "Орест", "Осип", "Оскар","Павел", "Парамон", "Петр", "Платон", "Прохор","Равиль", "Радий", "Рафик", "Рашид", "Ринат", "Ричард", "Роберт", "Родион", "Ролан", "Роман", "Ростислав", "Рубен", "Рудольф", "Руслан", "Рустам","Савва", "Савел", "Самсон", "Святослав", "Севастьян", "Семен", "Серафим", "Сергей", "Соломон", "Спартак", "Станислав", "Степан", "Стоян","Тамаз", "Тарас", "Теодор" , "Терентий", "Тигран", "Тимофей", "Тимур", "Тит", "Тихон", "Трифон", "Трофим","Устин","Федор", "Феликс", "Феодосий", "Филимон", "Филипп", "Фома", "Фридрих","Харитон", "Христиан", "Христофор","Эдуард", "Эльдар", "Эмиль", "Эммануил", "Эрик", "Эрнест","Юлиан", "Юрий","Яким", "Яков", "Ян", "Ярослав"].map (x) -> x.toLowerCase()


Capitalize = (s) -> if s then "#{s[0].toUpperCase()}#{s[1..].toLowerCase()}"

exports.inclineMaleName = inclineMaleName = (name) ->
  hardConsonants = "бвгдзклмнпрстфхжшц"
  hissingAndChe =  ["ж","ш","щ","ц","ч"]
  # nominative = yes
  # if name in ruMaleNames        # found!!!
  #   return name: name, cases: {}, src: name, found: yes

  name = Capitalize name
  validEndOfWord = ["а", "б", "в", "г", "д", "ж", "з", "и", "й", "к", "л", "м", "н", "п", "р", "с", "т", "ф", "х", "ь", "я", "ом", "ем", "ий", "ия", "ию", "ии", "ием"]



#  withoutEnd = name[..-2]

  if name.length > 2
    endOfWord = name[-2..]
    if endOfWord in validEndOfWord
      withoutEnd = name[..-3]
    else
      endOfWord = name[-1..]
  else
    endOfWord = name[-1..]


#  endOfWord = "" if endOfWord in hardConsonants
  lastLetter = name[-1..]
  if lastLetter in hardConsonants && 1 < endOfWord.length
    withoutEnd = name
  else
    withoutEnd = name[..-(1 + endOfWord.length)]

  # console.log "ll = #{lastLetter}\t eow = #{endOfWord}\t withoutEnd = #{withoutEnd} \n ll in hc #{lastLetter} in #{hardConsonants}"


  if endOfWord in hissingAndChe || endOfWord in ["а","у","e","ем"] && "ием" != name[-3..]
    console.log "#1"
    if "ем" == endOfWord
      withoutEnd = name[..-3]
    else if endOfWord in hissingAndChe
      withoutEnd = name
    cases = ["#{withoutEnd}", "#{withoutEnd}а", "#{withoutEnd}у", "#{withoutEnd}а", "#{withoutEnd}ем", "#{withoutEnd}е"]

  else if endOfWord in hardConsonants || ((withoutEnd[-1..] in hardConsonants) && endOfWord in ["а","у","е","ом"])
    console.log "#2"
    if "ом" == endOfWord
      withoutEnd = name[..-3]
    else if endOfWord in hardConsonants
      withoutEnd = name
    cases = ["#{withoutEnd}", "#{withoutEnd}а", "#{withoutEnd}у", "#{withoutEnd}а", "#{withoutEnd}ом", "#{withoutEnd}е"]

  else if endOfWord in ["ь", "й"]
    console.log "#3"
    cases = ["#{withoutEnd}#{endOfWord}", "#{withoutEnd}я", "#{withoutEnd}ю", "#{withoutEnd}я", "#{withoutEnd}ем", "#{withoutEnd}е"]

  else if endOfWord in ["ий", "ия", "ию", "ии", "ем"]
    console.log "#4"
    if "ем" == endOfWord        # ием
      withoutEnd = name[..-3]
    else
      withoutEnd += "и"
    cases = ["#{withoutEnd}й", "#{withoutEnd}я", "#{withoutEnd}ю", "#{withoutEnd}я", "#{withoutEnd}ем", "#{withoutEnd}и"]

  else
    console.log "#5"
    cases = [""]

  # todo add more exceptions here
  result = name: cases[0], cases: cases, src: name, found: cases[0].toLowerCase() in ruMaleNames

  result.possible_yes = result.found || endOfWord in validEndOfWord
  caseIndex = cases.indexOf name
  result.guess_case_index = caseIndex
  result.guess_case = if -1 == caseIndex then "unknown" else ["nominative","genitive","dative","accusative","instrumental","prepositional"][caseIndex]
  result



exports.inclineFemName = inclineFemName = (name) ->
  name = Capitalize name
  validEndOfWord = ["ч", "щ","ш","ж","ь","и","а","я","ы","ю","е","й","ю","ии","ия","ая","ей","ой","ию","йю","ью"]
  withoutEnd = name[..-2]


  if name.length > 2
    endOfWord = name[-2..]
    if endOfWord in validEndOfWord
      withoutEnd = name[..-3]
    else
      endOfWord = name[-1..]
  else
    endOfWord = name[-1..]

  lastLetter = withoutEnd[-1..]

  if endOfWord == "ь" || ( endOfWord == "ью" && !(withoutEnd[-1..] in "жшчщ"))
    cases = ["#{withoutEnd}ь", "#{withoutEnd}и", "#{withoutEnd}и", "#{withoutEnd}ь", "#{withoutEnd}ью", "#{withoutEnd}и"]
  else if endOfWord == "ью" && withoutEnd[-1..] in "жшчщ"
    cases = ["#{withoutEnd}", "#{withoutEnd}и", "#{withoutEnd}и", "#{withoutEnd}", "#{withoutEnd}ью", "#{withoutEnd}и"]

  else if endOfWord in "жшчщ"
    withoutEnd += endOfWord
    cases = ["#{withoutEnd}", "#{withoutEnd}и", "#{withoutEnd}и", "#{withoutEnd}", "#{withoutEnd}ью", "#{withoutEnd}и"]

  else if endOfWord in "ияюе"
    cases = ["#{withoutEnd}я", "#{withoutEnd}и", "#{withoutEnd}е", "#{withoutEnd}ю", "#{withoutEnd}ей", "#{withoutEnd}е"]
  else if lastLetter in  "жшчщцгкх"
    cases = ["#{withoutEnd}а", "#{withoutEnd}и", "#{withoutEnd}е", "#{withoutEnd}у", "#{withoutEnd}ой", "#{withoutEnd}е"]
  else
    cases = ["#{withoutEnd}а", "#{withoutEnd}ы", "#{withoutEnd}е", "#{withoutEnd}у", "#{withoutEnd}ой", "#{withoutEnd}е"]

  # todo add more exceptions here
  result = name: cases[0], found: cases[0].toLowerCase() in ruFemNames, cases: cases, src: name

  result.possible_yes = result.found || endOfWord in validEndOfWord
  caseIndex = cases.indexOf name
  result.guess_case_index = caseIndex
  result.guess_case = if -1 == caseIndex then "unknown" else ["nominative","genitive","dative","accusative","instrumental","prepositional"][caseIndex]
  result

inclineName = (name) ->
  fn = inclineFemName name
  mn = inclineMaleName name
#  console.log "fn = #{sys.inspect fn}\nmn = #{sys.inspect mn}"
  if fn.found                   # female
    result = {found: yes, src: name, gender: "female", guess_case: fn.guess_case, female_cases: fn.cases, nominative: fn.name}
  else if mn.found
    result = {found: yes, src: name, gender: "male", guess_case: mn.guess_case, male_cases: mn.cases, nominative: mn.name}
  else
    # word may be a name
    if fn.possible_yes && mn.possible_yes
      result = {found: "maybe", src: name, gender: ["male", "female"], female_cases: fn.cases, male_cases: mn.cases}
      result.guess_case = if fn.guess_case_index <= mn.guess_case_index then fn.guess_case else mn.guess_case
    else if fn.possible_yes
      result = {found: "maybe", src: name, gender: "female", female_cases: fn.cases, guess_case: fn.cases}
    else if mn.possible_yes
      result = {found: "maybe", src: name, gender: "male", male_cases: mn.cases, guess_case: mn.cases}
    else
      result = {found: no, src: name}
  result

inclineSurname = (surname, noInclinesRe, inclineRe, casesRe) ->
  result = found: null,  src: surname, cases: null, cases_index: null
  if noInclinesRe && noInclinesRe.test(surname)
    # cases: [surname, surname, surname, surname, surname, surname],
    result = found: surname,  src: surname, cases: ["nominative","genitive","dative","accusative","instrumental","prepositional"], cases_index: [0,1,2,3,4,5]
  else
    for check in inclineRe
      if check[0].test surname
        result = found: surname.replace(check[0], check[1]), src: surname
        cases_index = []
        cases = []
        i = 0
        for c in casesRe
          if c.test surname
            cases_index.push i
            cases.push ["nominative","genitive","dative","accusative","instrumental","prepositional"][i]
          i++
        if cases.length == 0
          result.found = null
          result.cases = null
        else
          result.cases = cases
        result.cases_index = cases_index
        break
  if result.cases
    result.guess_case = result.cases[0]
  result

exports.inclineFemSurname = inclineFemSurname = (surname) ->
  noInclinesRe = /((их)|(ых)|(е)|(о)|(э)|(и)|(ы)|(^[нв]у)|(^ую)|(уа)|(иа)|(ман)|(вич))$/g
  inclineRe = [
    [/((ова)|(овой)|(ову))$/g, "ова"]
    [/((ева)|(евой)|(еву))$/g, "ева"]
    [/((ёва)|(ёвой)|(ёву))$/g, "ёва"]
    [/((ина)|(иной)|(ину))$/g, "ина"]
    [/((ая)|(ой)|(ую))$/g, "ая"]
    ]
  casesRe = [
    /((ова)|(ева)|(ёва)|(ина)|(ая))$/g,
    /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g,
    /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g,
    /((ову)|(еву)|(ёву)|(ину)|(ую))$/g,
    /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g,
    /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g
    ]

  inclineSurname surname, noInclinesRe, inclineRe, casesRe


exports.inclineMaleSurname = inclineMaleSurname = (surname) ->
  noInclinesRe = /((их)|(ых)|(^ве)|(^го)|(э)|(и)|(ы)|(^му)|(ю)|(уа)|(иа))$/g
  inclineRe = [
    [/((ов)|(ова)|(ову)|(овым)|(ове))$/g, "ов"]
    [/((ев)|(ева)|(еву)|(евым)|(еве))$/g, "ев"]
    [/((ёв)|(ёва)|(ёву)|(ёвым)|(ёве))$/g, "ёв"]
    [/((ин)|(ина)|(ину)|(иным)|(ине))$/g, "ин"]
    [/((ский)|(ского)|(скому)|(ским)|(ском))$/g, "ский"]
    [/((ской)|(ского)|(скому)|(ским)|(ском))$/g, "ской"]
    [/((ман)|(мана)|(ману)|(маном)|(мане))$/g, "ман"]
    [/((ой)|(ого)|(ому)|(ого)|(ым)|(ом))$/g, "ой"]
    [/((ий)|(ого)|(ому)|(ого)|(им)|(ом))$/g, "ий"]
    [/((ый)|(ого)|(ому)|(ого)|(ым)|(ом))$/g, "ый"]
    [/((ич)|(ича)|(ичу)|(ича)|(ичем)|(иче))$/g, "ич"]
    ]
  casesRe = [
    /((ов)|(ев)|(ёв)|(ин)|(ский)|(ской)|(ой)|(ий)|(ый)|(ман)|(ич))$/g,
    /((ова)|(ева)|(ёва)|(ина)|(ского)|(ого)|(мана)|(ича))$/g,
    /((ову)|(еву)|(ёву)|(ину)|(скому)|(ому)|(ману)|(ичу))$/g,
    /((ова)|(ева)|(ёва)|(ина)|(ского)|(ого)|(мана)|(ича))$/g,
    /((овым)|(евым)|(ёвым)|(иным)|(ским)|(им)|(ым)|(маном)|(ичем))$/g,
    /((ове)|(еве)|(ёве)|(ине)|(ском)|(ом)|(мане)|(иче))$/g
    ]
  inclineSurname surname, noInclinesRe, inclineRe, casesRe


inclineMiddleNameOrSurname = (src, fem, male) ->
  if fem.found == male.found == null
    result = {found: no, src: src, value: null, gender: null}
  else if fem.found && male.found
#    console.log "эм жо!!!\n\n#{sys.inspect fem}\n\n"
    result = {found: yes, src: src, gender: ["male", "female"]}
    result.nominative_male = male.found
    result.nominative_female = fem.found
    result.female_cases = fem.cases
    result.male_cases = male.cases
    if fem.cases.length == 6 # not inclined
      if male.cases.length == 6   # not inclined too, unknown
        result.guess_sex = "unknown"
      else # suppose, that it's a man
        result.guess_sex = "male"
        result.nominative = male.found
    # nominative female, and multiple male cases, suppose it's a woman
    else if fem.cases.length == 1 && male.cases.length > 1
      result.guess_sex = "female"
      result.nominative = fem.found
  else if !fem.found
    result = {found: yes, src: src, gender: "male", male_cases: male.cases, guess_case: male.guess_case, nominative: male.found}
  else if !male.found
    result = {found: yes, src: src, gender: "female", female_cases: fem.cases, guess_case: fem.guess_case, nominative: fem.found}

  result


exports.inclineSurname = inclinePersonSurname = (surname) ->
  inclineMiddleNameOrSurname surname, inclineFemSurname(surname), inclineMaleSurname(surname)


exports.inclineMaleMiddleName = inclineMaleMiddleName = (mname) ->
  inclineRe = [
    [/(евич)|(евичу)|(евичу)|(евича)|(евичем)|(евиче)$/g, "евич"],
    [/(ович)|(овичу)|(овичу)|(овича)|(овичем)|(овиче)$/g, "ович"],
    ]
  casesRe = [
    /((евич)|(ович))$/g,
    /((евичу)|(овичу))$/g,
    /((евичу)|(овичу))$/g,
    /((евича)|(овича))$/g,
    /((евичем)|(овичем))$/g,
    /((евиче)|(овиче))$/g
    ]
  inclineSurname mname, null, inclineRe, casesRe

exports.inclineFemMiddleName = inclineFemMiddleName = (mname) ->
  inclineRe = [
    [/(вна)|(вной)|(вне)|(вну)|(вной)|(вне)$/g, "вна"],
    [/(чна)|(чной)|(чне)|(чну)|(чной)|(чне)$/g, "чна"]
    ]
  casesRe = [
    /((вна)|(чна))$/g,
    /((вной)|(чной))$/g,
    /((вне)|(чне))$/g,
    /((вну)|(чну))$/g,
    /((вной)|(чной))$/g,
    /((вное)|(чне))$/g
    ]
  inclineSurname mname, null, inclineRe, casesRe


exports.inclineMiddleName = inclineMiddleName = (mname) ->
  inclineMiddleNameOrSurname mname, inclineFemMiddleName(mname), inclineMaleMiddleName(mname)


#--------------------------------------------------------------------------------
genderMatch = (g1, g2) ->
  if g1 == g2 || g1 in g2
    g1
  else if g2 in g1
    g2
  else
    null

matchCase = (pObj, target_case, gender) ->
  target_case in pObj["#{gender}_cases"]

getNominative = (pObj, gender) ->
  gnstr = "nominative_#{gender}"
  nom =  pObj.nominative && pObj.nominative || pObj[gnstr]
#  console.log "#{gender} nominative = #{nom} \npObj = #{pObj[gnstr]} nom = #{nom}\n\n"
  nom

exports.findProperName = (listOfWords, opts={}) ->
  switch listOfWords.length
    when 1                      # just surname
      result =  inclinePersonSurname listOfWords[0]
      if result.found
        console.log "found surname"
        return result
      else
        console.log "not found((, name? \n#{sys.inspect inclineName listOfWords[0]}"
        null
    when 2
      sResult1 = inclinePersonSurname listOfWords[0]
      sResult2 = inclinePersonSurname listOfWords[1]

      nResult1 = inclineName listOfWords[0]
      nResult2 = inclineName listOfWords[1]

      surnameFound = sResult1.found || sResult2.found
      nameFound = nResult1.found || nResult2.found
      if !surnameFound || !nameFound
        console.log "not a proper name!"
      else                      # find name first
        if yes == nResult1.found == nResult2.found
          return null            # two names!
        if yes == nResult1.found# name found
          gender = nResult1.gender
          guess_case = nResult1.guess_case
          r = {name: nResult1.nominative, surname: getNominative(sResult2, gender), found: yes, gender: gender, order: "normal"}
          sResult = sResult2
        else if yes == nResult2.found
          gender = nResult2.gender
          guess_case = nResult2.guess_case
          r = {name: nResult2.nominative, surname: getNominative(sResult1, gender), found: yes, gender: gender, order: "reverse"}
          sResult = sResult1
        else
          console.log "suspicios name!!"
          return null
        sGender = genderMatch gender, sResult.gender
        if !sGender
          return {found: no, error: "missmatch gender"}
        else if matchCase sResult, guess_case, sGender
          return r
        else
          return {found: no, error: "missmatch case (#{sys.inspect sResult2})"}

    when 3
      console.log "three cases!"
    else
      console.log "WTF"
  console.log "fY"