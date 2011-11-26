###
Module for extracting russian (and english) abbrevs.

###

if "undefined" is typeof global
    window.lastName.plugins.ru.abbrevs  = {}
    exports                           = window.lastName.plugins.ru.abbrevs
    util                              = window.lastName.util
else
    exports                           = module.exports
    util                              = require "../../util"


((exports, util) ->

  ###
  Extract abbrevs from text and return list of abbrevs (may contein duplicates).

  @param {String} text Source text
  @return {Array} result Array of abbrevs
  ###
  exports.extract = extractAbbr = (text) ->
    abbrevsRe = /([А-Я\d]{2,}(\s+[А-Я\d]{2,}){0,5})|([A-Z\d][A-Z\d\-\!]+(\s+[A-Z\d\-\!]+){0,5})/gm
    text.match(abbrevsRe) || []

  ###
  Extract abbrews words.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain fields:
                 ru.      : Dict of russian words and count of occurrences for each
                 ru.reg_words  : Dict of russian immutable words and count of occurrences
                 ru.stop_words : Dict of russian stop words and count of occurrences
  ###
  exports.preFilter = (text, result) ->
    result.ru   ||={}
    result.ru.abbrevs = util.arrayToDict extractAbbr text

)(exports, util)