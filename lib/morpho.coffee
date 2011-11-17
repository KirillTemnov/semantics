###
Morphological analysis for russian texts
###

ruW = require "./ru-words"
sys = require "util"

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



