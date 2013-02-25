getOpts = ->
  stopWordsInp = document.getElementById("stop-words")
  stopWords = stopWordsInp.value.replace(/\s+/g, " ").toLowerCase().split().filter((x) ->
    !!x
  )
  goodWordsInp = document.getElementById("good-words")
  badWordsInp = document.getElementById("bad-words")
  goodWords = semantics.util.textToDict(goodWordsInp.value)
  badWords = semantics.util.textToDict(badWordsInp.value)
  opts = {}
  # opts = dictOfWords: {}
  # opts.dictOfWords["good"] = goodWords  if goodWordsInp.value.length > 0
  # opts.dictOfWords["bad"] = badWords  if badWordsInp.value.length > 0
  if stopWords.length > 0
    opts.replaceStopWords = yes
    opts.stopWords = stopWords
  opts

fanalysis = document.getElementById("analysis")
clear = document.getElementById("clear")
fmeaning = document.getElementById("meaning")
fverbinf = document.getElementById("verb-infinitive")
fnoon = document.getElementById("analyse-noon")
fsentence = document.getElementById("sentence")
fscores = document.getElementById("scores")
fguessInitForm = document.getElementById("guess-initial-form")
formulaInp = document.getElementById("formula")
input = document.getElementById("in-text")
output = document.getElementById("out-text")


clear.addEventListener "click", (-> output.value = ""), no

fscores.addEventListener "click", (->
  formula = formulaInp.value
  scores = semantics.analysis.twitterScores(input.value, [semantics.misc, semantics.mimimi, semantics.quotes, semantics.plugins.ru.words, semantics.plugins.ru.abbrevs, semantics.plugins.ru.dates, semantics.plugins.ru.propernames, semantics.plugins.ru.twitter, semantics.plugins.ru.meaning], getOpts())
  output.value = JSON.stringify(scores) + "\n\n" + semantics.analysis.applyFormula(formula, scores)
), no


fsentence.addEventListener "click", (->
  output.value = JSON.stringify(semantics.plugins.ru.meaning.parseSentence(input.value.trim()), null, 2)
), no

fanalysis.addEventListener "click", (->
  val = input.value
  val = val.replace /\n/g, "\n. "
  result = semantics.analysis.analyse(val, [semantics.misc, semantics.mimimi, semantics.quotes, semantics.plugins.ru.words, semantics.plugins.ru.abbrevs, semantics.plugins.ru.propernames, semantics.plugins.ru.twitter, semantics.plugins.ru.meaning], getOpts())

  # out = ["Всего слов: \t\t" + result.counters.words_total, "Стоп слов: \t\t" + result.counters.stop_words_total, "Предложений: \t\t" + result.misc.sentences.length, "Длина слова: \t\t" + result.counters.word_length_mid.toFixed(2) + " букв", "Длина предложения:\t" + result.counters.words_in_sentence_mid.toFixed(2) + " слов", "Вода:\t\t\t" + (100 * result.counters.stop_words_persent).toFixed(2) + " %", "twitter:\n", "Ссылки:\t " + JSON.stringify(result.twitter.pos.urls), "Хеш-теги:\t " + JSON.stringify(result.twitter.pos.hash_tags), "Упоминания:\t " + JSON.stringify(result.twitter.pos.mentions), "Ключевые слова:\t " + JSON.stringify(result.twitter.pos.kw), "Свои слова:\t " + JSON.stringify(result.twitter.pos.user_defined_words), "\n----------------------------------------\n", ((if semantics.util.dictKeys(result.ru.abbrevs).length > 0 then "Аббревиатуры:\t\t" + semantics.util.dictKeys(result.ru.abbrevs).join(", ") else "")), ((if semantics.util.dictKeys(result.ru.persons).length > 0 then "Люди:\t\t\t" + semantics.util.dictKeys(result.ru.persons).map((x) ->
  #   x.replace(/-/g, " ").trim()
  # ).join(", ") else "")), ((if result.ru.addresses.length > 0 then "Адреса:\n\t\t\t\t" + result.ru.addresses.join("\n\t\t\t\t") else "")), "Фразы:\t" + result.meaning.collocations.join("\n")].filter((x) ->
  #   !!x
  # )
  # output.value = out.join("\n")

  wrds = []
  for k,v of result.meaning.proper_names
    wrds.push k[0].toUpperCase() + k[1..]


  the_sents = result.meaning.shorten_text.join "\n"


  top_wrds = []
  for k,v of result.ru.words
    if v >= 2
      top_wrds.push [k,v]
  top_wrds.sort (a,b) -> b[1] - a[1]
  top_wrds = top_wrds.map (w) -> w[0]

  mv = [] #semantics.plugins.ru.inclines.mergeWords result.ru.words
  # for w, c of result.ru.words
  #   wrd = semantics.plugins.ru.inclines.classifyWord w
  #   if wrd.type in ["verb", "verb/noun"]
  #     mv.push [wrd.infinitive, wrd.src]

  for col in result.meaning.collocations
    ind = col.pattern.split(".").indexOf "verb"
    if ind > -1
      verb = col.forms[0].src[ind]
      mv.push verb unless verb in mv



  out = [
    "Краткое содержание:"
    the_sents
    "\n\nСжатие: #{(100 *(1 - the_sents.length/input.value.length)).toFixed 2} %"
    # "\n\nФразы: "
    # cols.join "\n"
    "Важно: #{wrds}"
    "Слова: #{JSON.stringify top_wrds, null, 2}"
    "Cлив: #{JSON.stringify mv, null, 2}"
    ]

  output.value = out.join "\n"

  window.result = result
), no

