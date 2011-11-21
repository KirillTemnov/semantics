###
Module provide api for library
###

# if "undefined" is typeof global
#     window.lastName ||= {}
#     exports = window.lastName
#     ruWords = window.lastName.plugins.ru.words
# else
#     ruWords = require "./words"


#((exports) ->
util              = require "./util"
exports.version   = util.version

fs                = require "fs"
exec              = require('child_process').exec


###
Expand single url via curl

@param {String} url Url to expand
@param {Function} fn Callback function, accept 1) examined url, 2) source url.
                     in case of timeout or other errors, "error" will return
                     as second prameter.
###
doExpandUrl = (url, fn) ->
  lastLocation = url
  exec "curl --connect-timeout 5 -IL #{url}", (error, stdout) ->
    m = stdout.match /^Location\:\s+(https?:\/\/\S+)*$/mig
    if m
      lastLocation = m[-1..][0].match(/https?:\/\/\S+/).toString()
    if error
      lastLocation = "error"
    fn url, lastLocation


###
Expand array of urls or single url.

@param {Array|String} urls Single url to expand or array of urls
@param {Function} fn Callback function, accept 1) array or resulst.
                     each result consists of array [source, dest].
                     where dest may be "error" or destignation url.
                     e.g. [["http://example5.com", "error"], ["http://t.co/", "http://t.co/"]]
###
exports.expandUrl = (urls, fn) ->
  urls = [urls]  unless urls instanceof Array
  urlsArray  = []
  urls.map (url) ->
    doExpandUrl url, (destUrl, originUrl) ->
      urlsArray.push [destUrl, originUrl]
      if urlsArray.length is urls.length
        fn urlsArray


exports.findProperName = (lang, args...) ->
  inclines = require "./plugins/#{lang}/inclines"
  inclines.findProperName.apply @, args

