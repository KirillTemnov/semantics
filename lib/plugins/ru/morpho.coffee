###
Morphological analysis for russian texts
###

if "undefined" is typeof global
    window.lastName ||= {}
    window.lastName.plugins ||= {}
    window.lastName.plugins.ru || = {}
    window.lastName.plugins.ru.morpho = {}
    exports = window.lastName.plugins.ru.morpho
    ruWords = window.lastName.plugins.ru.words
else
    ruWords = require "./words"


((exports, ruWords) ->
  ###
  Get endings for russian adjectives.
  ###
  exports.getAdjectiveEnds = ->
    feminine:
      ends: /((ая)|(ой)|(ую)|(яя)|(ей)|(юю))$/g
      hard: /((ая)|(ой)|(ую))$/g
      sort: /((яя)|(ей)|(юю))$/g
      hardNominativeEnd: "ая"
      softNominativeEnd: "яя"
      gender: "feminine"
      singular: yes
      incline: (word) ->
        end = word[-2..]
        word = word[..-3]
        if end is "ая"
          ["#{word}ая", "#{word}ой", "#{word}ой", "#{word}ую", "#{word}ой", "#{word}ой"]
        else
          ["#{word}яя", "#{word}ей", "#{word}ей", "#{word}юю", "#{word}ей", "#{word}ей"]
    masculine:
      ends: /((ый)|(ого)|(ому)|(ым)|(ом)|(ий)|(его)|(ему)|(им)|(ем))$/g
      hard: /((ый)|(ого)|(ому)|(ым)|(ом))$/g
      soft: /((ий)|(его)|(ему)|(им)|(ем))$/g
      hardNominativeEnd: "ый"
      softNominativeEnd: "ий"
      gender: "masculine"
      singular: yes
      incline: (word) ->
        end = word[-2..]
        word = word[..-3]
        if end is "ый"
          if /[жшцчщгкх]$/.test word
            ["#{word}ий", "#{word}ого", "#{word}ому", "#{word}ий", "#{word}им", "#{word}ом"]
          else
            ["#{word}ый", "#{word}ого", "#{word}ому", "#{word}ый", "#{word}ым", "#{word}ом"]
        else
          ["#{word}ий", "#{word}его", "#{word}ему", "#{word}ий", "#{word}им", "#{word}ем"]

    neuter:
      ends: /((ое)|(ого)|(ому)|(ым)|(ом)|(ее)|(его)|(ему)|(им)|(ем))$/g
      hard: /((ое)|(ого)|(ому)|(ым)|(ом))$/g
      soft: /((ее)|(его)|(ему)|(им)|(ем))$/g
      hardNominativeEnd: "ое"
      softNominativeEnd: "ее"
      gender: "neuter"
      singular: yes
      incline: (word) ->
        end = word[-2..]
        word = word[..-3]
        if end is "ое"
          ["#{word}ое", "#{word}ого", "#{word}ому", "#{word}ое", "#{word}ым", "#{word}ом"]
        else
          ["#{word}ее", "#{word}его", "#{word}ему", "#{word}ее", "#{word}им", "#{word}ем"]

    plural:
      ends: /((ые)|(ых)|(ым)|(ыми)|(ых)|(ие)|(их)|(им)|(ими)|(их))$/g
      hard: /((ые)|(ых)|(ым)|(ыми)|(ых))$/g
      soft: /((ие)|(их)|(им)|(ими)|(их))$/g
      hardNominativeEnd: "ые"
      softNominativeEnd: "ие"
      gender: "unknown"
      singular: no
      incline: (word) ->
        end = word[-2..]
        word = word[..-3]
        if end is "ые"
          if /[жшцчщгкх]$/.test word
            ["#{word}ие", "#{word}их", "#{word}им", "#{word}ие", "#{word}ими", "#{word}их"]
          else
            ["#{word}ые", "#{word}ых", "#{word}ым", "#{word}ые", "#{word}ыми", "#{word}ых"]
        else
          ["#{word}ие", "#{word}их", "#{word}им", "#{word}ие", "#{word}ими", "#{word}их"]


  exceptions = (word) ->
  # заяв[ил] заяв[лять]
  # получ[ил] получ[ать]


  getRulesVerb = [
    [/нул[aи]{0,1}$/g, "ать"]
    [/еть$/g, "ать"]
    [/(ает)|(ают)$/g, "ать"]
    [/ал[aи]{0,1}$/g, "ать"]
    [/ул[aи]{0,1}$/g, "ать"]
    [/((ить)|(ать))$/g, "ать"]
    [/ая$/g, "ать"]
    [/((ил)|(или)|(ила)|(ило))$/g, "лять"]
    [/(ятся)|(ится)|(ился)|(илась)|(илось)$/g, "ится"]
    [/(яться)|(иться)$/g, "иться"]]


  getRulesAdjective = [
    [/в((ая)|(ые)|(ый)|(ое))$/, "вый"]
    [/((ая)|(ой)|(ие)|(ые)|(ый)|(ую))$/, "ый"]
    [/((яя)|(ее)|(ий)|(юю))$/, "ий"]]


  exports.morpho = morphoRu = (word) ->
    if word in ruWords.adverbs
      return {type: "abverb", value: word}
    if (word in ruWords.prepositionAll)
      return {type: "preposition", value: word}
    if word in ruWords.unions
      return {type: "union", value: word}

    result = {type: "", value: ""}
    verb = null
    adjective = null
    for rule in getRulesVerb()
      if rule[0].test word
        result = {type: verb, value: word.replace rule[0], rule[1]}
        break

    for rule in getRulesAdjective()
      if rule[0].test word
        adj = word.replace rule[0], rule[1]
        if result.type
          result.type += " adjective"
          result.value = [result.value, adj]
        else
          result = {type: "adjective", value: adj}
        break

    result

  # todo work on it later
  exports.analyseText = (text) ->
    punctuationRe = /[\.,:\/\\\?!\+\'\"«»\*\(\)\[\]\&№“”\—]/g
    doubleSpaceRe = /\s+/g

    text = text.replace(punctuationRe, " $& ").replace(doubleSpaceRe, " ") + " ."
    result = []
    for t in text.split " "
      ruRe = /^[а-я\-ё]+$/ig
      enRe = /^[a-z\-]+$/ig
      wordRe = /^[а-яё\-\da-z]+$/ig

      r =  morphoRu t.toLowerCase()
      switch (r.type)
        when "adverb"
          result.push "[ADV #{t}]"
        when "verb", "adjective"
          result.push "[ #{r.value} ]"
        when "verb adjective"
          result.push "[#VA #{r.value[0]}]"
        when "union"
          result.push "[U #{t}]"
        when "preposition"
          result.push "[PP #{t}]"
        else
          result.push t

      if t == "."
        result.push "\n"
    result

  ###
  Parse russian centense and extract abbrevs/ words beginning with an uppercase letter.

  @param {Array|String} sentence Sentence or array of sentences.
  @return {Object} result Return dict of special words, dict of abbrevs and dict of
                         regular words with its frequencies
  ###
  exports.parseRuSentence = (sentences) ->
    sentences = [sentences] unless sentences instanceof Array
    abbrevs = {}
    special_words = {}            # Capitalized words
    digits = {}                   # digits, including floating point digits
    common_used_words = {}        # adverbs, prepositions, unions
    regular_words = {}            # all other russian words, except common_used_words
    total_words = 0
    sentences.map (sent) ->
      words = sent.split " "
      for word, i in words
        unless /^[[,:\/\\\?!\+\-\*\(\)\[\]\&\№\—]]+$/.test words
          total_words++
                                      # digit?
        if /^(\d+(|(\.(|\d+))))$/.test word
          unless digits[word]
            digits[word] = 1
          else
            digits[word]++
                                      # abbrev?
        else if isUpperCase(word) and /^[а-яё\-]{2,}$/i.test word
          unless abbrevs[word]
            abbrevs[word] = 1
          else
            abbrevs[word]++


                                      # proper name?
        # todo proper name can be the first word in sentence
        else if i > 0 && isCapitalized(word) and /^[а-яё\-]{2,}$/i.test word
          # more analysis here, including next and previous words
          unless special_words[word]
            special_words[word] = 1
          else
            special_words[word]++



        else if /^[а-яё\-]+$/i.test(word) and not /^\-+$/.test word
          w = word.toLowerCase()
          result = morphoRu w
          unless result.type in ["adverb", "preposition", "union"]
            unless regular_words[w]
              regular_words[w] = 1
            else
              regular_words[w]++

          else
            unless common_used_words[w]
              common_used_words[w] = 1
            else
              common_used_words[w]++
    abbrevs: abbrevs
    common_used_words: common_used_words
    special_words: special_words
    regular_words: regular_words
    digits: digits
    total_words: total_words

)(exports, ruWords)

