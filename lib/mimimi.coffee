###
Calculate mimimi scores for russian and english words.
Depends on misc.
###

if "undefined" is typeof global
    window.lastName.mimimi ||= {}
    exports                 = window.lastName.mimimi
    util                    = window.lastName.util
else
    exports                 = module.exports
    util                    = require "./util"

((exports, util) ->
  exports.calculate = (word) ->
    syllables  = []
    syllable   = ""
    for c in word
      if c in "-_.+ "
        continue

      unless c in "eyuioaуеыаоэяию"
        syllable += c
      else
        syllables.push syllable + c
        syllable = ""
    if syllable
      syllables.push syllable

    syllables.reverse()
    mimi = util.arrayToDict syllables
    result =  total: 0, found: no
    for k,v of mimi
      if v >= 3
        result.total += v
    if result.total >= 3
      result.src = word
      result.found = yes
    result

)(exports, util)


