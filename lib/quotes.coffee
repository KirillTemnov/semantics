###
Extract quoted content.
###

if "undefined" is typeof global
    window.semantics                  ||= {}
    window.semantics.quotes           ||= {}
    exports                            = window.semantics.quotes
    util                               = window.semantics.util
else
    exports                            = module.exports
    util                               = require "./util"

((exports, util) ->

  ###
  Get quotes from text.

  @param {String} text Source text
  @return {Array} result Array of quoted strings, may be empty.
  ###
  exports.getQuotes = getQuotes = (text) ->
    quotedRe       = /(\"[^\"]+\")|(\'[^\']+\')|(«[^»]+»)|(„[^“]“)/mig
    text.match(quotedRe) || []

  ###
  Extract quotes and quoted text from source text.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain:
                 quotes     : Array of quotes in text
  ###
  exports.preFilter = (text, result) ->
    result.quotes   = util.arrayToDict getQuotes text

)(exports, util)
