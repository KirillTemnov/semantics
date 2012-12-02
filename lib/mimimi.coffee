###
Calculate mimimi scores for russian and english words.
Depends on misc.
###

if "undefined" is typeof global
    window.semantics.mimimi ||= {}
    exports                  = window.semantics.mimimi
    util                     = window.semantics.util
else
    exports                  = module.exports
    util                     = require "./util"

((exports, util) ->
  ###
  Search mimimi sequence in word.

  @param {String} word Source word
  @return {Object} result Resulting object
                   result.found       : true | false
                   result.total       : count, if total >= 3 found is true
                   result.src         : source word
                   result.nodup       : word with removed duplicate chars (in lower case)
                   result.reason      : array of strings - reasons for classifying word as mimi
                   result.mixed_words : array of words, separated by different cap "waves"
                                        `mixed_words` avaluates in any case.
  ###
  exports.search = search = (word) ->
    result =
      total       : 0
      found       : no
      reason      : []
      src         : word
      mixed_words : []
    if /^https?\:\/\/.+$/.test word
      return result

    syllables  = []
    syllable   = ""
    for c in word.toLowerCase()
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

    for k,v of mimi
      if v >= 3
        result.total += v
    if result.total >= 3
      result.found  = yes
      result.reason.push "triple or more syllables"

    # max length set to 28, if not, spaces possibly was ommited, -> its mimimi word
    if word.length > 28
      result.found  = yes
      result.total += 2.5
      result.reason.push "length more than 28 chars"


    # search duplicate chars like foooooo bbbbbbaaaaaarr
    prevC        = ""
    trimmedWord  = ""
    duplicates   = 0
    dup          = 0
    for c in word.toLowerCase()
      if c in "()" # smiles
        trimmedWord += c
      else if c isnt prevC
        trimmedWord += prevC
        duplicates  += dup if dup > 2
        dup          = 1
      else
        dup         += 1
      prevC = c

    duplicates += dup if dup > 2
    trimmedWord += prevC if trimmedWord[-1] isnt prevC
    if duplicates > 2
      result.total += duplicates
      result.found  = yes
      result.nodup  = trimmedWord
      result.reason.push "duplicate chars"

    # mixed caps
    waves = 0
    mixed_words = []
    mixedWord = ""
    direction = util.isCapitalized word[0] # true - up, false - down
    for c in word
      dir = util.isCapitalized c
      if direction isnt dir
        direction  = dir
        waves     += 0.5
        if waves % 1 is 0
          mixed_words.push mixedWord
          mixedWord  = c
        else
          mixedWord  += c
      else
        mixedWord += c

    mixed_words.push mixedWord if mixedWord
    result.mixed_words  = mixed_words

    if waves >= 2
      result.total       += waves / .5
      result.found        = yes
      result.waves        = waves
      result.reason.push "mixed caps"

    # frequent analysis, example ахааха
    wrd = word.replace /[\(\)]/g, ""
    lettersTotal = util.dictKeys(util.arrayToDict wrd.toLowerCase()).length
    lettersMid = wrd.length / lettersTotal
    if lettersMid >= 2.5
      result.found = yes
      result.reason.push "frequent letters"

    result

  ###
  Extract mimimi words from text.

  @param {String} text Source text
  @param {Object} result Resulting object that will contain fields:
                  result.mimimi  : Dictionary of mimimi words and count
                                   of occurrences for each word
  ###
  exports.preFilter = (text, result) ->
    mimi = {}
    for s,i in result.misc.sentences
      for word in (s.split(" ").filter (x) -> x.length > 2)
        miWord = search word
        if miWord.found
          unless mimi[miWord.src]
            mimi[miWord.src] =
              word  : miWord
              count : 1
          else
            mimi[miWord.src].count += 1

    result.mimimi = mimi


)(exports, util)


