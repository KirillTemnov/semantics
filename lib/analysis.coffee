###
Analysis module.
###

if "undefined" is typeof global
    window.lastName ||= {}
    window.lastName.analysis ||= {}
    exports = window.lastName.analysis
else
    exports = module.exports

((exports) ->
  ###
  Analyse text by applying specified filters.

  @param {String} text Source text
  @param {Array} plugins Array of filter plugins
  @param {Object} result Resulting object
  ###
  exports.analyse = (text, plugins=[]) ->
    result = {}
    preFilters = plugins.filter (plugin) -> "function" is typeof plugin.preFilter
    postFilter = plugins.filter (plugin) -> "function" is typeof plugin.postFilter

    for f in preFilters
      f.preFilter text, result

    for f in postFilter
      f.postFilter text, result

    result

)(exports)