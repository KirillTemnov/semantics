###
Find proper names, depends on misc plugin.

# todo refactor misc dependency.

###

if "undefined" is typeof global
    window.lastName                       ||= {}
    window.lastName.plugins               ||= {}
    window.lastName.plugins.ru            ||= {}
    window.lastName.plugins.ru.propernames  = {}
    exports                                 = window.lastName.plugins.ru.propernames
    morpho                                  = window.lastName.plugins.ru.morpho
    inclines                                = window.lastName.plugins.ru.inclines
else
    exports                                 = module.exports
    morpho                                  = require "./morpho"
    inclines                                = require "./inclines"


((exports, morpho, inclines) ->

  ###
  Search proper names in text.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain `propernames`
                         field after applying this filter.
  ###
  exports.postFilter = (text, result) -> # todo add sentence numbers
    # copy code from index
    punctuationRe = /[\.,:\/\\\?!\+\'\"«»\*\(\)\[\]\&\№“”\—]/g

    properNames = []
    curProperName = []

    properNamesRe = /[А-Я][а-яё]+(\s+[А-Я][а-яё]+){0,2}/gm
    for pn in text.match properNamesRe
      curProperName = pn.replace(/\s+/g, " ").split " "
      if curProperName
        pn = inclines.findProperName curProperName
        if pn && pn.found
          properNames.push pn

    pnDict = {}
    for p in properNames
      id = "#{p.first_name || ''}-#{p.middle_name || ''}-#{p.surname || ''}"
      if pnDict[id]
        pnDict[id].count += 1
        unless p.src in pnDict[id].src
          pnDict[id].src.push p.src
      else
        pnDict[id] = p
        pnDict[id].src = [p.src]
        pnDict[id].count = 1
    result.propernames = pnDict


)(exports, morpho, inclines)