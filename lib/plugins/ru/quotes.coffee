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
  Get quotes from text.

  @param {String} text Source text
  @return {Array} result Array of quoted strings, may be empty.
  ###
  exports.getQuotes = getQuotes = (text) ->
    # quoted text
    ruQuotesRe     = /(\"\s{0,}[-а-яё\d]+(\s[-а-яё\d]+){0,}\s{0,}\")|(\'\s{0,}[-а-яё\d]+(\s[-а-яё\d]+){0,}\s{0,}\')|(«\s{0,}[-а-яё\d]+(\s[-а-яё\d]+){0,}\s{0,}»)|(„\s{0,}[-а-яё\d]+(\s[-а-яё\d]+){0,}\s{0,}\“)/ig
    enQuotesRe     = /(\"\s{0,}[-a-z\d]+(\s[-a-z\d]+){0,}\s{0,}\")|(\'\s{0,}[-a-z\d]+(\s[-a-z\d]+){0,}\s{0,}\')/ig
    quotedRe       = /(\"[^\"]+\")|(\'[^\']+\')|(«[^»]+»)|(„[^“]“)/mig

    ruMatchQuotes  = util.unique text.match(ruQuotesRe) || []
    enMatchQuotes  = util.unique text.match(enQuotesRe) || []

    quotes         = []
    for q in util.unique text.match(quotedRe) || []
      quotes.push q if (q in ruMatchQuotes or q in enMatchQuotes)
    quotes

  ###
  Extract quotes and quoted text from source text.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain:
                 quotes     : Array of quotes in text
  ###
  exports.preFilter = (text, result) ->
    result.quotes   = getQuotes text

)(exports, util)