exports.find = find = (text, lang="ru") ->
  morpho = require "./plugins/#{lang}/morpho"
  inclines = require "./plugins/#{lang}/inclines"
  punctuationRe = /[\.,:\/\\\?!\+\'\"«»\*\(\)\[\]\&\№“”\—]/g
  doubleSpaceRe = /\s+/g

  properNames = []
  curProperName = []
  properNameLang = ""
  resetProperName = ->
    if curProperName && 1 < curProperName.length <= 3
      pn = inclines.findProperName curProperName
      if pn && pn.found
        properNames.push pn# {value: curProperName, lang: properNameLang}
    curProperName = []
    properNameLang = ""

  # add point at the end
  text = text.replace(punctuationRe, " $& ").replace(doubleSpaceRe, " ") + " ."

  for t in text.split " "
    ruRe = /^[а-я\-ё]+$/ig
    enRe = /^[a-z\-]+$/ig
#    wordRe = /^[а-яё\-\da-z]+$/ig

    if /^[а-яё\-]+$/ig.test t # is it russian word?
      r =  morpho.morpho t.toLowerCase()
      if util.isCapitalized(t) && !(r.type in ["adverb", "union", "preposition"])
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
          if (properNameLang is "ru" && ruRe.test t) || (properNameLang is "en" && enRe.test t)
            curProperName.push t
          else                    # save previous result
            resetProperName()
      else
        resetProperName()
    else
      resetProperName()

  pnDict = {}
  for p in properNames
    id = "#{p.first_name || ''}-#{p.middle_name || ''}-#{p.surname}"
    if pnDict[id]
      pnDict[id].count += 1
      unless p.src in pnDict[id].src
        pnDict[id].src.push p.src
    else
      pnDict[id] = p
      pnDict[id].src = [p.src]
      pnDict[id].count = 1
  return pnDict

exports.findInFile = (filename, opts={}) ->
  try
    text = fs.readFileSync filename, "utf8"
  catch e
    return found: no, error: "can't read file '#{filename}'"

  result = find text
  if opts.includeText
    result.text = text
  result

inclineAdjective = (srcWord, adj) ->
  word      = srcWord.toLowerCase()
  notFound  = found: no, src: srcWord

  matchAdjective = (adjective, word, result) ->
    m = word.match adjective.ends
    if m
      len = m[0].length
      wordWithoutEnd   = word[..-(len+1)]
      result.gender    = adjective.gender
      result.singular  = adjective.singular

      if adjective.hard.test word # hard adjective
        result.nominative = "#{wordWithoutEnd}#{adjective.hardNominativeEnd}"
      else
        result.nominative = "#{wordWithoutEnd}#{adjective.softNominativeEnd}"

      result.cases = adjective.incline result.nominative
      result.possible_cases = []
      for adjCase, i in result.cases
        if adjCase is word
          result.possible_cases.push ["nominative", "genitive", "dative", "accusative", "instrumental", "prepositional"][i]
    else
      result.found = no
    result

  for a in [adj.feminine, adj.masculine, adj.neuter, adj.plural]
    result = matchAdjective a, word, src: srcWord, found: yes
    return result if result.found


  notFound

###
Incline bounded words.

We dont know gender and incline of words, plural is not known also.
@param {Array} wordsList Array of words
@param {String} lang Language, depends on plugins language :default "ru",
###
exports.inclineWords = (wordsList, lang="ru") ->
  morpho = require "./plugins/#{lang}/morpho"

  result = {}
  if morpho.getWordRe().test wordsList.join "" # russian
    result = []
    wordsList.map (w) ->
      result.push inclineAdjective w, morpho.getAdjectiveEnds()
  else
    result = error: "can't incline words."
  result


exports.analyseText = analyseText = (text, opts={}, fn=->) ->
  properNames = find text                # find proper names

  properNamesArray = []
  for id, pn of properNames
    pn.src.map (pnSrc) ->
      properNamesArray.push pnSrc unless pnSrc in properNamesArray

  # search regular words and links
  ruRe = /^[а-я\-ё]+$/ig
  enRe = /^[a-z\-]+$/ig
  wordRe = /^[а-яё\-\da-z]+$/ig
  urlRe = /https?:\/\/\S+/g
  if opts.all
    opts =
      useTwitterTags: yes
      searchLinks: yes
      expandLinks: yes
  else
    opts.useTwitterTags  = no if undefined is opts.useTwitterTags
    opts.searchLinks     = no if undefined is opts.searchLinks
    opts.expandLinks     = no if undefined is opts.expandLinks

  if opts.searchLinks
    urls = text.match urlRe
    text = text.replace urlRe, ""
  else
    urls = []

  punctuationRe = /([,:\/\\\?!\+\*\(\)\[\]\&\№\—])/gm
  endOfSentenceRe = /([\?\!])|(\.\s+)/gm
  text = text.replace(punctuationRe, " $& ").replace /\s+/g, " "
  properNamesArray.map (pn) ->
    text = text.replace pn, ""


  # quoted text
  ruQuotesRe = /(\"[-а-яё\d]+(\s[-а-яё\d]+){0,}\")|(\'[-а-яё\d]+(\s[-а-яё\d]+){0,}\')|(«[-а-яё\d]+(\s[-а-яё\d]+){0,}»)|(„[-а-яё\d]+(\s[-а-яё\d]+){0,}\“)/ig
  enQuotesRe = /(\"[-a-z\d]+(\s[-a-z\d]+){0,}\")|(\'[-a-z\d]+(\s[-a-z\d]+){0,}\')/ig
  quotedRe = /(\"[^\"]+\")|(\'[^\']+\')|(«[^»]+»)|(„[^“]“)/mig
  numRe = /((([а-яё]+)\s+){0,1}\d[\.\d]{0,}(\s+(([a-яё]+)|([\.\d]+))){1,6})|([12]\d\d\d)/mig


  ruMatchQuotes = util.unique text.match(ruQuotesRe) || []
  enMatchQuotes = util.unique text.match(enQuotesRe) || []
  numbers = util.unique text.match(numRe) || []

  quotes = []
  for q in util.unique text.match(quotedRe) || []
    quotes.push q unless (q in ruMatchQuotes or q in enMatchQuotes)


  # console.log "\n\nquotes: #{ruMatchQuotes.join '\n'}"
  # console.log "\nquoted: #{quoted.join '\n'}"

  ruDates = util.extractRuDates numbers

  unless /\./.test text
    text += "."

  sentences = []
  prev = ""
  for s, i in (text.split(endOfSentenceRe).filter (s) -> !!s)
    if i % 2 is 1
      sentences.push prev + s
    else
      prev = s

  parsedTextData = util.parseRuSentence sentences
  if util.dictKeys(ruDates.intervals).length > 0
    parsedTextData.date_intervals = util.packIntervals ruDates.intervals
  if util.dictKeys(ruDates.dates).length > 0
    parsedTextData.dates = util.packDates ruDates.dates
  if quotes.length > 0
    parsedTextData.quotes = quotes
  if properNamesArray.length > 0
    parsedTextData.properNames = properNamesArray
  parsedTextData


###
Analyse file content.

@param {String} filename Name of text file
@param {Object} opts Options :default {}, [not used]
@return {Object} parsedData Result of analysis.
###
exports.analyseFile = analyseFile = (filename, opts) ->
  try
    text = fs.readFileSync filename, "utf8"
  catch e
    return found: no, error: "can't read file '#{filename}'"
  analyseText text, opts

  # twitter
  # todo analyse text by splitting words, searching lunks etc.

