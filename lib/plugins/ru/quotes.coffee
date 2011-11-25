###
Extract quoted content.

###


if "undefined" is typeof global
    window.lastName                  ||= {}
    window.lastName.plugins          ||= {}
    window.lastName.plugins.ru       ||= {}
    window.lastName.plugins.ru.quotes  = {}
    exports                            = window.lastName.plugins.ru.quotes
    util                               = window.lastName.util
else
    exports                            = module.exports
    util                               = require "../../util"

((exports, util) ->

  ###
  Extract quotes and quoted text from source text.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain:
                 quotes     : Array of quotes in text
  ###
  exports.preFilter = (text, result) ->
    # quoted text
    ruQuotesRe = /(\"[-а-яё\d]+(\s[-а-яё\d]+){0,}\")|(\'[-а-яё\d]+(\s[-а-яё\d]+){0,}\')|(«[-а-яё\d]+(\s[-а-яё\d]+){0,}»)|(„[-а-яё\d]+(\s[-а-яё\d]+){0,}\“)/ig
    enQuotesRe = /(\"[-a-z\d]+(\s[-a-z\d]+){0,}\")|(\'[-a-z\d]+(\s[-a-z\d]+){0,}\')/ig
    quotedRe = /(\"[^\"]+\")|(\'[^\']+\')|(«[^»]+»)|(„[^“]“)/mig

    ruMatchQuotes = util.unique text.match(ruQuotesRe) || []
    enMatchQuotes = util.unique text.match(enQuotesRe) || []

    quotes = []
    for q in util.unique text.match(quotedRe) || []
      quotes.push q unless (q in ruMatchQuotes or q in enMatchQuotes)

    result.quotes = quotes

)(exports, util)