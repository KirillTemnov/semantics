###
Misc params, like digits, emoticons and maybe others.
###

if "undefined" is typeof global
    window.lastName ||= {}
    window.lastName.misc ||= {}
    exports = window.lastName.misc
else
    exports = module.exports

((exports) ->

  ###
  Extract digits, smiles


  ###
  exports.preFilter = (text, result) ->
    # source http://luvca.blogspot.com/2006/10/text-smiles.html
    # source: http://en.wikipedia.org/wiki/List_of_emoticons
    emoticons = [":-)", "(-:", ":o)", ":)", "(:", ":->", ":-}", ":-t", ":*)", ":-)))", ":-D", "(-D", ":'-)", "%-)", ":-/", ":-I", ":~)", "(:-(", ":-(", ":-c", ":-(((", ":-<", ">:-(", ":-[", "(:-&", "%-(", ">:-<", "~ :-(", "%-(", ":/)", ":-|", ":-e", ":-X", ":-v", ":-I", ":-8(", ":-O", ":-@", ":,-(", ":'-(", "~:-o", "]:-)>", "):-)", ";->", ":-x", ":-*", "8-]", ":-J", ":-&", ":-p", ":-P", ";-)", ";)", "'-)", ":-7", "?-(", "B-D", ":-B", ":-*)", ":-9", "|-p", ":-b", "-]:-)[-", "8-I", "8-|", "|:-|", ":-]", "|-)", "|-I", "I^o", "|-O", ":-\"", ":-s", ":-#", ":-!", ":-()", ":-D", "(:-$", ":-(*)", ":-')", ":-R", "%+|", "%+{", "X-(", "<:-)", "*:o)", "@;-)", "X:-)", ":>)", "&:-)", "#:-)", "8-)", "8:-)", "B-)", "B-]", "O:-)", "&8-|", ":-{", ":-)}", ":-)#", ":-Q", ":-I", ":-d~", ":-?", ":-/I", ":-) X", "{(:-)", ":-{}", "[:-)", "d :-o", "~:-(", "~~:-(", "))", "(:-I", "3:-o", "[: |]", "M-)", ":X)", ":-M", "*8((:", "O+", "O->", "||*(", "||*)", "<{:-)}", "(-: :-)", "@->-", "@==", "<')))))- <"]
    emoticons.sort (a,b) -> b.length - a.length
    tempTxt = text[0..-1]
    findEmo = []
    for emo in emoticons
      ind = 0
      while ind >= 0
        ind = tempTxt.indexOf emo, ind
        if ind isnt -1
          findEmo.push emo
          tempTxt = tempTxt.replace emo, ""
          ind -= (emo.length + 2)

    # split text on sentences
    punctuationRe = /[\.,:\/\\\?!\+\'\"«»\*\(\)\[\]\&\№“”\—]/g
    tempTxt = text.replace(/\n/g, " ").replace(punctuationRe, " $& ").replace /\s+/g, " "
    unless /\./.test tempTxt
      tempTxt += ". "

    sentences = []
    prev = ""
    for s, i in (tempTxt.split(/([\?\!])|(\.\s+)/gm).filter (s) -> !!s)
      if i % 2 is 1
        sentences.push prev + s
      else
        prev = s


    result.misc =
      digits: util.arrayToDict text.match(/-?((\d+[\.,]\d+)|(\d+))/ig) || []
      emoticons: util.arrayToDict findEmo
      sentences: sentences
    result
)(exports)