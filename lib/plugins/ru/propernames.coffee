###
Find proper names, depends on misc plugin.

# todo refactor misc dependency.

###

if "undefined" is typeof global
    window.semantics                       ||= {}
    window.semantics.plugins               ||= {}
    window.semantics.plugins.ru            ||= {}
    window.semantics.plugins.ru.propernames  = {}
    exports                                 = window.semantics.plugins.ru.propernames
    inclines                                = window.semantics.plugins.ru.inclines
    util                                    = window.semantics.util
else
    exports                                 = module.exports
    inclines                                = require "./inclines"
    util                                    = require "../../util"

((exports, inclines) ->

  ###
  Get Person names from text. This function merge similar names to one entity.
  e.g. ["Антон--"] and ["Антон-Павлович-Чехов"] to ["Антон-Павлович-Чехов"] x 2

  @param {String} text Source text
  @return {Object} result Dictionary of object, described in incline module,
                          @see `plugins.ru.inclines` description.
  ###
  exports.getPersonsNames = getPersonsNames = (text) ->
    properNames    = []
    curProperName  = []
    pnList         = []

    properNamesRe = /[А-Я][а-яё]+(\s+[А-Я][а-яё]+){0,2}/gm
    for pn in text.match(properNamesRe) || []
      curProperName = pn.replace(/\s+/g, " ").split " "
      if curProperName
        pni = inclines.findProperName curProperName
        if pni && pni.found
          properNames.push pni

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
          for person in pnList
            if (p.first_name is person[0]) and (person[1] or person[2])
              pnDict[person[3]].count  += p.count
              for s in p.src
                pnDict[person[3]].src.push s unless s in pnDict[person[3]].src

              break
          namesForRemove.push id

    delete pnDict[rmId] for rmId in namesForRemove

    twitterNamesRe = /(^|\s)\@[a-z_\d]+/ig
    for pn in text.match(twitterNamesRe) || []
      twName = pn.trim()
      unless pnDict[twName]
        pnDict[twName] =
          src         : [twName]
          first_name  : twName
          middle_name : twName
          surname     : twName
          gender      : "unknown"
          found       : yes
          case        : "nominative"
          count       : 1
      else
        pnDict[twName].count += 1

    pnDict

  ###
  Get addresses from text.

  @param {String} text Source text
  @return {Array} result Array of addresses.
  ###
  exports.getAddresses = getAddresses = (text) ->
    streetRe = /((улиц(а|е|ы|у|ей)|ул\.?)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(улиц(а|е|ы|у|ей)|ул\.?))/gm
    alleyRe = /(алле(я|е|и|ю|ей)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+алле(я|е|и|ю|ей))/gm
    highwayRe = /((шоссе|ш\.)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(шоссе|ш\.))/gm
    prospectusRe = /((проспект(а|у|е|ом|)|пр\-т|просп\.)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(проспект(а|у|е|ом|)|пр\-т|просп\.))/gm
    passageRe = /((проезд(а|у|е|ом|a)|пр\-д)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(проезд(а|у|е|ом|)|пр\-д))/gm
    bridgeRe = /(мост(а|у|е|ом|)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+мост(а|у|е|ом|))/gm
    areaRe = /((площад(ь|и|ью)|пл\.)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(площад(ь|и|ью)|пл\.))/gm
    laneRe = /((переул(ок|ка|ке|ом)|пер\.)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(переул(ок|ка|ке|ом)|пер\.))/gm
    deadlockRe = /(тупик(а|у|е|ом|)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+тупик(а|у|е|ом|))/gm
    embankmentRe = /((набережн(ая|ой|ую)|наб\.)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(набережн(ая|ой|ую)|наб\.))/gm
    settlementRe = /((пос[её]л(ок|ка|ком|ке)|пос\.)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(пос[её]л(ок|ка|ком|ке)|пос\.))/gm
    villageRe = /((деревн(я|и|ю|ей)|дер\.)(\s+((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+)))+)|(((\d+(|\s\-\s[а-я]+))|([А-Я][а-яё]+))+\s+(деревн(я|и|ю|ей)|дер\.))/gm
    addresses = []
    [streetRe, alleyRe, highwayRe, prospectusRe, passageRe, bridgeRe, areaRe, laneRe, deadlockRe, embankmentRe, villageRe].map (reg) ->
      for i in text.match(reg) || []
        addresses.push i
    addresses
    # todo incline addresses

  ###
  Get names

  ###
  exports.getNames = getNames = (text) ->
    ofNameRe = /(\s[А-Я]\.(\s{0,}[А-Я]\.){0,1}\s{0,1}[А-Я][А-Яа-я\-]+)|([А-Я][А-Яа-я\-]+\s[А-Я]\.\s{0,}([А-Я](\s|\.)){0,1})/gm
    util.arrayToDict (x.trim() for x in text.match(ofNameRe) || [])



  ###
  Search proper names in text.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain `propernames`
                         field after applying this filter.
  ###
  exports.postFilter = (text, result) ->
    result.ru           ||={}
    result.ru.persons      = getPersonsNames text
    result.ru.addresses    = getAddresses text
    result.ru.names        = getNames text



)(exports, inclines)