fguessInitForm.addEventListener "click", (->
  wordList = input.value.replace(/\s+/g, " ").trim().split " "
  for w in wordList
    wrd = semantics.plugins.ru.inclines.classifyWord(w)
    if wrd.type is "verb"
      output.value += "глагол: " + wrd.infinitive
    else if wrd.type is "adv"
      output.value += "наречие: " + wrd.infinitive
    else if wrd.type is "pronouns"
      output.value += "местоимение: " + wrd.infinitive
    else if wrd.type is "union"
      output.value += "союз: " + wrd.infinitive
    else if wrd.type is "part"
      output.value += "частица: " + wrd.infinitive
    else if wrd.type is "prep"
      output.value += "предлог: " + wrd.infinitive
    else if wrd.type is "adj"
      output.value += "прилагательное: " + wrd.infinitive
    else if wrd.type is "noun"
      output.value += "существительное: " + wrd.infinitive
    else
      output.value += "#{wrd.infinitive} [#{wrd.type}]"
    output.value += " [стоп-слово] "  if wrd.stopWord
    output.value += "\n"
  swords = semantics.plugins.ru.meaning.parseSentence(wordList.join(" ")).sentenceWords
  output.value += "Patterns\n" +
    JSON.stringify semantics.plugins.ru.meaning.extractPatterns(swords), null, 2
  
), no
fnoon.addEventListener "click", (->
  output.value = JSON.stringify(semantics.plugins.ru.inclines.analyseNoun(input.value.trim()), null, 2)
), no
fverbinf.addEventListener "click", (->
  output.value = JSON.stringify(semantics.plugins.ru.inclines.getVerbInfinitive(input.value.trim()), null, 2)
), no
fmeaning.addEventListener "click", (->
  window.result = result = semantics.analysis.analyse input.value, [semantics.misc, semantics.mimimi, semantics.quotes, semantics.plugins.ru.words, semantics.plugins.ru.abbrevs, semantics.plugins.ru.dates, semantics.plugins.ru.propernames, semantics.plugins.ru.twitter, semantics.plugins.ru.meaning, semantics.plugins.en.words], getOpts()
  # colo = result.meaning.collocations.map (c) ->
  #     if c.total > 1
  #       console.log JSON.stringify c, null, 2
  output.value = JSON.stringify window.result, null, 2
), no
