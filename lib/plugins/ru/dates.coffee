###
Parse text and find russian dates

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


if "undefined" is typeof global
    window.semantics.plugins         ||= {}
    window.semantics.plugins.ru      ||= {}
    window.semantics.plugins.ru.dates  = {}
    exports                           = window.semantics.plugins.ru.dates
    ref                               = window.semantics.plugins.ru.ref
    util                              = window.semantics.util
else
    exports                           = module.exports
    ref                               = require "./ref"
    util                              = require "../../util"


((exports, util, ref) ->

  ruMonthInDates = ["января", "февраля", "марта", "аперля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"]


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
    if undefined is dateObj.y or dateObj.y < 1970 or dateObj.y > 2038
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

  @param {String} str Russian name of month in GENETIVE case.
  @return {Number} num Number of month, e.g. 0 - jan, 1 - feb, ect.
  ###
  getRuMonthIndex = (str) ->
    m = str.toLowerCase().match /(\s|^)(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)(\s|$)/g
    if m
      ruMonthInDates.indexOf m[0].replace /\s/g, ""
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
  exports.extractDates = extractDates = (strArr) ->
    dates      = {}
    sources    = []
    intervals  = {}
    strArr     = [strArr] unless strArr instanceof Array
    strArr.map (str) ->
      # lookup date interval first
      # verboseMatch = str.match /\s+\d{1,2}\s+((января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)\s+|)(\d{2,4}(\s+(года|г\.|г|))\s+|)(|по\s+\d{1,2}\s+(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)(\s+\d{2,4}|)(\s+|$))/mig
      verboseMatch = str.match /\s+\d{1,2}\s+((января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)\s+|)(\d{2,4}(\s+года|)\s+|)по\s+\d{1,2}\s+(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)(\s+\d{2,4}|)(\s+|$)/mig
      digitalDate = str.match /(^|\s+)\d\d?\.\d\d?\.\d{2,4}(\.|\s|$)/mig
      singleDate = str.match /\s+\d{1,2}\s+(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)\s+\d{2,4}[\s\.,!\?]/mig
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
            from       : dateObjectToString fromDate
            from_value : fromDate
            to         : dateObjectToString toDate
            to_value   : toDate
          id = "#{intObject.from}-#{intObject.to}"
          unless intervals[id]
            intObject.count  = 1
            intervals[id]    = intObject
          else
            intervals[id].count++

          sources.push verboseMatch[0]

      if singleDate
        for sd in singleDate
          sd = sd.replace(/\s+/g, " ").trim()
          splittedDate = sd.split " "
          mIndex = ruMonthInDates.indexOf splittedDate[1].toLowerCase()
          continue if -1 is mIndex
          date =
            d: parseInt splittedDate[0]
            m: mIndex
            y: parseInt splittedDate[2]
          # check year
          date = getValidDate date
          if date
            sources.push sd
            dStr = dateObjectToString date
            unless dates[dStr]
              dates[dStr] =
                count: 1
                value: date
            else
              dates[dStr].count++
      
      if digitalDate
        for dd in digitalDate
          [d, m, y] = dd.split(".").map (x) -> parseInt x
          y += 2000 if y < 99
          m--
          date = getValidDate d:d, m:m, y:y
          if date
            sources.push dd
            dStr = dateObjectToString date
            unless dates[dStr]
              dates[dStr] =
                count: 1
                value: date
            else
              dates[dStr].count++
          

    dates: dates, sources: sources, intervals: intervals


  ###
  Pack dates dict to compact representation.

  @param {DateObjectsDict} intervals Dates dictionary, @see top of module
  @param {Number|null} defaultYear Default year, :optional null
                                   if default year not set, we try to guess
                                   it by looking at all passed dates (years).
  @return {Object} result Packed dictionary
  ###
  exports.packDates = packDates = (dates, defaultYear=null) ->
    out = {}
    if defaultYear is null
      years = []
      for id, dateObj of dates
        unless "undefined" is typeof dateObj.value.y
          years.push dateObj.value.y
      years = util.unique years.sort()
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

  ###
  Pack intervals dict to compact representation.

  @param {IntervalObjectDict} intervals Intervals dictionary, @see top of module
  @param {Number|null} defaultYear Default year, :optional null
                                   if default year not set, we try to guess
                                   it by looking at all passed dates (years).
  @return {Object} result Packed dictionary
  ###
  exports.packIntervals = packIntervals = (intervals, defaultYear=null) ->
    out = {}
    if defaultYear is null
      years = []
      for id, interval of intervals
        unless "undefined" is typeof interval.from_value.y
          years.push interval.from_value.y
        unless "undefined" is typeof interval.to_value.y
          years.push interval.to_value.y
      years = util.unique years.sort()
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
  Filter before text processings. Extract russian dates from text.

  @param {String} text Source text
  @param {Object} result Resulting object, that may contain `dates` and `intervals`
                         fields after applying this filter.
  ###
  exports.preFilter = (text, result) ->
    numRe = /((([а-яё]+)\s+){0,1}\d[\.\d]{0,}(\s+(([a-яё]+)|([\.\d]+))){1,6})|([12]\d\d\d)/mig
    dates = extractDates util.unique text.match(numRe) || []
    if util.dictKeys(dates.dates).length > 0
      result.dates = packDates dates.dates
    if util.dictKeys(dates.intervals).length > 0
      result.intervals = packIntervals dates.intervals
    if dates.sources.length > 0
      result.date_sources = dates.sources

)(exports, util, ref)
