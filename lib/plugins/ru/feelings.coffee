###
Feeling words

###
# depends on inclines and counters
if "undefined" is typeof global
    window.lastName.plugins.ru.feelings = {}
    exports = window.lastName.plugins.ru.feelings
    inclines = window.lastName.plugins.ru.inclines
else
    exports = module.exports
    inclines = require "./inclines"

((exports, inclines) ->

  exports.positive = []

  # 249
  negativeAdjectives = { "агрессивный" : 3, "атакованный" : 2, "бедный" : 2, "беззащитный" : 2, "безнадежный" : 3, "безрадостный" : 2, "бесплодный" : 3, "беспомощный" : 3, "бесправный" : 2, "бессердечный" : 1, "бессильный" : 1, "бесцельный" : 2, "бесчестный" : 2, "вздорный" : 1, "виновный" : 1, "ворчливый" : 1, "враждебный" : 2, "вспыльчивый" : 1, "выпученный" : 1, "выселенный" : 3, "высмеянный" : 2, "выхолощенный" : 1, "глубокий" : 1, "глупый" : 2, "горький" : 2, "готический" : 2, "гротескный" : 1, "грустный" : 1, "грязный" : 1, "девальвированный" : 2, "деградировавший" : 2, "дегуманизированный" : 2, "дезорганизованный" : 2, "дезориентированный" : 2, "деморализованный" : 3, "дерзкий" : 1, "дерьмовый" : 3, "дефектный" : 3, "драматический" : 3, "жалкий" : 3, "жесткий" : 2, "жестокосердный" : 2, "заброшенный" : 1, "забываемый" : 1, "забывчивый" : 1, "забытый" : 2, "зависимый" : 1, "заинтересованный" : 1, "запрещенный" : 3, "запутанный" : 2, "застенчивый" : 1, "застрявший" : 1, "затравленный" : 2, "зверский" : 3, "злобный" : 2, "идиотский" : 3, "измельченный" : 2, "измученный" : 2, "изнасилованный" : 3, "изолированный" : 3, "изумленный" : 1, "интенсивный" : 1, "иррациональный" : 2, "исключенный" : 2, "искусственный" : 2, "испуганный" : 2, "истерический" : 3, "исчерпанный" : 2, "капризный" : 2, "контролируемый" : 1, "критический" : 1, "ленивый" : 2, "лишенный" : 2, "ложный" : 2, "мазохистский" : 1, "мертвый" : 3, "меченый" : 2, "мрачный" : 2, "мстительный" : 2, "навязчивый" : 2, "надоедливый" : 2, "наказанный" : 2, "нарушенный" : 2, "натянутый" : 2, "неадекватный" : 2, "неактивный" : 1, "небезопасный" : 2, "небрежный" : 1, "невежественный" : 1, "невидимый" : 1, "невротический" : 2, "негуманный" : 2, "недействительный" : 1, "недовольный" : 2, "недостаточный" : 1, "недоуменный" : 1, "незаземленный" : 1, "незначительный" : 1, "неискренний" : 1, "некомпетентный" : 2, "ненавистный" : 3, "необщительный" : 2, "неполный" : 2, "неправильный" : 2, "неприятный" : 2, "нервный" : 2, "нерешительный" : 1, "несбалансированный" : 1, "несовместимый" : 2, "несоответствующий" : 2, "неспособный" : 3, "несчастный" : 2, "неуклюжий" : 2, "неуловимый" : 1, "неуместный" : 2, "нечестный" : 2, "неэффективный" : 2, "низкий" : 1, "обвиняемый" : 3, "обедненный" : 1, "обезумевший" : 3, "обиженный" : 2, "обманутый" : 2, "обозленный" : 2, "оборонительный" : 1, "обремененный" : 1, "обременительный" : 1, "обреченный" : 2, "ограниченный" : 1, "одержимый" : 3, "одинокий" : 2, "одноразовый" : 1, "озабоченный" : 2, "окаменелый" : 1, "онемелый" : 1, "опальный" : 2, "опасный" : 3, "опустошенный" : 1, "опущенный" : 2, "опьяненный" : 1, "оскорбленный" : 2, "осмеянный" : 2, "острый" : 1, "осужденный" : 3, "осушенный" : 2, "ответственный" : 2, "отвратительный" : 3, "отдаленный" : 1, "отдельный" : 1, "отрицательный" : 2, "отсталый" : 2, "отчаянный" : 1, "ошибочный" : 1, "параноидальный" : 2, "паршивый" : 2, "пассивный" : 1, "переполненный" : 2, "пессимистический" : 2, "печальный" : 2, "побежденный" : 3, "поверхностный" : 2, "поврежденный" : 3, "подавленный" : 2, "поддельный" : 3, "покинутый" : 2, "покорный" : 1, "порабощенный" : 3, "потерянный" : 2, "потерпевший" : 2, "потребленный" : 1, "презираемый" : 2, "презренный" : 3, "презрительный" : 2, "прерванный" : 1, "принудительный" : 2, "психотический" : 2, "пустынный" : 1, "пьяный" : 2, "равнодушный" : 1, "развращенный" : 3, "раздраженный" : 2, "раздражительный" : 2, "разочарованный" : 2, "разочаровывающий" : 3, "разрушенный" : 3, "разрушительный" : 2, "разъяренный" : 3, "раненый" : 2, "ревнивый" : 2, "садистский" : 2, "самоубийственный" : 3, "саркастический" : 1, "сварливый" : 1, "сгоревший" : 3, "сердитый" : 2, "серый" : 1, "скучающий" : 1, "скучный" : 1, "сломанный" : 2, "смущенный" : 1, "созерцательный" : 1, "сомнительный" : 2, "спорный" : 2, "спровоцированный" : 2, "спутанный" : 2, "спущенный" : 2, "стереотипный" : 1, "стесненный" : 1, "странный" : 1, "страшный" : 2, "сумасшедший" : 2, "тихий" : 1, "тормозящий" : 2, "торопливый" : 2, "тоскливый" : 3, "требовательный" : 2, "тревожный" : 2, "трудный" : 2, "трусливый" : 2, "тупой" : 1, "тщеславный" : 2, "угнетенный" : 2, "угрюмый" : 2, "удаляемый" : 2, "удрученный" : 2, "ужасный" : 3, "уклончивый" : 2, "униженный" : 3, "унылый" : 3, "урезанный" : 2, "фальшивый" : 3, "хаотический" : 2, "холодный" : 1, "хрупкий" : 1, "цепкий" : 2, "циничный" : 2, "чертовский" : 2, "чрезмерный" : 2, "чувствительный" : 2, "эгоистичный" : 2, "эгоцентричный" : 3, "эксплуатируемый" : 2, "эмансипированный" : 2, "эмоциональный" : 1, "яростный"  : 3}

  negativeVerbs = {"беспокоить" : 2, "бить" : 2, "внушать" : 2, "волноваться" : 2, "высмеивать" : 2, "грызть" : 1, "диктовать" : 2, "дребезжать" : 1, "дрожать" : 1, "дрогнуть": 2, "загнать" : 2, "запугивать" : 3, "запутаться" : 2, "злоупотреблять" : 2, "игнорировать" : 1, "избегать" : 1, "издеваться" : 3, "изменять" : 2, "командовать" : 1, "лгать" : 2, "лишить" : 2, "манипулировать" : 2, "молчать" : 1, "надувать" : 1, "ненавидеть" : 3, "обвинять" : 2, "обидеть" : 2, "опорочить" : 3, "освистать" : 3, "отбрасывать" : 1, "отвлекаться" : 2, "отклонить" : 2, "отрекаться" : 3, "оттолкнуть" : 2, "паниковать" : 2, "перепутаться" : 2, "подавить" : 3, "подвергаться" : 2, "пострадать" : 2, "предавать" : 3, "пренебрегать" : 2, "препятствовать" : 2, "преследовать" : 2, "принижаться" : 2, "приставать" : 2, "прослушивать" : 2, "разгромить" : 2, "раздражаться" : 2, "растаскивать" : 2, "рисковать" : 2, "ругать" : 2, "сдуваться" : 1, "смолчать" : 2, "снизиться" : 1, "сорвать": 1, "сожалеть" : 2, "соизволить" : 2, "солгать" : 2, "сомневаться" : 2, "споткнуться" : 1, "столкнуться" : 2, "страдать" : 2, "стрелять" : 3, "судить" : 2, "толкнуть" : 1, "убить": 3, "убивать": 3, "уговаривать" : 1, "удалять" : 2, "уклоняться" : 2, "унижать" : 3, "шантажировать" : 2}

  negativeWordsIncline = {"боль": 2, "вниз" : 1, "горе" : 3, "дно": 2, "мало": 1, "мучение": 2 , "недовольство": 2, "плохо": 2, "противно": 3, "совестно": 2, "только": 1, "ужас": 3, "смерть": 3, "неодобрительно": 2, "разгром" : 2, "отчаяние" : 3}

  ###
  Get array of negative phrases re.

  ###
  exports.getNegativePhrasesRe = getNegativePhrasesRe = ->
    [
      [/[^а-яё]при\sотягчающих\sобстоятельствах[^а-яё]/ig                          , 2]
      [/[^а-яё]ненависть\sк[^а-яё]/ig                                              , 3]
      [/[^а-яё]в\sубыток[^а-яё]/ig                                                 , 2]
      [/[^а-яё]сыт[аы]?\sпо\sгорло[^а-яё]/ig                                       , 3]
      [/[^а-яё]заслужива[ею]т\sнаказания[^а-яё]/ig                                 , 2]
      [/[^а-яё]находящ(егося|ейся|емся|ихся)\sпод\sугрозой\sисчезновения[^а-яё]/ig , 3]
      [/[^а-яё]в\sзаблуждение[^а-яё]/ig                                            , 2]
      [/[^а-яё]сбит[аы]?\sс\sтолку[^а-яё]/ig                                       , 2]
      [/[^а-яё]в\sужасе[^а-яё]/ig                                                  , 3]
      [/[^а-яё]не\sрекоменд(ую|уем|уется|овал|овала|овали)[^а-яё]/ig               , 2]
      [/[^а-яё]не\sодобря(ю|ем|л|ла|ли|ется)[^а-яё]/ig                             , 2]
      [/[^а-яё]пятно\sна[^а-яё]/ig                                                 , 2]
      [/[^а-яё]в\sклетке[^а-яё]/ig                                                 , 1]
      [/[^а-яё]неправильно\sпонял[аи]?[^а-яё]/ig                                   , 2]
      [/[^а-яё]вне\sпределов\sдосягаемости[^а-яё]/ig                               , 1]
      [/[^а-яё]взял[аи]?\sна[^а-яё]/ig                                             , 2]
      [/[^а-яё]играл[аи]?\sс[^а-яё]/ig                                             , 2]
      [/[^а-яё]черный\sсписок[^а-яё]/ig                                            , 3]
      [/[^а-яё]возбужден[оы]\sуголовн(ое|ые)\sдел[оа][^а-яё]/ig                    , 2*2*2]
      [/[^а-яё]жертв(|а|ы|ам|ами)[^а-яё]/ig                                           , 3]
    ]
      #"кричать на"

  exports.evaluateSentenceNeutrality = evaluateSentenceNeutrality = (sentence) ->
    index      = 0                   # check out proper names!
    cur_index  = 0
    words      = []
    curWords   = []

    for nr in getNegativePhrasesRe()
      m = sentence.match nr[0]
      if m
        m.map (wordsSequence) -> words.push wordsSequence
        index -= nr[1] * m.length

    resetCurIndex =  ->
      if cur_index
        index += cur_index
        words.push curWords
        curWords = []
        cur_index = 0

    for wrd in sentence.split /\s/
      if wrd in ".,-—!?()[]"
        cur_index = -cur_index
        resetCurIndex()
        continue

      ind = negativeWordsIncline[wrd.toLowerCase()]
      if ind
        curWords.push wrd
        cur_index = cur_index * ind || ind
      else
        adjArray = inclines.getInitialFormOfAdjective wrd
        unless adjArray
          # check for verbs
          verb = inclines.getVerbInfinitive wrd
          vIndex = negativeVerbs[verb]
          if vIndex
            curWords.push wrd
            cur_index = cur_index * vIndex || vIndex
          else
            cur_index = -cur_index
            resetCurIndex()
        else
          for adj in adjArray
            adjIndex = negativeAdjectives[adj]
            if adjIndex
              curWords.push wrd
              cur_index = cur_index * adjIndex || adjIndex
              break

    resetCurIndex -cur_index
    [index, words]

  exports.postFilter = (text, result) ->
    emoIndex = []
    overallIndex = 0
    for s,i in result.misc.sentences
      [index, emoWords] = evaluateSentenceNeutrality s
      emoIndex.push [index, emoWords]
      overallIndex += index

    result.feelings =
      emoIndex     : emoIndex
      overallIndex : overallIndex
      emoScore     :  overallIndex / result.counters.words_total || 1

)(exports, inclines)