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
  @param {Object} opts Options for plugins
  @return {Object} result Result, depends on plugins set
  ###
  exports.analyse = (text, plugins=[], options={}) ->
    if "undefined" is typeof global
      misc = window.lastName.misc
      util = window.lastName.util
    else
      misc = require "./misc"
      util = require "./util"

    result = {}
    misc.preFilter text, result
    preFilters = plugins.filter (plugin) -> "function" is typeof plugin.preFilter
    postFilter = plugins.filter (plugin) -> "function" is typeof plugin.postFilter

    for f in preFilters
      f.preFilter text, result, options

    for f in postFilter
      f.postFilter text, result, options

    result.version = util.version
    result

)(exports)
