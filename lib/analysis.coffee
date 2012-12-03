###
Analysis module.
###

if "undefined" is typeof global
    window.semantics          ||= {}
    window.semantics.analysis ||= {}
    exports                    = window.semantics.analysis
else
    exports                    = module.exports


((exports) ->
  ###
  Analyse text by applying specified filters.

  @param {String} text Source text
  @param {Array} plugins Array of filter plugins
  @param {Object} result Resulting object
  @param {Object} opts Options for plugins
          `opts.mergeHyphens`  - merge hypen words, default: false
          `opts.wordsToLower`  - all words to lower case, default: false
  @return {Object} result Result, depends on plugins set
  ###
  exports.analyse = (text, plugins=[], options={}) ->
    if "undefined" is typeof global
      misc = window.semantics.misc
      util = window.semantics.util
    else
      misc = require "./misc"
      util = require "./util"

    time = Date.now()

    if options.mergeHyphens
      noHypens = []
      words =  text.replace(/\s+/g, " ").split " "
      prevWord = words.shift()
      for w in words
        if "-" is prevWord[prevWord.length-1]
          noHypens.push "#{prevWord[0...-1]}#{w}"
          prevWord = ""
          continue
        else if prevWord
          noHypens.push prevWord
        prevWord = w
      if prevWord
        noHypens.push prevWord
      text = noHypens.join " "

    result = {}
    misc.preFilter text, result, options
    preFilters = plugins.filter (plugin) -> "function" is typeof plugin.preFilter
    postFilter = plugins.filter (plugin) -> "function" is typeof plugin.postFilter

    for f in preFilters
      f.preFilter text, result, options

    for f in postFilter
      f.postFilter text, result, options

    result.version = util.version
    result.time    = Date.now() - time
    result


  exports.applyFormula = (formulaTxt, scores) ->
    signsRe     = /[-\+=\/\*]/g
    formulaTxt  = formulaTxt.replace(signsRe, " $& ").replace(/[\(\)]/g, " $& ").replace(/\s+/, " ")
    errors      = no
    vars        = []
    for wrd in (formulaTxt.split(" ").filter (w) -> !!w)
      if (wrd in "()-+/*") or (/^\d+(\.\d+){0,}$/g.test wrd) # operator or number
        continue
      else if "undefined" isnt typeof scores[wrd]
        vars.push wrd
        continue
      else
        errors = yes
        console.log "error on '#{wrd}'"
    unless errors
      for wrd in vars
        formulaTxt = formulaTxt.replace(wrd, scores[wrd])
      result = eval formulaTxt
    else
      result = "Error"

    result



  ###
  Analyse tweet and execute scores:

  ###
  exports.twitterScores = (text, plugins, options) ->
    if "undefined" is typeof global
      twitter  = window.semantics.plugins.ru.twitter
      util     = window.semantics.util
    else
      twitter  = require "./plugins/ru/twitter"
      util     = require "./util"


    r = exports.analyse(text, plugins, options)

    cc    : r.counters.chars_total
    wc    : r.counters.words_total
    sc    : r.misc.sentences.length
    wmid  : r.counters.word_length_mid.toFixed 3
    smid  : r.counters.words_in_sentence_mid.toFixed 3
    rwc   : util.sumValues r.ru.reg_words
    swc   : r.counters.stop_words_total
    swp   : r.counters.stop_words_persent.toFixed 3
    refc  : util.dictKeys(r.twitter.pos.urls).length
    ref0p : util.dictMinValue r.twitter.pos.urls, 0
    ref$p : util.dictMaxValue r.twitter.pos.urls, 0
    mimic : util.dictKeys(r.mimimi).length
    emoc  : util.sumValues r.misc.emoticons
    qc    : r.quotes.length
    q2wc  : (r.meaning.collocations.filter (z) -> z.length is 2).length
    q3wc  : (r.meaning.collocations.filter (z) -> z.length is 3).length
    q4wc  : (r.meaning.collocations.filter (z) -> z.length is 4).length
    q5wc  : (r.meaning.collocations.filter (z) -> z.length is 5).length
    qdc   : util.sumValues r.misc.digits
    hc    : util.sumValues r.misc.hashtags
    h0p   : util.dictMinValue r.twitter.pos.hash_tags
    h$p   : util.dictMaxValue r.twitter.pos.hash_tags
    mc    : util.sumValues r.misc.mentions
    m0p   : util.dictMinValue r.twitter.pos.mentions
    m$p   : util.dictMaxValue r.twitter.pos.mentions
    kwc   : util.sumValues r.twitter.key_words
    kw0p  : util.dictMinValue r.twitter.pos.kw
    kw$p  : util.dictMaxValue r.twitter.pos.kw
    udwc  : util.sumValues r.twitter.pos.user_defined_words
    udw0p : util.dictMinValue r.twitter.pos.user_defined_words
    udw$p : util.dictMaxValue r.twitter.pos.user_defined_words
    qm    : 0
    em    : 0
    geox  : 0
    geoy  : 0
    favc  : 0
    rtc   : 0

)(exports)


