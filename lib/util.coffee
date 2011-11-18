ref               = require "./ref"
morpho            = require "./morpho"
getAdjectiveEnds  = morpho.getAdjectiveEnds
morphoRu          = morpho.morphoRu

sys               = require "util"

###
DateObject reference:
    d:                             # date, Number
    m:                             # month, Number
    y:                             # year, Number, :optional

String representation:
dd.mm.[yyyy]

------------------------------
Interval - diapazone of dates

Interval dict object reference:
  from:                         # string representation of from_value
  from_value:                   # Date object
  to:                           # string representation of to_value
  to_value:                     # Date object
  count:                        # times appeared

String representation:
dd.mm.[yyyy]-dd.mm.[yyyy]
or
dd.mm.??[yyyy[, yyyy...]]-dd.mm.??[yyyy[, yyyy...]]
###

###
Capitalize word.

@param {String} s Source word
@return  {String} result Capitalized word
###
exports.capitalize = capitalize = (s) ->
  if s
    "#{s[0].toUpperCase()}#{s[1..].toLowerCase()}"


###
Get keys from dictionary.

@param {Object} dict Dictonary object
@return {Array} result Array of keys
###
exports.dictKeys = dictKeys = (dict) ->
  keys = []
  keys.push k for k,v of dict
  keys


###
Check if word capitalized. Word can contain several words, like "Петров-Водкин"

@param {String} s Source word
@return {Boolean} result Return true if word capitalized
###
exports.isCapitalized = isCapitalized = (word) ->
  if 0 <= word.indexOf "-"
    cap = yes
    word.split("-").map (wrd) -> cap &&= isCapitalized wrd
    cap
  else
    word &&  word is capitalize(word) || no

###
Check if word in upper case.

@param {String} word Word for check
@param {Boolean} result
###
exports.isUpperCase = isUpperCase = (word) ->  word is word.toUpperCase()


###
Check if word in lower case.

@param {String} word Word for check
@param {Boolean} result
###
exports.isLowerCase = isLowerCase = (word) ->  word is word.toLowerCase()

###
Remove duplicates from array.

@param {Array} array Array that may contain duplicates
@param {Array} newArray New array without duplicates
###
exports.unique = unique = (array) ->
  output = {}
  output[array[key]] = array[key] for key in [0...array.length]
  value for key, value of output


###
Merge two arrays.

@param {Array} arr1 First array
@param {Array} arr2 Seconds array
@return {Array} arr Array contain unique values from arr1 and arr2
###
exports.merge = merge = (l1, l2) ->
  l = []
  l1.map (x) -> l.push x
  l2.map (x) -> l.push x
  unique l

###
Get first intersection of two arrays.

@param {Array} arr1 First array
@param {Array} arr2 Seconds array
@return {Object|null} elem First element, that appear in arr1 and arr2
###
exports.intersection = intersection = (l1, l2) ->
  for i in l1
    return i if i in l2
  null



###
Date object to string.

@param {DateObject} dateObj Date object.
@param {String} dateStr DateStr, @see string representation on top.
###
dateObjectToString = (dateObj) ->
  y = (typeof dateObj.y in ["number", "string"]) and  dateObj.y or ""
  m = dateObj.m + 1
  m = m > 9 and m or "0#{m}"
  d = dateObj.d > 9 and dateObj.d or "0#{dateObj.d}"
  "#{d}.#{m}.#{y}"

###
Get valid date or null.

@param {DateObject} dateObj
@param {DateObject|null} result Date object or null for invalifd date.
###
getValidDate = (dateObj) ->
  defaultYear = dateObj.y
  if undefined == dateObj.y or dateObj.y < 1970 or dateObj.y > 2038
    dateObj.y = 2000

  dt = new Date Date.UTC dateObj.y, dateObj.m, dateObj.d
  if (dt.getMonth() is dateObj.m) && (dt.getDate() is dateObj.d)
    dateObj.y = defaultYear
    return dateObj
#  else if dateObj.d is 29 and dateObj.m is 1
  else
    return null

###
Extract month number from russian name.

@param {String} str Rusian name of month in GENETIVE case.
@return {Number} num Number of month, e.g. 0 - jan, 1 - feb, ect.
###
getRuMonthIndex = (str) ->
  m = str.toLowerCase().match /(\s|^)(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)(\s|$)/g
  if m
    ref.ruMonthInDates.indexOf m[0].replace /\s/g, ""
  else
    -1

###
Search russian dates (and intervals of dates) in strings.

Date patterns:

DD.MM.YYYY
DD.MM.YY

DD.MM

DD month YYYY
DD month

Date intervals pattern:

DD [month [year [года]]] по DD month [year]

@param {String|Array} strArr Source string or array of strings.
@param {Object} resultObject Result object contain sources (for source strings)
                             and valid dates.
