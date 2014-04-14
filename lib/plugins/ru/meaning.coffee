#
# Feeling words
# 
#
# depends on inclines and counters
if "undefined" is typeof global
    window.semantics.plugins.ru.meaning  = {}
    exports                              = window.semantics.plugins.ru.meaning
    inclines                             = window.semantics.plugins.ru.inclines
    quotes                               = window.semantics.quotes
    util                                 = window.semantics.util
    misc                                 = window.semantics.misc
else
    exports                              = module.exports
    inclines                             = require "./inclines"
    quotes                               = require "../../quotes"
    util                                 = require "../../util"
    misc                                 = require "../../misc"

((exports, inclines, quotes, util) ->

  exports.negativeWords = negativeWords =
    "агрессивный"        : 3,
    "атакованный"        : 2,
    "бедный"             : 2,
    "беззащитный"        : 2,
    "безнадежный"        : 3,
    "безрадостный"       : 2,
    "бесплодный"         : 3,
    "беспомощный"        : 3,
    "бесправный"         : 2,
    "бессердечный"       : 1.1,
    "бессильный"         : 1.1,
    "бесцельный"         : 2,
    "бесчестный"         : 2,
    "вздорный"           : 1.1,
    "виновный"           : 1.1,
    "ворчливый"          : 1.1,
    "враждебный"         : 2,
    "вспыльчивый"        : 1.1,
    "выпученный"         : 1.1,
    "выселенный"         : 3,
    "высмеянный"         : 2,
    "выхолощенный"       : 1.1,
    "глубокий"           : 1.1,
    "глупый"             : 2,
    "горький"            : 2,
    "готический"         : 2,
    "гротескный"         : 1.1,
    "грустный"           : 1.1,
    "грязный"            : 1.1,
    "девальвированный"   : 2,
    "деградировавший"    : 2,
    "дегуманизированный" : 2,
    "дезорганизованный"  : 2,
    "дезориентированный" : 2,
    "деморализованный"   : 3,
    "дерзкий"            : 1.1,
    "дерьмовый"          : 3,
    "дефектный"          : 3,
    "драматический"      : 3,
    "жалкий"             : 3,
    "жесткий"            : 2,
    "жестокосердный"     : 2,
    "заброшенный"        : 1.1,
    "забываемый"         : 1.1,
    "забывчивый"         : 1.1,
    "забытый"            : 2,
    "зависимый"          : 1.1,
    "заинтересованный"   : 1.1,
    "запрещенный"        : 3,
    "запутанный"         : 2,
    "застенчивый"        : 1.1,
    "застрявший"         : 1.1,
    "затравленный"       : 2,
    "зверский"           : 3,
    "злобный"            : 2,
    "идиотский"          : 3,
    "измельченный"       : 2,
    "измученный"         : 2,
    "изнасилованный"     : 3,
    "изолированный"      : 3,
    "изумленный"         : 1.1,
    "интенсивный"        : 1.1,
    "иррациональный"     : 2,
    "исключенный"        : 2,
    "искусственный"      : 2,
    "испуганный"         : 2,
    "истерический"       : 3,
    "исчерпанный"        : 2,
    "капризный"          : 2,
    "контролируемый"     : 1.1,
    "критический"        : 1.1,
    "ленивый"            : 2,
    "лишенный"           : 2,
    "ложный"             : 2,
    "мазохистский"       : 1.1,
    "мертвый"            : 3,
    "меченый"            : 2,
    "мрачный"            : 2,
    "мстительный"        : 2,
    "навязчивый"         : 2,
    "надоедливый"        : 2,
    "наказанный"         : 2,
    "нарушенный"         : 2,
    "натянутый"          : 2,
    "неадекватный"       : 2,
    "неактивный"         : 1.1,
    "небезопасный"       : 2,
    "небрежный"          : 1.1,
    "невежественный"     : 1.1,
    "невидимый"          : 1.1,
    "невротический"      : 2,
    "негуманный"         : 2,
    "недействительный"   : 1.1,
    "недовольный"        : 2,
    "недостаточный"      : 1.1,
    "недоуменный"        : 1.1,
    "незаземленный"      : 1.1,
    "незначительный"     : 1.1,
    "неискренний"        : 1.1,
    "некомпетентный"     : 2,
    "ненавистный"        : 3,
    "необщительный"      : 2,
    "неполный"           : 2,
    "неправильный"       : 2,
    "неприятный"         : 2,
    "нервный"            : 2,
    "нерешительный"      : 1.1,
    "несбалансированный" : 1.1,
    "несовместимый"      : 2,
    "несоответствующий"  : 2,
    "неспособный"        : 3,
    "несчастный"         : 2,
    "неуклюжий"          : 2,
    "неуловимый"         : 1.1,
    "неуместный"         : 2,
    "нечестный"          : 2,
    "неэффективный"      : 2,
    "низкий"             : 1.1,
    "обвиняемый"         : 3,
    "обедненный"         : 1.1,
    "обезумевший"        : 3,
    "обиженный"          : 2,
    "обманутый"          : 2,
    "обозленный"         : 2,
    "оборонительный"     : 1.1,
    "обремененный"       : 1.1,
    "обременительный"    : 1.1,
    "обреченный"         : 2,
    "ограниченный"       : 1.1,
    "одержимый"          : 3,
    "одинокий"           : 2,
    "одноразовый"        : 1.1,
    "озабоченный"        : 2,
    "окаменелый"         : 1.1,
    "онемелый"           : 1.1,
    "опальный"           : 2,
    "опасный"            : 3,
    "опустошенный"       : 1.1,
    "опущенный"          : 2,
    "опьяненный"         : 1.1,
    "оскорбленный"       : 2,
    "осмеянный"          : 2,
    "острый"             : 1.1,
    "осужденный"         : 3,
    "осушенный"          : 2,
    "ответственный"      : 2,
    "отвратительный"     : 3,
    "отдаленный"         : 1.1,
    "отдельный"          : 1.1,
    "отрицательный"      : 2,
    "отсталый"           : 2,
    "отчаянный"          : 1.1,
    "ошибочный"          : 1.1,
    "параноидальный"     : 2,
    "паршивый"           : 2,
    "пассивный"          : 1.1,
    "переполненный"      : 2,
    "пессимистический"   : 2,
    "печальный"          : 2,
    "побежденный"        : 3,
    "поверхностный"      : 2,
    "поврежденный"       : 3,
    "подавленный"        : 2,
    "поддельный"         : 3,
    "покинутый"          : 2,
    "покорный"           : 1.1,
    "порабощенный"       : 3,
    "потерянный"         : 2,
    "потерпевший"        : 2,
    "потребленный"       : 1.1,
    "презираемый"        : 2,
    "презренный"         : 3,
    "презрительный"      : 2,
    "прерванный"         : 1.1,
    "принудительный"     : 2,
    "психотический"      : 2,
    "пустынный"          : 1.1,
    "пьяный"             : 2,
    "равнодушный"        : 1.1,
    "развращенный"       : 3,
    "раздраженный"       : 2,
    "раздражительный"    : 2,
    "разочарованный"     : 2,
    "разочаровывающий"   : 3,
    "разрушенный"        : 3,
    "разрушительный"     : 2,
    "разъяренный"        : 3,
    "раненый"            : 2,
    "ревнивый"           : 2,
    "садистский"         : 2,
    "самоубийственный"   : 3,
    "саркастический"     : 1.1,
    "сварливый"          : 1.1,
    "сгоревший"          : 3,
    "сердитый"           : 2,
    "серый"              : 1.1,
    "скучающий"          : 1.1,
    "скучный"            : 1.1,
    "сломанный"          : 2,
    "смущенный"          : 1.1,
    "созерцательный"     : 1.1,
    "сомнительный"       : 2,
    "спорный"            : 2,
    "спровоцированный"   : 2,
    "спутанный"          : 2,
    "спущенный"          : 2,
    "стереотипный"       : 1.1,
    "стесненный"         : 1.1,
    "странный"           : 1.1,
    "страшный"           : 2,
    "сумасшедший"        : 2,
    "тихий"              : 1.1,
    "тормозящий"         : 2,
    "торопливый"         : 2,
    "тоскливый"          : 3,
    "требовательный"     : 2,
    "тревожный"          : 2,
    "трудный"            : 2,
    "трусливый"          : 2,
    "тупой"              : 1.1,
    "тщеславный"         : 2,
    "угнетенный"         : 2,
    "угрюмый"            : 2,
    "удаляемый"          : 2,
    "удрученный"         : 2,
    "ужасный"            : 3,
    "уклончивый"         : 2,
    "униженный"          : 3,
    "унылый"             : 3,
    "урезанный"          : 2,
    "фальшивый"          : 3,
    "хаотический"        : 2,
    "холодный"           : 1.1,
    "хрупкий"            : 1.1,
    "цепкий"             : 2,
    "циничный"           : 2,
    "черный"             : 1.1,
    "чертовский"         : 2,
    "чрезмерный"         : 2,
    "чувствительный"     : 2,
    "эгоистичный"        : 2,
    "эгоцентричный"      : 3,
    "эксплуатируемый"    : 2,
    "эмансипированный"   : 2,
    "эмоциональный"      : 1.1,
    "яростный"           : 3,
    # end of adverbs
    "беспокоить"         : 2,
    "бить"               : 2,
    "внушать"            : 2,
    "волноваться"        : 2,
    "высмеивать"         : 2,
    "грызть"             : 1.1,
    "диктовать"          : 2,
    "дребезжать"         : 1.1,
    "дрожать"            : 1.1,
    "дрогнуть"           : 2,
    "загнать"            : 2,
    "запугивать"         : 3,
    "запутаться"         : 2,
    "злоупотреблять"     : 2,
    "игнорировать"       : 1.1,
    "избегать"           : 1.1,
    "издеваться"         : 3,
    "изменять"           : 2,
    "командовать"        : 1.1,
    "лгать"              : 2,
    "лишить"             : 2,
    "манипулировать"     : 2,
    "молчать"            : 1.1,
    "надувать"           : 1.1,
    "ненавидеть"         : 3,
    "обвинять"           : 2,
    "обидеть"            : 2,
    "опорочить"          : 3,
    "освистать"          : 2.5,
    "освистывать"        : 2.5,
    "отбрасывать"        : 1.1,
    "отвлекаться"        : 2,
    "отклонить"          : 2,
    "отрекаться"         : 3,
    "оттолкнуть"         : 2,
    "паниковать"         : 2,
    "перепутаться"       : 2,
    "подавить"           : 3,
    "подвергаться"       : 2,
    "пострадать"         : 2,
    "предавать"          : 3,
    "пренебрегать"       : 2,
    "препятствовать"     : 2,
    "преследовать"       : 2,
    "принижаться"        : 2,
    "приставать"         : 2,
    "прослушивать"       : 2,
    "разгромить"         : 2,
    "раздражаться"       : 2,
    "растаскивать"       : 2,
    "рисковать"          : 2,
    "ругать"             : 2,
    "сдуваться"          : 1.1,
    "смолчать"           : 2,
    "снизиться"          : 1.1,
    "сорвать"            : 1.1,
    "сожалеть"           : 2,
    "соизволить"         : 2,
    "солгать"            : 2,
    "сомневаться"        : 2,
    "споткнуться"        : 1.1,
    "столкнуться"        : 2,
    "страдать"           : 2,
    "стрелять"           : 3,
    "судить"             : 2,
    "толкнуть"           : 1.1,
    "убить"              : 3,
    "убивать"            : 3,
    "уговаривать"        : 1.1,
    "удалять"            : 2,
    "уклоняться"         : 2,
    "унижать"            : 3,
    "шантажировать"      : 2,
    # end of verbs
    "боль"               : 2,
    "вниз"               : 1,
    "горе"               : 3,
    "дно"                : 2,
    "жертва"             : 2.5,
    "жертвы"             : 3,
    "заблуждение"        : 2,
    "мало"               : 1,
    "мучение"            : 2 ,
    "наказание"          : 2,
    "недовольство"       : 2,
    "ненависть"          : 3,
    "неодобрительно"     : 2,
    "неправильно"        : 1.1,
    "отчаяние"           : 3,
    "плохо"              : 2,
    "противно"           : 3,
    "разгром"            : 2,
    "смерть"             : 3,
    "совестно"           : 2,
    "только"             : 1,
    "убыток"             : 2,
    "угроза"             : 2,
    "ужас"               : 3,
    "ужас"               : 3


  exports.positiveWords = positiveWords =
    "авантюрный"         : 2,
    "аккуратный"         : 2,
    "активный"           : 2,
    "анимационный"       : 2,
    "аутентичный"        : 1.1,
    "баснословный"       : 3,
    "безграничный"       : 3,
    "безмятежный"        : 3,
    "безопасный"         : 2,
    "бесконечный"        : 2,
    "благодарный"        : 2,
    "благоприятный"      : 2,
    "благородный"        : 2,
    "благословенный"     : 2,
    "благотворительный"  : 2,
    "блестящий"          : 1.1,
    "богатый"            : 1.1,
    "бодрствующий"       : 1.1,
    "божественный"       : 3,
    "большой"            : 1.1,
    "быстрый"            : 1.1,
    "важный"             : 2,
    "вдохновленный"      : 1.1,
    "великий"            : 3,
    "великолепный"       : 2,
    "веселый"            : 2,
    "взволнованный"      : 1.1,
    "видный"             : 2,
    "внимательный"       : 1.1,
    "возбужденный"       : 2,
    "воздушный"          : 1.1,
    "волнующий"          : 1.1,
    "воодушевляющий"     : 2,
    "восторженный"       : 2,
    "восхитительный"     : 2,
    "впечатляющий"       : 2,
    "врожденный"         : 2,
    "выполненный"        : 2,
    "гармоничный"        : 1.1,
    "глубокий"           : 1.1,
    "гордый"             : 1.1,
    "готовый"            : 1.1,
    "грациозный"         : 2,
    "дальновидный"       : 2,
    "динамический"       : 1.1,
    "доблестный"         : 2,
    "добрый"             : 2,
    "доверчивый"         : 1.1,
    "достойный"          : 2,
    "драгоценный"        : 2,
    "дружественный"      : 2,
    "дружеский"          : 2,
    "духовный"           : 2,
    "желательный"        : 2,
    "живой"              : 3,
    "заинтересованный"   : 2,
    "замечательный"      : 2,
    "заслуженный"        : 2,
    "захватывающий"      : 2,
    "здоровый"           : 2,
    "зеленый"            : 1.1,
    "знакомый"           : 1.1,
    "знаменитый"         : 2,
    "значимый"           : 1.1,
    "игривый"            : 1.1,
    "идеальный"          : 3,
    "известный"          : 2,
    "изобретательный"    : 2,
    "изысканный"         : 2,
    "инновационный"      : 2,
    "интеллектуальный"   : 2,
    "интересный"         : 2,
    "интуитивный"        : 2,
    "исключительный"     : 2,
    "искусный"           : 2,
    "исцеленный"         : 2,
    "каждый"             : 1.1,
    "квалифицированный"  : 2,
    "классный"           : 1.1,
    "компетентный"       : 1.1,
    "конечный"           : 2,
    "красивый"           : 2,
    "красноречивый"      : 2,
    "легендарный"        : 2,
    "легкий"             : 1.1,
    "лестный"            : 1.1,
    "ликующий"           : 2,
    "лучистый"           : 1.1,
    "лучший"             : 2,
    "любопытный"         : 2,
    "любящий"            : 2,
    "магический"         : 1.1,
    "мгновенный"         : 2,
    "милостивый"         : 2,
    "милый"              : 2,
    "мирный"             : 1.1,
    "могущественный"     : 2,
    "молодой"            : 2,
    "мощный"             : 2,
    "мудрый"             : 2,
    "надежный"           : 2,
    "наивысший"          : 3,
    "напористый"         : 2,
    "находчивый"         : 1.1,
    "небесный"           : 2,
    "невероятный"        : 2,
    "независимый"        : 1.1,
    "необычный"          : 1.1,
    "неотразимый"        : 2,
    "непобедимый"        : 2,
    "непоколебимый"      : 2,
    "обильный"           : 1.1,
    "обожаемый"          : 2,
    "образный"           : 1.1,
    "огромный"           : 2,
    "одаренный"          : 2,
    "оживленный"         : 2,
    "определенный"       : 1.1,
    "оптимистичный"      : 1.1,
    "опытный"            : 2,
    "ослепительный"      : 3,
    "основной"           : 2,
    "острый"             : 1.1,
    "отличный"           : 2,
    "охватывающий"       : 1.1,
    "освежающий"         : 2,
    "очаровательный"     : 1.1,
    "ошеломляющий"       : 2,
    "питательный"        : 2,
    "плавный"            : 2,
    "плавучий"           : 1.1,
    "победоносный"       : 3,
    "повседневный"       : 1.1,
    "подготовленный"     : 2,
    "подлинный"          : 3,
    "показанный"         : 2,
    "полезный"           : 2,
    "полный"             : 2,
    "положительный"      : 1.1,
    "популярный"         : 1.1,
    "поразительный"      : 3,
    "постоянный"         : 2,
    "потрясающий"        : 3,
    "почитаемый"         : 2,
    "правдивый"          : 2,
    "превосходный"       : 3,
    "предприимчивый"     : 2,
    "прекрасный"         : 2,
    "прибыльный"         : 2,
    "привлекательный"    : 2,
    "признанный"         : 2,
    "прилежный"          : 1.1,
    "приличный"          : 1.1,
    "природный"          : 1.1,
    "приятный"           : 1.1,
    "продуктивный"       : 1.1,
    "проницательный"     : 2,
    "простой"            : 1.1,
    "процветающий"       : 2,
    "прямой"             : 1.1,
    "пылающий"           : 2,
    "радостный"          : 2,
    "разносторонний"     : 1.1,
    "разумный"           : 2,
    "рассудительный"     : 2,
    "решительный"        : 2,
    "свежий"             : 1.1,
    "сверкающий"         : 1.1,
    "святой"             : 3,
    "связанный"          : 1,
    "сенсационный"       : 3,
    "сердечный"          : 2,
    "сильный"            : 1.1,
    "синхронизированный" : 1.1,
    "сияющий"            : 2,
    "славный"            : 2,
    "смелый"             : 2,
    "смешной"            : 1.1,
    "соблазнительный"    : 2,
    "сознательный"       : 2,
    "сокрушительный"     : 3,
    "солнечный"          : 2,
    "состоятельный"      : 2,
    "спокойный"          : 1.1,
    "спонтанный"         : 2,
    "способный"          : 2,
    "стойкий"            : 2,
    "страстный"          : 2,
    "счастливый"         : 2,
    "тактичный"          : 1.1,
    "талантливый"        : 2,
    "творческий"         : 1.1,
    "теплый"             : 1.1,
    "терапевтический"    : 1.1,
    "тихий"              : 1.1,
    "трудолюбивый"       : 1.1,
    "тщательный"         : 1.1,
    "уважаемый"          : 2,
    "уверенный"          : 2,
    "увлекательный"      : 2,
    "удивительный"       : 2,
    "удобный"            : 2,
    "удовлетворенный"    : 2,
    "умный"              : 2,
    "уникальный"         : 3,
    "упорный"            : 2,
    "успешный"           : 2,
    "установленный"      : 1.1,
    "утвердительный"     : 1.1,
    "храбрый"            : 2,
    "художественный"     : 1.1,
    "целебный"           : 2,
    "ценный"             : 2,
    "цепкий"             : 2,
    "честный"            : 2,
    "чистый"             : 1.1,
    "чувствительный"     : 1.1,
    "чудесный"           : 2,
    "чудотворный"        : 3,
    "шипучий"            : 1.1,
    "шокирующий"         : 1.1,
    "щедрый"             : 2,
    "элегантный"         : 2,
    "электризующий"      : 2,
    "энергичный"         : 2,
    "эффективный"        : 2,
    "юмористический"     : 2,
    "яркий"              : 2,
    "мотивированный"     : 2,
    # end of adverbs
    "верить"             : 2,
    "визуализировать"    : 2,
    "возделывать"        : 2,
    "возобновить"        : 2,
    "восхищаться"        : 2,
    "выражать"           : 1.1,
    "выбирать"           : 2,
    "доверять"           : 2
    "держать"            : 1.1,
    "жертвовать"         : 3,
    "звучать"            : 2,
    "знать"              : 1.1,
    "изменять"           : 1.1,
    "изменяться"         : 2,
    "исследовать"        : 2,
    "лелеять"            : 2,
    "любоваться"         : 2,
    "мотивировать"       : 2,
    "мочь"               : 2,
    "наслаждаться"       : 2,
    "одобрять"           : 1.1,
    "омолаживать"        : 1.1,
    "определяться"       : 1.1,
    "открывать"          : 1.1,
    "отпускать"          : 1.1,
    "оценивать"          : 2,
    "питать"             : 2,
    "питаться"           : 2,
    "поддерживать"       : 2,
    "полагаться"         : 2,
    "полировать"         : 1.1,
    "понимать"           : 1.1,
    "поощрять"           : 2,
    "пополняться"        : 2,
    "праздновать"        : 2,
    "привлекать"         : 2,
    "приглашать"         : 2,
    "прижиматься"        : 1.1,
    "принимать"          : 1.1,
    "процветать"         : 2,
    "радоваться"         : 2,
    "размышлять"         : 2,
    "распускаться"       : 1.1,
    "расслабляться"      : 2,
    "расти"              : 3,
    "расширять"          : 2,
    "регулировать"       : 2,
    "светиться"          : 1.1,
    "следовать"          : 2,
    "смеяться"           : 2,
    "смотреть"           : 2,
    "собирать"           : 2,
    "соглашаться"        : 2,
    "соединяться"        : 2,
    "создавать"          : 2,
    "соответствовать"    : 2,
    "стремиться"         : 2,
    "трансформировать"   : 2,
    "убедиться"          : 1.1,
    "удивлять"           : 2,
    "утверждать"         : 2
    "учиться"            : 2,
    "читать"             : 1.1
    # end of verbs
    "ура"                : 2,
    "прямо"              : 1.1,
    "сейчас"             : 1.1,
    "сегодня"            : 1.1,
    "здесь"              : 1.1,
    "полностью"          : 1.1,
    "быстро"             : 1.1,
    "абсолютно"          : 1.1,
    "бесплатно"          : 2,
    "хорошо"             : 2,
    "довольно"           : 1.1,
    "легко"              : 1.1,
    "много"              : 2,
    "своевременно"       : 2,
    "ядро"               : 2,
    "ясно"               : 1,
    "вместе"             : 2,
    "восторг"            : 3,
    "добро"              : 2

  exports.fuckWords = fuckWords =
    "3.14здец"           : 2,
    "анус"               : 2,
    "ахуеть"             : 2,
    "баклан"             : 1.5,
    "балда"              : 1.5,
    "баран"              : 1.5,
    "бздеть"             : 2,
    "блеать"             : 2,
    "блин"               : 1.1,
    "бля"                : 2,
    "блядка"             : 2,
    "блядовать"          : 2,
    "блядский"           : 2,
    "блядун"             : 2,
    "блядь"              : 2,
    "блядь"              : 2,
    "быдло"              : 2,
    "вафел"              : 1.5,
    "вафлить"            : 1.5,
    "влагалище"          : 1.5,
    "война"              : 1.5
    "вошь"               : 1.1,
    "впиздячить"         : 2,
    "вхуярить"           : 2,
    "выебать"            : 2,
    "выпердыш"           : 1.5,
    "выпиздеться"        : 1.5,
    "выпиздить"          : 1.5,
    "выёбываться"        : 2,
    "говно"              : 1.5,
    "голимый"            : 1.5,
    "гопарь"             : 2,
    "гопник"             : 2,
    "гопота"             : 2,
    "грёбаный"           : 1.5,
    "давалка"            : 1.5,
    "даебаться"          : 2,
    "далбоёб"            : 2,
    "даун"               : 1.5,
    "дерьмо"             : 1.5,
    "дерьмоед"           : 2,
    "доебаться"          : 2,
    "долбаёб"            : 2,
    "долбоёб"            : 2,
    "дохуя"              : 1.1,
    "дрочить"            : 2,
    "дрючить"            : 2,
    "ебанат"             : 2,
    "ебанат"             : 2,
    "ебаный"             : 2,
    "ебанный"            : 2,
    "ебать"              : 2,
    "ебать-колотить"     : 1.5,
    "ебать-копать"       : 1.5,
    "ебаться"            : 2,
    "еблан"              : 1.5,
    "ебливый"            : 2,
    "ебло"               : 1.5,
    "ебля"               : 2,
    "ебстись"            : 2,
    "ебёна"              : 1.5,
    "едрос"              : 2,
    "елда"               : 1.5,
    "жопа"               : 1.5,
    "заебать"            : 3,
    "заебаться"          : 2.5,
    "засранец"           : 1.5,
    "захуярить"          : 1.5,
    "заёб"               : 2,
    "злоебучая"          : 1.5,
    "козел"              : 1.1,
    "лярва"              : 2,
    "манда"              : 2,
    "миньет"             : 2,
    "мля"                : 1.5,
    "мозгоёб"            : 2,
    "мудак"              : 2,
    "мудила"             : 2,
    "мудоеб"             : 2,
    "мудотня"            : 1.5,
    "мудоёб"             : 2,
    "напиздить"          : 2,
    "нах"                : 1.5,
    "однохуйственно"     : 1.1,
    "осел"               : 1.1,
    "осёл"               : 1.1,
    "отрыжка"            : 1.1,
    "отсосать"           : 2,
    "отъебаться"         : 2,
    "охуеть"             : 2,
    "охуительно"         : 2,
    "охуительный"        : 2,
    "педараст"           : 2,
    "педераст"           : 2,
    "педрила"            : 2.5,
    "перехуярить"        : 2,
    "петух"              : 2,
    "пздеть"             : 2,
    "пидарас"            : 2,
    "пидр"               : 2,
    "пизда"              : 2,
    "пиздабол"           : 2,
    "пиздеть"            : 2,
    "пиздец"             : 2,
    "пиздобол"           : 2,
    "пиздобратия"        : 2,
    "пиздун"             : 2,
    "пиздюк"             : 2,
    "пиздюли"            : 2,
    "пиздюлина"          : 2,
    "пиздюхать"          : 1.5,
    "пиздёж"             : 2,
    "писец"              : 1.1,
    "писька"             : 1.5,
    "пися"               : 1.5,
    "подлизать"          : 2,
    "подстилка"          : 2,
    "подёбывает"         : 2,
    "подёбывать"         : 2,
    "поебень"            : 2,
    "попиздеть"          : 1.5,
    "попиздили"          : 1.5,
    "посрать"            : 2,
    "потаскуха"          : 1.5,
    "похерить"           : 1.5,
    "похуй"              : 2,
    "ппц"                : 1.1,
    "припиздить"         : 2,
    "прихуярить"         : 2,
    "проебать"           : 2.5,
    "проебаться"         : 2.5,
    "просрал"            : 2.5,
    "прохуяритъ"         : 2,
    "пёрнуть"            : 1.5,
    "разъебай"           : 2,
    "разъебаться"        : 2,
    "распиздеться"       : 2,
    "распиздон"          : 2,
    "распиздяй"          : 2,
    "распиздяйка"        : 2,
    "сиськи"             : 1.5,
    "сися"               : 1.5,
    "скосоебиться"       : 1.1,
    "смехохуечки"        : 1.5,
    "соска"              : 1.5,
    "спиздить"           : 2,
    "срака"              : 1.5,
    "срать"              : 1.5,
    "ссать"              : 1.5,
    "ссука"              : 1.5,
    "ссучиться"          : 1.5,
    "стерва"             : 1.5,
    "сука"               : 1.5,
    "сучара"             : 2,
    "сучий"              : 1.5,
    "сучка"              : 1.5,
    "схуярить"           : 2,
    "титьки"             : 1.5,
    "тормоз"             : 1.1,
    "траханый"           : 1.5,
    "трахать"            : 1.5,
    "уебать"             : 2,
    "уебывать"           : 2,
    "уебыш"              : 2,
    "ухуярить"           : 2,
    "уёбище"             : 2,
    "фалос"              : 1.5,
    "фиг"                : 1.1,
    "фик"                : 1.1,
    "хер"                : 1.5,
    "хз"                 : 1.1,
    "хитровыебанный"     : 2,
    "хрен"               : 1.1,
    "худоебина"          : 2,
    "хуебень"            : 2,
    "хуебратия"          : 2,
    "хуеватенький"       : 2,
    "хуевато"            : 2,
    "хуевина"            : 2,
    "хуеглот"            : 2.5,
    "хуегрыз"            : 2.5,
    "хуем"               : 2,
    "хуеплёт"            : 2,
    "хуесос"             : 2.5,
    "хуета"              : 2,
    "хуетень"            : 2,
    "хуило"              : 2,
    "хуиный"             : 2,
    "хуй"                : 2,
    "хуй-чего"           : 2,
    "хуйня"              : 2,
    "хуле"               : 1.5,
    "хули"               : 1.5,
    "хуюшки"             : 1.5,
    "хуя"                : 2,
    "хуяк"               : 2,
    "хуястый"            : 2,
    "хуячить"            : 2,
    "хуё-моё"            : 2,
    "хуёвина"            : 2,
    "хуёвый"             : 2,
    "целка"              : 1.5,
    "целочка"            : 1.5,
    "черт"               : 1.1,
    "чмо"                : 2,
    "чёрт"               : 1.1,
    "шпана"              : 1.5,
    "шут"                : 1.1,
    "ядрён-батон"        : 1.1,
    "яйца"               : 1.1,
    "ялда"               : 2,
    "ялдак"              : 2,
    "ёб"                 : 2,
    "ёбанный"            : 2,
    "ёбаный"             : 2,
    "ёбнуть"             : 2,
    "ёбнуться"           : 2,
    "ёлки-палки"         : 1.1,
    "ёпрст"              : 1.5


  #todo отягчающий


  ###
  Evalute neutrality score for sentence.

  ###
  exports.evaluateSentenceScore = evaluateSentenceScore = (sentenceWords, scoreDict) ->
    # check out proper names!

    evalScore = (sentenceWords, wordsDict) ->
      cur_index  = 0
      index      = 0
      words      = []
      curWords   = []


      resetCurIndex =  ->
        if cur_index
          index += cur_index
          words.push curWords
          curWords = []
          cur_index = 0

      found = yes
      for wrd in sentenceWords
        if wrd.type in ["verb", "verb/noun", "adj", "adj/noun", "prep", "union", "part", "pron", "adv", "noun"]
          unless found
            resetCurIndex()

          found = no
          for word_form in wrd.all_forms
            value =  wordsDict[word_form]
            if value
              curWords.push wrd.src
              cur_index = cur_index * value || value
              found = yes
              break
          unless found
            # if not found, we suspect that this word is union, part or preposition
            found =  wrd.type in ["prep", "union", "part"]

      resetCurIndex()
      [index, words]


    wordsTotal = 0
    sentenceWords.map (wrd) ->
      if wrd.type in ["verb", "verb/noun", "adj", "adj/noun", "adv", "noun", "unknown"] # todo add more here
        wordsTotal++

    # evaluate negative score
    [index, scoreWords] = evalScore sentenceWords, scoreDict

    [index, scoreWords, wordsTotal]

  ###
  Extract pattern words from array of word sentence.

  @param {Array} words Array or word objects, @see `plugins.ru.inclines.classifyWord`
  @param {Array|null} phrasesPatters Array of phrases patterns, :optional
  ###
  exports.extractPatterns = extractPatterns = (words, patterns=null) ->
    unless patterns
      patterns = [
        "pron.adj.noun"            # местоим прил сущ
        "pron.verb.noun"           # местоим глаг сущ
        "pron.prep.noun"           # местоим предлог сущ
        "noun.pron.prep.noun"      # сущ местоим предлог сущ
        "pron.verb.prep.noun"      # местоим глаг предлог сущ
        "pron.adj.prep.noun"       # местоим прилаг предлог сущ
        "adj.union.adj.noun"       # прил. союз прил. сущ
        "noun.union.noun"       # сущ союз сущ
        "pron.noun"                # местоим сущ
        "prep.noun"                # предлог сущ
        "prep.adj.noun"            # предлог прил сущ
        "adj.adj.adj.adj.adj.noun" # 5 прил. cущ
        "adj.adj.adj.adj.noun"     # 4 прил. cущ
        "adj.adj.adj.noun"         # 3 прил. cущ
        "adj.adj.noun"             # 2 прил. cущ
        "adj.noun"                 # 1 прил. cущ
        "adj.verb.noun"            #
        "noun.verb.noun"           #
        "adj.noun.verb.noun"       #
      ]
    patterns        = patterns.sort (a,b) -> b.length - a.length
    words           = words[0..-1]
    arrayOfPhrases  = []
    maxIndex        = words.length
    while words.length > 0
      shift = 1
      for pat in patterns
        pwords = pat.split "."
        # the search
        if pwords.length > words.length
          continue

        found = yes
        for i in [0...pwords.length]
          if -1 is words[i].type.indexOf pwords[i]
            found = no
            break

        if found
          phrase = {src:[], inf: []}
          for j in [0...i]
            phrase.src.push words[j].src
            phrase.inf.push words[j].infinitive
            phrase.pat = pat
          phrase.inf = phrase.inf.join "."
          arrayOfPhrases.push phrase
          # apply same phraze but shorter!
#          shift = 1
          shift = phrase.src.length
          break
      while shift > 0
        words.shift()
        shift -= 1

    arrayOfPhrases              # todo replace array of phrases by array of word objects
    # proceed array of phrases
    dictPhrases = {}

    for phrase in arrayOfPhrases
      key = phrase.inf
      if dictPhrases[key]?
        dictPhrases[key].total++
        dictPhrases[key].forms.push phrase
      else
        dictPhrases[key] =
          total           : 1
          forms           : [phrase]
          inf             : key
          words_in_phrase : phrase.src.length
    result = []
    for k,v of dictPhrases
      result.push v
    result



  ###
  Check if word match any component of name in personsDict (first name, middle name, surname).

  @param {Array} words Array of source words
  @param {Objects} personsDict dictionary with persons,
                   @see `plugins.ru.inclines.findProperName`
  @param {String} result Return key from personsDict if person was found, or null.
  ###
  matchPersonName = (words, personsDict={}) ->
    text = words.join(" ").toLowerCase()
    result = null
    if 1 < text.length
      for k, val of personsDict
        break if result
        for s in val.src
          if 0 is s.toLowerCase().indexOf text
            result = k
            break
    result

  ###
  Split sentence by grouping logical words.

  @param {String} sentence Normalized sentence.
  ###
  exports.parseSentence = parseSentence = (sentence, personsDict={}, patterns=null) ->
    sentenceWords   = []
    lastPname       = null
    openQuote       = no
    qq              = quotes.getQuotes sentence
    wordsChain      = []

    for word in sentence.split " "
      if /^([-!,?\"\'\.а-яё]+)|(\@[a-z_\d]+)|(\#[-a-zёа-я_\d]+)$/i.test word
        if word[0] is "#"
          wrd = word[1..]
        else
          wrd = word
        wordsChain.push wrd
        pnFound    = matchPersonName wordsChain, personsDict
        lastPname  = pnFound if pnFound
        unless pnFound             # match not found
          if lastPname
            pnWord =
              type       : "pron/PN"
              obj        : personsDict[lastPname]
              src        : wordsChain[..-2].join " "
              propername : yes
              infinitive : "<#{lastPname}>"

            sentenceWords.push pnWord

          iw = inclines.classifyWord(wrd)
          sentenceWords.push iw

          wordsChain = []
          lastPname = null
      else
        if lastPname
          pnWord =
            type       : "pron/PN"
            obj        : personsDict[lastPname]
            src        : wordsChain[..-2].join " "
            propername : yes
            infinitive : "<#{lastPname}>" #lastPname.replace("-", " ").replace /\s+/, " "
          sentenceWords.push pnWord

        wordsChain = []
        lastPname = null

    result =
      quotes         : qq
      sentenceWords  : sentenceWords
      collocation    : extractPatterns sentenceWords, patterns
      ew             : sentenceWords.map (z) -> z.infinitive

  #
  # Public: Make text shorten by extracting most meaningful sentences
  #
  # result - processed text, must contain
  #          `result.meaning.collocations`, `result.meaning.proper_names`,
  #          `result.counters.words_in_sentence_mid`
  #
  exports.shortenText = shortenText = (result, opts={}) ->

    minColo = opts.minColo or 2
    #maxWords= opts.maxWords or result.counters.words_in_sentence_mid
    minSentenceLength = opts.minSentenceLength or 1
    maxSentenceLength = opts.maxSentenceLength or 101
    #maxSentences = opts.maxSentences or  
    cols = []
    short_sent = []

    for col in result.meaning.collocations
      if col.total >= minColo
        cols.push col.forms[0].src.join " "
        for sent_ind in col.sentences
          short_sent.push sent_ind unless sent_ind in short_sent
    the_sents = []
    for s,i in result.misc.sentences
      if i in short_sent
        sent =  misc.denormalizeText s
        the_sents.push sent
#        the_sents.push sent if minSentenceLength <= sent.split(/\s/).length <= maxSentenceLength


#        the_sents.push [i, parseSentence s]  #misc.denormalizeText s

    ## compact sentences
    # compare with each other
    # sents_pairs = []
    # for si,i in the_sents
    #   s_i = si[1]
    #   for sj, j in the_sents
    #     s_j = sj[1]
    #     continue if i is j
    #     for wrd_i in s_i.sentenceWords
    #       for wrd_j in s_j.sen

    the_sents

  #
  # Public: choose what sentence should we kick out
  #
  #
  exports.shortenMore = shortenMore = (sentencesArray, collocations=[], pattern=/pron/) ->
    collo2array = (collocations, pat=pattern) ->
      cs = []
      for colo in collocations
        if pat.test colo.pattern
          colo.sentences.map (i) -> cs.push i 
      cs = cs.sort (a, b) -> a  - b
      cs
    

    txt = sentencesArray

    _max = 0
    txt.map (s, i) ->
      l = s.split(/\s/).length
      if l > _max
        _max = l
    t = []  
    txt.map (x, i) ->
      t.push val: x, words: x.split(/\s/).length, i: i

    t = t.sort (a, b) -> b.words - a.words

    coloarr = collo2array collocations


    rm_sent = null
    rm_len = -1
    # TODO add multi removal
    t.map (x) ->
      if x.i in coloarr
        x.colocs = yes
      else
        x.colocs = no
        if x.words > rm_len
          rm_len = x.words
          rm_sent = x.i


    if rm_sent is null    # not found, remove most longer
      t.map (x) ->
        if x.words > rm_len
          rm_len = x.words
          rm_sent = x.i

    t = t.sort (a,b) -> a.i - b.i
    t.map (x) ->
      unless x.i is rm_sent
        x.val
      else
        ""



  ###
  Extract feelings from text. This filter use results of misc `filter`.

  @param {String} text Source text ( not used)
  @param {Object} result Resulting object, that contain `meaning`
                         field after applying this filter.
  @param {Object} opts Options, :default {}
                 opts.dictOfWords      : Dict, that contain key as metric name and dict of
                                         words (with strength from 1 to bigger num) as value
                 opts.collocationRules : Overrided rules for collocations - array of strings,
                                         consisting from keywords separated with dots, e.g.
                                         "prep.adj.noun"
                                         @see `plugins.ru.inclines.classifyWord` for keywords
  ###
  exports.postFilter = (text, result, opts={}) ->
    # todo add persons as acting objects
    emoIndex        = []
    overallIndex    = 0
    absIndex        = 0
    collocations    = []
    properNames     = if result.ru?.persons? then result.ru.persons else {}
    dictsOfMetrics  = opts.dictOfWords || {negative: negativeWords}
    metrics         = {}

    totalWords = 0
    for s,i in result.misc.sentences
      pps = parseSentence s, properNames, opts.collocationRules || null

      for k, metricsDict of dictsOfMetrics
        metrics[k] ||= {}
        [index, scoreWords, tw] = evaluateSentenceScore pps.sentenceWords, metricsDict
        totalWords += tw
        metrics[k].index      ||= []
        metrics[k].indexTotal ||= 0
        metrics[k].indexTotal  += index
        metrics[k].normIndex  ||= 0 # normalized index, 1 if any word from dict found, else 0
        metrics[k].normIndex   += 1 if index > 0
        metrics[k].index.push value:index, words:scoreWords


      # push collocations
      if pps.collocation
        for col in pps.collocation
          found_colo = no
          for c in collocations
            if c.inf is col.inf
              found_colo = yes
              c.total += col.total
              for frm in col.forms
                c.forms.push frm
                c.sentences.push i unless i in c.sentences
          unless found_colo
            col.sentences = [i]
            col.pattern = col.forms[0].pat
            collocations.push col 


    for k, metricsDict of dictsOfMetrics
      if metrics[k] and metrics[k].index
        # get maximum score
        dVal = util.dictValues metricsDict
        metrics[k].maxScale = Math.max.apply @, if dVal.length > 0 then dVal else [1]
        metrics[k].scoreTotal = metrics[k].normIndex / result.misc.sentences.length
        metrics[k].scoreTotalPersent = 100 * metrics[k].scoreTotal


    result.metrics  = metrics
    result.meaning =
      wordsAnalysed : totalWords
      collocations  : collocations

    # merge result.ru.cap_words and result.meaning.collocations -> find proper names
    realPn = {}
    for wrd, i of result.ru.cap_words
      for col in collocations
        for f in col.forms
          ind = f.src.indexOf wrd
          unless ind is -1
            if f.pat.split(".")[ind] is "noun" # proper name must be noun!
              w = inclines.analyseNoun(wrd)
              inf = w.infinitive
              if inf.length > 0
                wrd0 =
                  if inf.length is 1
                    inf[0]
                  else
                    if inf[0][-1..-1] is "е" # hack!
                      inf[1]
                    else
                      inf[0]

                unless realPn[wrd0]
                  realPn[wrd0] =
                    inf: inf
                    total: 1
                    src: [wrd]
                else
                  realPn[wrd0].total++
                  realPn[wrd0].src.push wrd unless wrd in realPn[wrd0].src
                

    result.meaning.proper_names = realPn
    result.meaning.shorten_text = shortenText result



)(exports, inclines, quotes, util)
