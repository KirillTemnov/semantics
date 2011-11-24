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
  Get proper names from text. This function merge similar names to one entity.
  e.g. ["Антон--"] and ["Антон-Павлович-Чехов"] to ["Антон-Павлович-Чехов"] x 2

  @param {String} text Source text
  @return {Object} result Dictionary of object, described in incline module,
                          @see `plugins.ru.inclines` description.
  ###
  exports.getProperNames = (text) ->
    properNames    = []
    curProperName  = []
    pnList         = []

    properNamesRe = /[А-Я][а-яё]+(\s+[А-Я][а-яё]+){0,2}/gm
    for pn in text.match properNamesRe
      curProperName = pn.replace(/\s+/g, " ").split " "
      if curProperName
        pn = inclines.findProperName curProperName
        if pn && pn.found
          properNames.push pn

    pnDict = {}
    # map
    for p in properNames
      id = "#{p.first_name || ''}-#{p.middle_name || ''}-#{p.surname || ''}"
      if pnDict[id]
        pnDict[id].count += 1
        unless p.src in pnDict[id].src
          pnDict[id].src.push p.src
      else
        if p.first_name         # add to index only if first_name known
          pnList.push [p.first_name, p.middle_name, p.surname, id]

        pnDict[id] = p
        pnDict[id].src = [p.src]
        pnDict[id].count = 1

    # and reduce
    namesForRemove = []
    for id, p of pnDict
      if "--" is id[0...2]     # just a surname
        for person in pnList
          if p.surname is person[2]
            pnDict[person[3]].count  += p.count
            for s in p.src
              pnDict[person[3]].src.push s unless s in pnDict[person[3]].src
            break
        namesForRemove.push id

      else if /^\-.+\-$/.test id       # just middle name
        for person in pnList
          if p.middle_name is person[1]
            pnDict[person[3]].count  += p.count
            for s in p.src
              pnDict[person[3]].src.push s unless s in pnDict[person[3]].src

            break

        namesForRemove.push id

      else if /^.+\-\-$/.test id       # just first name
          console.log "found!!! #{id}"
          for person in pnList
            if (p.first_name is person[0]) and (person[1] or person[2])
              pnDict[person[3]].count  += p.count
              for s in p.src
                pnDict[person[3]].src.push s unless s in pnDict[person[3]].src

              break
          namesForRemove.push id

    delete pnDict[rmId] for rmId in namesForRemove

    pnDict

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