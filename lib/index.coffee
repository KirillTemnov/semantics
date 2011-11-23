###
Module provide api for library
###

util              = require "./util"
exports.version   = util.version
analysis          = require "./analysis"
fs                = require "fs"
exec              = require('child_process').exec


###
Expand single url via curl

@param {String} url Url to expand
@param {Function} fn Callback function, accept 1) examined url, 2) source url.
                     in case of timeout or other errors, "error" will return
                     as second prameter.
###
doExpandUrl = (url, fn) ->
  lastLocation = url
  exec "curl --connect-timeout 5 -IL #{url}", (error, stdout) ->
    m = stdout.match /^Location\:\s+(https?:\/\/\S+)*$/mig
    if m
      lastLocation = m[-1..][0].match(/https?:\/\/\S+/).toString()
    if error
      lastLocation = "error"
    fn url, lastLocation


###
Expand array of urls or single url.

@param {Array|String} urls Single url to expand or array of urls
@param {Function} fn Callback function, accept 1) array or resulst.
                     each result consists of array [source, dest].
                     where dest may be "error" or destignation url.
                     e.g. [["http://example5.com", "error"], ["http://t.co/", "http://t.co/"]]
###
exports.expandUrl = (urls, fn) ->
  urls = [urls]  unless urls instanceof Array
  urlsArray  = []
  urls.map (url) ->
    doExpandUrl url, (destUrl, originUrl) ->
      urlsArray.push [destUrl, originUrl]
      if urlsArray.length is urls.length
        fn urlsArray


###
Incline adjective word

@param {String} src Source word
@param {Object} adj Adjective object, @see plugins.ru.morpho module
@return {Object} result Incline result, field `found` set to true on success
###
inclineAdjective = (srcWord, adj) ->
  word      = srcWord.toLowerCase()
  notFound  = found: no, src: srcWord

  matchAdjective = (adjective, word, result) ->
    m = word.match adjective.ends
    if m
      len = m[0].length
      wordWithoutEnd   = word[..-(len+1)]
      result.gender    = adjective.gender
      result.singular  = adjective.singular

      if adjective.hard.test word # hard adjective
        result.nominative = "#{wordWithoutEnd}#{adjective.hardNominativeEnd}"
      else
        result.nominative = "#{wordWithoutEnd}#{adjective.softNominativeEnd}"

      result.cases = adjective.incline result.nominative
      result.possible_cases = []
      for adjCase, i in result.cases
        if adjCase is word
          result.possible_cases.push ["nominative", "genitive", "dative", "accusative", "instrumental", "prepositional"][i]
    else
      result.found = no
    result

  for a in [adj.feminine, adj.masculine, adj.neuter, adj.plural]
    result = matchAdjective a, word, src: srcWord, found: yes
    return result if result.found


  notFound

###
Incline bounded words.

We dont know gender and incline of words, plural is not known also.
@param {Array} wordsList Array of words
@param {String} lang Language, depends on plugins language :default "ru",
###
exports.inclineWords = (wordsList, lang="ru") ->
  morpho = require "./plugins/#{lang}/morpho"

  result = {}
  if morpho.getWordRe().test wordsList.join "" # russian
    result = []
    wordsList.map (w) ->
      result.push inclineAdjective w, morpho.getAdjectiveEnds()
  else
    result = error: "can't incline words."
  result

###
Analyse text and return result as json object.

@param {String} test Source text
@param {Object} opts Plugin options.
                opts.all     : if set to true, enable all default plugins
                opts.plugins : array of plugins. If plugin type is string,
                               try to load it from current location, otherwise
                               just add it to applied plugins.
@return {Object} obj Fields of returned object depends on applied plugins
###
exports.analyseText = analyseText = (text, opts={}) ->
  if opts.all
    pluginsArray = ["plugins.ru.feelings"]
  else
    pluginsArray = opts.plugins || []

  plugins = []
  pluginsArray.map (plg) ->
    if "string" is typeof plg
      plugins.push require "./#{plg.replace /\./g, '/'}"
    else
      plugins.push plg
  return analysis.analyse text, plugins


###
Analyse file content.

@param {String} filename Name of text file
@param {Object} opts Options :default {}, [not used]
@return {Object} parsedData Result of analysis.
###
exports.analyseFile = analyseFile = (filename, opts) ->
  try
    text = fs.readFileSync filename, "utf8"
  catch e
    return found: no, error: "can't read file '#{filename}'"
  analyseText text, opts

