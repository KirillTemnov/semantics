ref = require "./ref"
sys = require "util"

###
DateObject reference:
    d:                             # date, Number
    m:                             # month, Number
    y:                             # year, Number, :optional

String representation:
dd.mm.[yyyy]
###


###
Date object to string.

@param {DateObject} dateObj Date object.
@param {String} dateStr DateStr, @see string representation on top.
###
dateObjectToString = (dateObj) ->
  y = ("number" is typeof dateObj.y) and  dateObj.y or ""
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


