###
Plugin make deal with twitter-special markup.

depends on misc
###

if "undefined" is typeof global
    window.lastName.plugins.ru.twitter   = {}
    exports                              = window.lastName.plugins.ru.twitter
    util                                 = window.lastName.util
    mimimi                               = window.lastName.mimimi
else
    exports                              = module.exports
    util                                 = require "../../util"
    mimimi                               = require "../../mimimi"

((exports, util, mimimi) ->
  ###
  Split harder, than regular text.

  @param {String} text Sentence text
  @return {Array} result Sentence splitted by words
  ###
  splitHard = (text, nosplit=[]) -> # todo add expand options
    words = []
    for w in text.split /\s/
      if w in nosplit
        words.push w
      else if /\S{0,}[a-zа-яё][-\.,?!:\/\\][a-zа-яё]\S{0,}/i.test w
        w.replace(/[-\.,?!:\/\\]/g, " $& ").split(" ").map (sw) -> words.push sw
      else
        words.push w

    finalWords = []
    words.map (w) ->
      if w
        sresult = mimimi.search w
        if sresult.mixed_words.length > 1 and /^[а-яёa-z]+$/i.test w
          sresult.mixed_words.map (mw) -> finalWords.push mw
        else                      # todo check for single signs
          finalWords.push w

    finalWords

  ###
  Apply twitter filter to result.

  @param {String} text Source text ( not used)
  @param {Object} result Resulting object, that contain `twitter`
                         field after applying this filter.
  @param {Object} opts Options, :default {}
  ###
  exports.preFilter = (text, result, opts={}) ->
    sentences = []
    nosplit = util.dictKeys result.misc.urls || {}
    for s in result.misc.sentences
      sentences.push splitHard(s, nosplit).join " "

    result.misc.sentences = sentences

)(exports, util, mimimi)