###
exports.extractRuDates = (strArr) ->
  dates = {}
  sources = []
  intervals = {}
  strArr = [strArr] unless strArr instanceof Array
  strArr.map (str) ->
    # lookup date interval first
    verboseMatch = str.match /\s+\d{1,2}\s+((января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)\s+|)(\d{2,4}(\s+года|)\s+|)по\s+\d{1,2}\s+(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)(\s+\d{2,4}|)(\s+|$)/mig
    if verboseMatch
      [from, to] = verboseMatch[0].toLowerCase().split "по"
      toYear = to.replace(/\d{1,2}/, "").match(/\d+/g)
      if toYear
        toYear = parseInt toYear[0], 10
      else
        toYear = undefined
      toDate =
        d: parseInt to.match(/\d{1,2}/g)[0], 10
        m: getRuMonthIndex to
        y: toYear

      fromYear   = from.replace(/\d{1,2}/, "").match(/\d+/g)
      fromMonth  = getRuMonthIndex from
      if fromYear
        fromYear = parseInt fromYear[0], 10
      else
        fromYear = toYear
      if fromMonth is -1
        fromMonth = toDate.m
      fromDate =
        d: parseInt from.match(/\d{1,2}/g)[0], 10
        m: fromMonth
        y: fromYear

      toDate    = getValidDate toDate
      fromDate  = getValidDate fromDate
      if toDate and fromDate
        intObject =
          from: dateObjectToString fromDate
          from_value: fromDate
          to: dateObjectToString toDate
          to_value: toDate
        id = "#{intObject.from}-#{intObject.to}"
        unless intervals[id]
          intObject.count  = 1
          intervals[id]    = intObject
        else
          intervals[id].count++

        sources.push verboseMatch[0]
    else
      wordsArr = str.split " "
      found = no
      while wordsArr.length > 0 and not found
        if /^\d[\d]$/.test wordsArr[0]
          mIndex = ref.ruMonthInDates.indexOf wordsArr[1].toLowerCase()
          if mIndex >= 0
            date =
              d: parseInt wordsArr[0], 10
              m: mIndex
            # check year
            if /^\d{2,4}$/.test wordsArr[2]
              date.y     = parseInt wordsArr[2], 10
              sourceStr  = wordsArr[0..2].join " "
            else
              sourceStr =  wordsArr[0..1].join " "
          else if /^\d\d\.\d\d.\d{2,4}$/.test wordsArr[0] or  /^\d\d\.\d\d$/.test wordsArr[0]
            date =
              d: parseInt wordsArr[0][0..2], 10
              m: parseInt wordsArr[0][3..5], 10
              y: parseInt(wordsArr[0][6..], 10) or undefined

            sourceStr = wordsArr[0]
          else
            date = {}

          date = getValidDate date
          if date
            found = yes
            sources.push sourceStr
            dStr = dateObjectToString date
            unless dates[dStr]
              dates[dStr] =
                count: 1
                value: date
            else
              dates[dStr].count++

        wordsArr.shift()

  dates: dates, sources: sources, intervals: intervals


###
Pack dates dict to compact representation.

@param {DateObjectsDict} intervals Dates dictionary, @see top of module
@param {Number|null} defaultYear Default year, :optional null
                                 if default year not set, we try to guess
                                 it by looking at all passed dates (years).
@return {Object} result Packed dictionary
###
exports.packDates = (dates, defaultYear=null) ->
  out = {}
  if defaultYear is null
    years = []
    for id, dateObj of dates
      unless "undefined" is typeof dateObj.value.y
        years.push dateObj.value.y
    years = unique years.sort()
    if years.length > 1         #
      defaultYear = "????[#{years.join ','}]"
    else if years.length is 1
      defaultYear = years[0]
    else
      defaultYear = "????"
  for id, dateObj of dates
    if "undefined" is typeof dateObj.value.y
      dateObj.value.y = defaultYear
    out["#{dateObjectToString dateObj.value}"] = dateObj.count
  out
  console.log "out = #{sys.inspect out}"

###
Pack intervals dict to compact representation.

@param {IntervalObjectDict} intervals Intervals dictionary, @see top of module
@param {Number|null} defaultYear Default year, :optional null
                                 if default year not set, we try to guess
                                 it by looking at all passed dates (years).
@return {Object} result Packed dictionary
###
exports.packIntervals = (intervals, defaultYear=null) ->
  out = {}
  if defaultYear is null
    years = []
    for id, interval of intervals
      unless "undefined" is typeof interval.from_value.y
        years.push interval.from_value.y
      unless "undefined" is typeof interval.to_value.y
        years.push interval.to_value.y
    years = unique years.sort()
    if years.length > 1         #
      defaultYear = "????[#{years.join ','}]"
    else if years.length is 1
      defaultYear = years[0]
    else
      defaultYear = "????"
  for id, interval of intervals
    if "undefined" is typeof interval.from_value.y
      interval.from_value.y = defaultYear
    if "undefined" is typeof interval.to_value.y
      interval.to_value.y = defaultYear
    out["#{dateObjectToString interval.from_value}-#{dateObjectToString interval.to_value}"] = interval.count
  out


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
  sentences.map (sent) ->
    words = sent.split " "
    for word, i in words
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



      else if /^[а-яё\-]+$/i.test word
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
