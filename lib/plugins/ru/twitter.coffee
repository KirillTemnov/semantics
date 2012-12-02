###
Plugin make deal with twitter-special markup.

depends on misc
###

if "undefined" is typeof global
    window.semantics.plugins.ru.twitter   = {}
    exports                              = window.semantics.plugins.ru.twitter
    util                                 = window.semantics.util
    mimimi                               = window.semantics.mimimi
else
    exports                              = module.exports
    util                                 = require "../../util"
    mimimi                               = require "../../mimimi"

((exports, util, mimimi) ->
  exports.getKeyWordsRe = getKeyWordsRe = ->
    /(^|\s)(BG|BFN|BR|BTW|DM|EM|FB|FU|FTF|FWIW|Gr8|IMO|IMHO|IRL|LI|LMK|LMBO|LMAO|LOL|NP|MD|OMG|OMFG|PLZ|ROFL|RT|RTHX|TMB|TMI|TTYS|TTYL|TY|WTH|WTF|YW|via|\<3|уг|хз|мб|пнх)(\s|$)/mig

  ###
  Split harder, than regular text.

  @param {String} text Sentence text
  @return {Array} result Sentence splitted by words
  ###
  splitHard = (text, nosplit=[]) ->
    words = []
    for w in text.replace(/([a-zа-яё\d])([-,:+\@])(\s|$)/mig, "$1 $2 ").split /\s/
      continue unless w
      if w in nosplit
        words.push w
      else if /\S{0,}[a-zа-яё][-\.,?!:\/\\][a-zа-яё]\S{0,}/i.test w
        w.replace(/[-\.,?!:\/\\]/g, " $& ").split(" ").map (sw) -> words.push sw
      else
        words.push w

    finalWords = []             # split CamelCases words
    words.map (w) ->
      if w
        sresult = mimimi.search w
        if sresult.mixed_words.length > 1 and /^[а-яёa-z]+$/i.test w
          sresult.mixed_words.map (mw) -> finalWords.push mw
        else                      # todo check for single signs
          finalWords.push w

    words       = finalWords
    finalWords  = []
    # merge smiles
    prevWordsS = ""
    for w in words
      if /^[-;:\<\>\[\]\(\)!\?=\@\+\%~]{1,}$/.test w
        prevWordsS += w
      else if prevWordsS
        finalWords.push prevWordsS
        finalWords.push w
        prevWordsS = ""
      else
        finalWords.push w

    finalWords

  ###
  Apply twitter filter to result.

  @param {String} text Source text ( not used)
  @param {Object} result Resulting object, that contain `twitter`
                         field after applying this filter.
                  result.twitter.key_words  : Dict of key words
  @param {Object} opts Options, :default {}
                  opts.user_defined_words : array of predefined words, :optional []

  ###
  exports.preFilter = (text, result, opts={}) ->
    sentences = []
    keyWords  = []
    allWords  = []
    #  util.merge util.dictKeys(result.misc.emoticons) || {}
    nosplit   = util.dictKeys result.misc.urls || {}
    for s in result.misc.sentences
      wordsArray = splitHard(s, nosplit)
      wordsArray.map (w) ->
        unless w in ".,:\/\\?!+\'\"«»*()[]&|№“”—"
          allWords.push w
      sent = wordsArray.join " "
      (sent.match(getKeyWordsRe()) || []).map (w) -> keyWords.push w.trim()
      sentences.push sent


    result.misc.sentences     = sentences
    result.twitter            = {}
    result.twitter.key_words  = util.arrayToDict keyWords

    positions = urls: {}, hash_tags: {}, mentions: {}, kw: {}, user_defined_words: {}
    urls         = util.dictKeys result.misc.urls
    hashTags     = util.dictKeys result.misc.hashtags
    mentions     = util.dictKeys result.misc.mentions
    kw           = util.unique keyWords
    customWords  = util.unique opts.user_defined_words || []

    # calculate positions
    for w, i in allWords
      # in urls
      if w in urls
        unless positions.urls[w]
          positions.urls[w]                = []
        positions.urls[w].push i

      # in hashtags
      if w in hashTags
        unless positions.hash_tags[w]
          positions.hash_tags[w]           = []
        positions.hash_tags[w].push i

      # in mentions
      if w in mentions
        unless positions.mentions[w]
          positions.mentions[w]            = []
        positions.mentions[w].push i

      # in keywords
      if w in kw
        unless positions.kw[w]
          positions.kw[w]                  = []
        positions.kw[w].push i

      # custom words
      if w in customWords
        unless positions.user_defined_words[w]
          positions.user_defined_words[w]  = []
        positions.user_defined_words[w].push i

    result.twitter.pos = positions

)(exports, util, mimimi)
