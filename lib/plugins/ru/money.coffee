#
# Module for extracting money values
#

if "undefined" is typeof global
    window.semantics.plugins.ru.abbrevs  = {}
    exports                           = window.semantics.plugins.ru.abbrevs
    util                              = window.semantics.util
else
    exports                           = module.exports
    util                              = require "../../util"


((exports, util) ->

  #
  # Extract money from sentences
  # and return list of abbrevs (may contein duplicates).
  # 
  # @param {String} text   Source text
  # @return {Array} result Array of money objects
  #
  exports.extract = extractMoney = (text) ->
    moneyRe = /[\d\s]+(тыс\.?|млн\.?|млрд\.?|тыс[ячиа]+|миллио[наов]+|миллиар[даов]+|)\s+(ру[бляей]+|евро|долла[раов]+)/mg
    moneys = (text.match(moneyRe) || []).map (x) -> x.trim()
    moneys


  #
  # Extract money values
  #
  # @param {String} text Source text
  # @param {Object} result Resulting object, that contain field:
  #               ru.abbrevs  : Dict of russian/english abbrev words and count of occurrences
  #
  exports.preFilter = (text, result) ->
    result.ru       ||={}
    result.ru.money   =  extractMoney text

)(exports, util)
