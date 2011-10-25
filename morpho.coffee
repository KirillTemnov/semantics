###
Morphological analysis for russian texts
###

ruW = require "./ru-words"
sys = require "sys"
cases = require "./index"


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


morphoRu = (word) ->
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
#  console.log "verb = #{verb}\tadjective = #{adjective}"

isCapitalized = (word) ->
  if 0 <= word.indexOf "-"
    cap = yes
    word.split("-").map (wrd) -> cap &&= isCapitalized wrd
    cap
  else
    word &&  word == "#{word[0].toUpperCase()}#{word[1..].toLowerCase()}" || no


findProperName = (namesList) ->
  for name in namesList
    # All possible combinations:
    # Firstname Middlename Lastname     (3)
    # F M Lastname                      (3)
    # Lastname Firstname Middlename     (3)
    # Lastname F M                      (3)
    # Firstname Lastname                (2)
    # Lastname Firstname                (2)
    # F Lastname                        (2)
    # Lastname F                        (2)
    # Lastname                          (1)
    switch name.value.length
      when 1                    # surname
        yes
      when 2                    # firstname + lastname
        ifn1 = cases.inclineFemName name.value[0]
        ifn2 = cases.inclineFemName name.value[1]
        imn1 = cases.inclineMaleName name.value[0]
        imn2 = cases.inclineMaleName name.value[1]
        sn1 = cases.inclineMaleSurname name.value[0]
        sn2 = cases.inclineMaleSurname name.value[1]
        console.log "ifn1 = #{sys.inspect ifn1}"
        console.log "ifn2 = #{sys.inspect ifn2}"
        console.log "imn1 = #{sys.inspect imn1}"
        console.log "imn2 = #{sys.inspect imn2}"
        console.log "sn1 = #{sys.inspect sn1}"
        console.log "sn2 = #{sys.inspect sn2}"
      when 3                    # f m l
        yes



word = process.argv[2]
if word
#  console.log "result = #{sys.inspect cases.inclineName word}"
  console.log "result = #{sys.inspect cases.findProperName process.argv[2..]}"
else
  text = require("./samples").text2
  console.log "source:\n#{text}"
  console.log "--------------------------------------------------------------------------------"
  punctuationRe = /\.|,|:|\/|\\|\?|!|\+|\'|\"|\«|\»|\*|\(|\)|\[|\]|\&|\№|RT|“|”\—/g
  doubleSpaceRe = /\s+/g

  properNames = []
  curProperName = []
  properNameLang = ""
  resetProperName = ->
    if 0 < curProperName.length <= 5
      properNames.push {value: curProperName, lang: properNameLang}
    curProperName = []
    properNameLang = ""



  # add point at the end
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

    if isCapitalized(t) && wordRe.test(t) && !(r.type in ["adverb", "union", "preposition"])
      console.log "#{t} Capitalized"
      if !properNameLang        # first part
        curProperName.push t
        if ruRe.test(t)
          properNameLang = "ru"
        else if enRe.test(t)
          properNameLang = "en"
        else                    # drop it
          curProperName = []                 #?
      else
        # continue padding
        if (properNameLang == "ru" && ruRe.test t) || (properNameLang == "en" && enRe.test t)
          curProperName.push t
        else                    # save previous result
          resetProperName()
    else
      resetProperName()

    if t == "."
      result.push "\n"
  console.log result.join " "
  findProperName properNames
  console.log "\n\nProper names: #{sys.inspect properNames}"

