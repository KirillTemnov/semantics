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
    abbrevsRe = /([А-Я][А-Я\d]+(\s+[А-Я\d]{2,}){0,5})|([A-Z][A-Z\d\-]+(\s+[A-Z\d\-]+){0,5})/gm
    text.match(abbrevsRe) || []

  ###
  Extract abbrevs words.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain field:
                 ru.abbrevs  : Dict of russian/english abbrev words and count of occurrences
  ###
  exports.preFilter = (text, result) ->
    result.ru   ||={}
    result.ru.abbrevs = util.arrayToDict extractAbbr text

)(exports, util)