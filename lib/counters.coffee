###
Counters (universal) plugin.
###

if "undefined" is typeof global
    window.lastName ||= {}
    window.lastName.counters ||= {}
    exports = window.lastName.counters
else
    exports = module.exports

((exports) ->

  ###
  Calculate text metrics: nubers of chars, words total, extract numbers and smiles from text.

  @param {String} text Source text
  @param {Object} result Resulting object, that may contain `chars_total`, `words_total`
                         and `signs_total` fields after applying this filter.
  ###
  exports.preFilter = (text, result) ->
    signs = text.match /[-\+=\/\.\!\?\@\#\$\%\^\&\*\(\)\[\]\{\}\<\>\`\~\"\':;\|\\_]{1}/g
    result.counters =
      chars_total: text.length
      words_total: (text.split(/\s/).filter (wrd) ->
         wrd.length > 0 and not /^[-\+=\/\.\!\?\@\#\$\%\^\&\*\(\)\[\]\{\}\<\>\`\~\"\':;\|\\_]+$/.test wrd).length
      signs_total: signs and signs.length or 0
    result
)(exports)