###
Misc params, like digits, emoticons and maybe others.
###

if "undefined" is typeof global
    window.semantics      ||= {}
    window.semantics.misc ||= {}
    exports                = window.semantics.misc
    util                   = window.semantics.util
else
    exports                = module.exports
    util                   = require "./util"

((exports, util) ->

  ###
  Normalize text: insert space after and before each of punctiuation signs,
  remove double spaces, add dot at end of text, if omited.

  @param {String} text Source text
  @return {String} result Normalized text
  ###
  exports.normalizeText = normalizeText = (text) ->
    punctuationRe = /(https?\:\/\/.*[\s$])|(\.\s)|(,\s)|(\s\:)|(:\s)|(\s\/)|(\/\s)|(\s\\)(\\\s)|\?|!|\+|\'|\"|«|»|\*|\(|\)|\[|\]|\&|\№|“|”|\—/g

    tempTxt = text.replace(punctuationRe, " $& ").replace /\s+/g, " "
    unless /[\?\!\.]\s{0,}$/.test tempTxt
      tempTxt += " . "
    tempTxt

  #
  # Public: Trim unnecesary spaces, e.g. "foo , bar ." -> "foo, bar."
  #
  # text - string with text
  # addSign - sign to add at the end of text, default "."
  #
  exports.denormalizeText = denormalizeText = (text, addSign=".") ->
    text = text.trim()
    len = text.length
    unless text[-1..-1] is addSign
      text += addSign

    punctuationsRightSpace = ".,:;!?)]»" #'\"«/»!?—"
    for pr in punctuationsRightSpace
      text = text.replace new RegExp(" \\#{pr}\\s?","g"), "#{pr} "
    punctuationsLeftSpace = "[(«" 
    for pl in punctuationsLeftSpace
      text = text.replace new RegExp("\\s?\\#{pl} ", "g"), " #{pl}"
    text = text.trim()
    text = text.replace /\s+/g, " "
    if text.length isnt len
      denormalizeText text, addSign # recursion
    else
      text

    

  ###
  Extract digits, emoticons and split text into sentences.

  @param {String} text Source text
  @param {Object} result Resulting object, that will contain fields:
      misc.digits    : Dictionary of numbers and count of occurrences for each of them
      misc.emoticons : Dictionary of emoticons and count of occurrences for each of them
      misc.romans    : Dictionary of roman digits and count of occurrences for each of them
      misc.urls      : Dictionary of urls and count of occurrences for each url
      misc.sentences : Array of text sentences
      

      counters.chars_total           : total characters in text
      counters.words_total           : total words in text
      counters.signs_total           : total signs in text (include signs in urls)
      counters.spaces_total          : total space chars (' ', '\t', '\n', '\r') in text
      counters.word_length_mid       : middle length of word in text (measured in chars)
      counters.words_in_sentence_mid : middle length of sentences, measured in words
  @param {Object} opts Options
                  opts.wordsToLower  : translate all words to lower case, :default false
  ###
  exports.preFilter = (text, result, opts) ->
    signs            = text.match /[-\+=\/\.,\!\?\@\#\$\%\^\&\*\(\)\[\]\{\}\<\>\`\~\"\':;\|\\_]{1}/g
    signs_total      = signs and signs.length or 0
    spaces_total     = if /\s/.test text then text.match(/\s/g).length else 0
    chars_total      = text.length
    words_total      = (text.split(/\s/).filter (wrd) ->
         wrd.length > 0 and not /^[-\+=\/\.\!\?\@\#\$\%\^\&\*\(\)\[\]\{\}\<\>\`\~\"\':;\|\\_]+$/.test wrd).length
    word_length_mid  = if words_total  then (chars_total - spaces_total - signs_total) / words_total else 0


    # source http://luvca.blogspot.com/2006/10/text-smiles.html
    # emoticons = [":o)", ":->", ":-}", ":-t", ":*)", ":-D", "(-D", ":'-)", "%-)", ":-/", ":-I", ":~)", ":-c", ":-<", ">:-(", ":-[", "(:-&", "%-(", ">:-<", "~ :-(", "%-(",  ":-|", ":-e", ":-X", ":-v", ":-I", ":-8(", ":-O", ":-@", ":,-(", ":'-(", "~:-o", "]:-)>", ";->", ":-x", ":-*", "8-]", ":-J", ":-&", ":-p", ":-P",  ":-7", "?-(", "B-D", ":-B", ":-*)", ":-9", "|-p", ":-b", "8-I", "8-|", "|:-|", ":-]", "|-I", "I^o", "|-O", ":-\"", ":-s", ":-#", ":-!", ":-()", ":-D", "(:-$", ":-(*)", ":-')", ":-R", "%+|", "%+{", "X-(", "<:-)", "*:o)", "@;-)", "X:-)", ":>)", "&:-)", "#:-)", "8-)", "8:-)", "B-)", "B-]", "O:-)", "&8-|", ":-{", ":-)}", ":-)#", ":-Q", ":-I", ":-d~", ":-?", ":-/I", ":-{}", "d :-o", "~:-(", "~~:-(", "(:-I", "3:-o", "[: |]", "M-)", ":X)", ":-M", "*8((:", "O+", "O->", "||*(", "||*)", "<{:-)}", "(-: :-)", "@->-", "@==", "<')))))- <"]
    emoticonsRe = /((|[:;\']-?)\)+)|((|[:;]-?)\(+)|(\(+(|-?:))|(\)+(|-?:))/g
    findEmo = text.match(emoticonsRe) || []
    if "(" in findEmo and ")" in findEmo # remove braces
      findEmo = findEmo.filter (z) -> not (z in "()")
    # emoticons.sort (a,b) -> b.length - a.length
    # tempTxt = text[0..-1]
    # findEmo = []
    # for emo in emoticons
    #   ind = 0
    #   while ind >= 0
    #     ind = tempTxt.indexOf emo, ind
    #     if ind isnt -1
    #       findEmo.push emo
    #       tempTxt = tempTxt.replace emo, ""
    #       ind -= (emo.length + 2)


    # split text on sentences
    tempTxt = normalizeText text

    # replace " . " -> " .. ",   " ! " -> " !! "  and " ? " -> " ?? "
    # then split by ".", "?" or "!", so the end sign of sentence stay inside it.
    # still have problems with short words, like "Иванов И.И.", because they
    # splitting sentences
    sentences = tempTxt.replace(/\s\?\s/gm, " ?? ").replace(/\s\!\s/gm, " !! ").replace(/\s\.\s/gm, " .. ").split(/[\?\!\.](\s+|$)/gm).filter (s) -> not /^\s{0,}$/.test s



    # romans regex from http://stackoverflow.com/questions/2577734/single-regex-for-filtering-roman-numerals-from-the-text-files
    # some good ideas in http://bililite.com/blog/2009/03/09/roman-numerals-in-javascript/
    romansReGlobal  = /(^|\s|[-,\.!?:;\'\"])(([X]{0,3}I[VX])|(M*(D?C{0,3}|C[DM])(L?X{0,3}|X[LC])(V?I{0,3}|I[VX])))($|\s|[-,\.!?:;\'\"])/g
    romansRe        = /([X]{0,3}I[VX])|(M*(D?C{0,3}|C[DM])(L?X{0,3}|X[LC])(V?I{0,3}|I[VX]))/gm
    rom             = text.match(romansReGlobal) || []
    romans          = (rom.join(" ").match(romansRe) || []).filter (s) -> not /^\s{0,}$/.test s

    result.version  = util.version

    if opts.wordsToLower
      wordsProceed = util.removeDuplcates
    else
      wordsProceed = (x) -> x

    # email re from http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
    emailRe = /(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-z\-0-9]+\.)+[a-z]{2,}))/ig

    phoneRe = /(\+?\d{1,4}|)(\s\(\s?\d{2,4}\s?\)|\d+)[-\s]\d+-[\s\d]+/g

    result.misc =
      digits    : util.arrayToDict text.match(/-?((\d+[\.,]\d+)|(\d+))/ig)
      emoticons : util.arrayToDict findEmo
      romans    : util.arrayToDict romans
      emails    : util.arrayToDict text.match emailRe
      phones    : util.arrayToDict text.match phoneRe
      urls      : util.arrayToDict text.match(/(https?\:\/\/[^\s$]+)/g)
      hashtags  : wordsProceed util.arrayToDict text.match(/\#[a-zёа-я_\d]+/gi)
      mentions  : util.arrayToDict text.match(/\@[_a-z\d]+/gi) || []
      sentences : sentences

    result.counters =
      chars_total           : chars_total
      words_total           : words_total
      signs_total           : signs_total
      spaces_total          : spaces_total
      word_length_mid       : word_length_mid
      words_in_sentence_mid : if sentences.length then words_total / sentences.length else 0

)(exports, util)
