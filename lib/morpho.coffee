###
Morphological analysis for russian texts
###

ruW = require "./ru-words"
sys = require "util"

exceptions = (word) ->

# заяв[ил] заяв[лять]
# получ[ил] получ[ать]


rulesVerb = [
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


rulesAdjective = [
  [/в((ая)|(ые)|(ый)|(ое))$/, "вый"]
  [/((ая)|(ой)|(ие)|(ые)|(ый)|(ую))$/, "ый"]
  [/((яя)|(ее)|(ий)|(юю))$/, "ий"]]


exports.morphoRu = morphoRu = (word) ->
  if word in ruW.adverbs
    return {type: "abverb", value: word}
  if (word in ruW.prepositionAll)
    return {type: "preposition", value: word}
  if word in ruW.unions
    return {type: "union", value: word}

  result = {type: "", value: ""}
  verb = null
  adjective = null
  for rule in rulesVerb
    if rule[0].test word
      result = {type: verb, value: word.replace rule[0], rule[1]}
      break

  for rule in rulesAdjective
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
  punctuationRe = /\.|,|:|\/|\\|\?|!|\+|\'|\"|\«|\»|\*|\(|\)|\[|\]|\&|\№|(RT)|“|”\—/g
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



