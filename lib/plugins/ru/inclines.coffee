

if "undefined" is typeof global
    window.lastName ||= {}
    window.lastName.plugins ||= {}
    window.lastName.plugins.ru || = {}
    window.lastName.plugins.ru.inclines = {}
    exports = window.lastName.plugins.ru.inclines
    util = window.lastName.util
    ref = window.lastName.plugins.ru.ref
else
    exports = module.exports
    util = require "../../util"
    ref = require "./ref"

((exports, util, ref) ->

  cases = ["nominative", "genitive", "dative", "accusative", "instrumental", "prepositional"]

  ###
  Incline female name in nominative.

  @param {String} name Female name
  @return {Array} result Array of cases for this name
  ###
  exports.doInclineFemaleName = doInclineFemaleName = (name) ->
    aNotAfterHissingAndOthersRe = /[^жшщцгкхч]а$/g
    aAfterHissingAndOthersRe = /[жшщцгкхч]а$/g
    aUnstressedRe = /ца$/g

    name2 = name[..-2]
    if aNotAfterHissingAndOthersRe.test name
      ["#{name2}а", "#{name2}ы", "#{name2}е", "#{name2}у", "#{name2}ой", "#{name2}е"]
    else if aUnstressedRe.test name
      ["#{name2}а", "#{name2}ы", "#{name2}е", "#{name2}у", "#{name2}ей", "#{name2}е"]
    else if aAfterHissingAndOthersRe.test name
      ["#{name2}а", "#{name2}и", "#{name2}е", "#{name2}у", "#{name2}ой", "#{name2}е"]
    else if /ия$/g.test(name) && name.length >  3 # except Ия, Лия, Яя ..
      ["#{name2}я", "#{name2}и", "#{name2}и", "#{name2}ю", "#{name2}ей", "#{name2}и"]
    else if /я$/g.test name
      ["#{name2}я", "#{name2}и", "#{name2}е", "#{name2}ю", "#{name2}ей", "#{name2}е"]
    else if /ь$/g.test name
      ["#{name2}ь", "#{name2}и", "#{name2}и", "#{name2}ь", "#{name2}ью", "#{name2}и"]
    else if /[жшщцч]$/g.test name
      ["#{name}", "#{name}и", "#{name}и", "#{name}", "#{name}ью", "#{name}и"]
    else                          # not inclined
      [name, name, name, name, name, name]

  ###
  Incline male name in nominative.

  @param {String} name Male name
  @return {Array} result Array of cases for this name
  ###
  exports.doInclineMaleName = doInclineMaleName = (name) ->
    hardConsonants = /[бвгдзклмнпрстфх]$/g
    hissingAndChe = /[жшщцч]$/g
    ishortRe = /((ай)|(ей)|(ой)|(уй)|(яй)|(юй)|(ий))$/g
    aNotAfterHissingAndOthersRe = /[^жшщцгкхч]а$/g
    aAfterHissingAndOthersRe = /[жшщцгкхч]а$/g
    name2 = name[..-2]
    if name is "Лев"
      ["Лев", "Льва", "Льву", "Льва", "Львом", "Льве"]
    else if name is "Павел"
      ["Павел", "Павла", "Павлу", "Павла", "Павлом", "Павле"]
    else if /и$/g.test name       # georgian names
      [name, name, name, name, name, name]
    else if hissingAndChe.test name
      [name, "#{name}а", "#{name}у", "#{name}а", "#{name}ем", "#{name}е"]
    else if hardConsonants.test name
      [name, "#{name}а", "#{name}у", "#{name}а", "#{name}ом", "#{name}е"]
    else if /ь$/g.test name
      ["#{name2}ь", "#{name2}я", "#{name2}ю", "#{name2}я", "#{name2}ем", "#{name2}е"]
    else if ishortRe.test name
      ["#{name2}й", "#{name2}я", "#{name2}ю", "#{name2}я", "#{name2}ем", "#{name2}е"]
    else if aNotAfterHissingAndOthersRe.test name
      ["#{name2}а", "#{name2}ы", "#{name2}е", "#{name2}у", "#{name2}ой", "#{name2}е"]
    else if aAfterHissingAndOthersRe.test name
      ["#{name2}а", "#{name2}и", "#{name2}е", "#{name2}у", "#{name2}ой", "#{name2}е"]
    else if /я$/g.test name
      ["#{name2}я", "#{name2}и", "#{name2}е", "#{name2}ю", "#{name2}ей", "#{name2}е"]
    else if /ко$/g.test name
      ["#{name2}о", "#{name2}и", "#{name2}е", "#{name2}у", "#{name2}ой", "#{name2}е"]
    else if /о$/g.test name
      ["#{name2}о", "#{name2}ы", "#{name2}е", "#{name2}у", "#{name2}ой", "#{name2}е"]
    else
      null

  ###
  Incline by incline function and return result.


  ###
  inclineAndGetResult = (fn, args) ->
    r = null
    for i, name of args
      r = fn name, yes
      if r.found
        break
    r

  inclineFemaleNameAndGetResult = ->
    inclineAndGetResult inclineFemaleName, arguments


  inclineMaleNameAndGetResult = ->
    inclineAndGetResult inclineMaleName,  arguments


  exports.inclineFemaleName = inclineFemaleName = (name, nominativeOnly=no) ->
    nl = name.toLowerCase()
    nominativeRe = /[адежзийклмнорстуьэя]$/g
    canInclineRe = /[жшщцчаяь]$/g
    genitiveRe = /[иы]$/g
    dativeRe = /[еи]$/g
    accusativeRe = /[жшщцчьую]$/g
    instrumentalRe = /((ой)|(ей)|(еи)|(ью))$/g
    prepositionalRe = /[еи]$/g
    result = r = null
    if nominativeRe.test(nl) && ref.ruFemaleNamesDict[nl]
      if canInclineRe.test nl
        name_cases = doInclineFemaleName name
        possible_cases = ["nominative"]
      else
        name_cases = [name, name, name, name, name, name]
        possible_cases = ["nominative", "genitive", "dative", "accusative", "instrumental", "prepositional"]
      return  {found: yes, gender: "female", src: name, cases: name_cases, guess_case: "nominative", nominative: name, possible_cases: possible_cases}
    else if nominativeOnly
      return {found: no, src: name}

    name2 = name[..-2]
    name_cases = []

    if genitiveRe.test nl
      r = inclineFemaleNameAndGetResult "#{name2}я", "#{name2}а", "#{name2}ь", "#{name2}"
      if r && r.found
        result = r
        name_cases.push "genitive"
    if dativeRe.test nl
      r = inclineFemaleNameAndGetResult "#{name2}я", "#{name2}а", "#{name2}ь", "#{name2}"
      if r && r.found
        result = r
        name_cases.push "dative"
    if prepositionalRe.test nl    # check similar cases together
      r = inclineFemaleNameAndGetResult "#{name2}я", "#{name2}а", "#{name2}ь", "#{name2}"
      if r && r.found
        result = r
        name_cases.push "prepositional"
    if accusativeRe.test nl
      if /[ую]$/g.test nl
        r = inclineFemaleNameAndGetResult "#{name2}я", "#{name2}а"
      else                        # consonants
        r = inclineFemaleNameAndGetResult name
      if r && r.found
        result = r
        name_cases.push "accusative"
    if instrumentalRe.test nl
      name3 = name[..-3]
      r = inclineFemaleNameAndGetResult "#{name3}я", "#{name3}а", "#{name3}ь", "#{name3}"
      if r && r.found
        result = r
        name_cases.push "instrumental"
    unless result
      result = r || found: no

    result.src = name
    result.possible_cases = name_cases
    result.guess_case = name_cases[0]
    result


  exports.inclineMaleName = inclineMaleName = (name, nominativeOnly=no) ->
    name = "Лев" if name is "Льв"
    name = "Павел" if name is "Павл"

    nl = name.toLowerCase()
    nominativeRe = /([вгдзклмнпрстфхжшцьй]|(ба)|(ва)|(да)|(за)|(ла)|(ма)|(на)|(па)|(ра)|(са)|(та)|(фа)|(га)|(ка)|(ха)|(жа)|(ша)|(ща)|(ца)|(ча)|(я)|(ло)|(ко))$/g
    canInclineRe = /([бвгдзклмнпрстфхжшцьая]|(ия)|(ья)|(ея)|(ий)|(ей))$/g
    genitiveRe = /[аяыи]$/g
    dativeRe = /(([еую])|(ии))$/g
    accusativeRe = /[аяую]$/g
    instrumentalRe = /((ом)|(ем)|(ой)|(ей)|(ёй))$/g
    prepositionalRe = /((е)|(ии))$/g
  #  vowels = "аеиоуэюя"
    name2 = name[..-2]
    result = r = null
    if nominativeRe.test(nl) && ref.ruMaleNamesDict[nl]
      if canInclineRe.test nl
        name_cases = doInclineMaleName name
        possible_cases = ["nominative"]
      else                        # check for inclines by passing through case regexps
        name_cases = [name, name, name, name, name, name]
        possible_cases = ["nominative", "genitive", "dative", "accusative", "instrumental", "prepositional"]
      return  {found: yes, gender: "male", src: name, cases: name_cases, guess_case: "nominative", nominative: name, possible_cases: possible_cases}
    else if nominativeOnly
      return {found: no, src: name}

    name_cases = []
    if genitiveRe.test nl
      # replacement table:
      # а -> (nil)
      # [аеуоия]я -> й
      # [бвдзмнпрлс]я -> ь
      # и -> а,я
      # ы -> о
      if /[а]$/g.test nl
        r = inclineMaleNameAndGetResult name2
      else if /[аеуоия]я$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-2]}й"
      else if /[бвдзмнпрлс]я$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-2]}ь"
      else if /ы$/g.test nl
        r = inclineMaleNameAndGetResult "#{name2}о", "#{name2}а"
      else if /и$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-2]}а", "#{name[..-2]}я", "#{name[..-2]}о"
      else
        r = null
      if r && r.found
        result = r
        name_cases.push "genitive"
    if dativeRe.test nl
      if /у$/g.test nl
        r = inclineMaleName name2
      else if /[аеиоуя]ю$/g.test nl
        r = inclineMaleNameAndGetResult "#{name2}й"
      else if /ю$/g.test nl
        r = inclineMaleNameAndGetResult "#{name2}ь"
      else if /е$/g.test nl
        r = inclineMaleNameAndGetResult "#{name2}и", "#{name2}я", "#{name2}o"
      else if /ии$/g.test nl
        r = inclineMaleNameAndGetResult "#{name2}я"
      else
        r = null
      if r && r.found
        result = r
        name_cases.push "dative"
    if accusativeRe.test nl
      if /[а]$/g.test nl
        r = inclineMaleNameAndGetResult name2
      else if /[аеуоия]я$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-2]}й"
      else if /[бвдзмнпрлс]я$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-2]}ь"
      else if /у$/g.test nl
        r = inclineMaleNameAndGetResult  "#{name2}а"
      else if /[ую]$/g.test nl
        r = inclineMaleNameAndGetResult "#{name2}а", "#{name2}я", "#{name2}о"
      else
        r = null
      if r && r.found
        result = r
        name_cases.push "accusative"
    if instrumentalRe.test nl
      # ом ем ой ей
      if /ом$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-3]}"
      else if /ем$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-3]}", "#{name[..-3]}ь", "#{name[..-3]}й"
      else if /ой$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-3]}а", "#{name[..-3]}о"
      else if /((ей)|(ёй))$/g.test nl
        r = inclineMaleNameAndGetResult "#{name[..-3]}я", "#{name[..-3]}а"
      else
        r = null
      if r && r.found
        result = r
        name_cases.push "instrumental"
    if prepositionalRe.test nl
      if /е$/g.test nl
        r = inclineMaleNameAndGetResult name2, "#{name2}ь", "#{name2}й", "#{name2}а", "#{name2}я", "#{name2}о"
      else if /и$/g.test nl
        r = inclineMaleNameAndGetResult "#{name2}я", "#{name2}й"
      else
        r = null
      if r && r.found
        result = r
        name_cases.push "prepositional"
    unless result
      result = r || found: no

    result.src = name
    result.possible_cases = name_cases
    result.guess_case = name_cases[0]
    result

  exports.inclineName = inclineName = (name) ->
    fn = inclineFemaleName name
    mn = inclineMaleName name
    if fn.found                   # female
      result = {found: yes, src: name, gender: "female", guess_case: fn.guess_case, female_cases: fn.cases, possible_cases: fn.possible_cases, nominative: fn.nominative}
    else if mn.found
      result = {found: yes, src: name, gender: "male", guess_case: mn.guess_case, male_cases: mn.cases, possible_cases: mn.possible_cases,  nominative: mn.nominative}
    else
      # word may be a name
      if fn.possible_yes && mn.possible_yes

        result = {found: "maybe", src: name, gender: ["male", "female"], female_cases: fn.cases, male_cases: mn.cases, possible_cases: util.merge fn.possible_cases, mn.possible_cases}
        result.guess_case = if fn.guess_case_index <= mn.guess_case_index then fn.guess_case else mn.guess_case
      else if fn.possible_yes
        result = {found: "maybe", src: name, gender: "female", female_cases: fn.cases, guess_case: fn.cases, possible_cases: fn.possible_cases}
      else if mn.possible_yes
        result = {found: "maybe", src: name, gender: "male", male_cases: mn.cases, guess_case: mn.cases, possible_cases: mn.possible_cases}
      else
        result = {found: no, src: name}
    result

  inclineSurname = (surname, noInclinesRe, inclineRe, casesRe) ->
    result = found: null,  src: surname, cases: null, cases_index: null
    if noInclinesRe && noInclinesRe.test(surname)
      result = found: surname,  src: surname, cases: ["nominative","genitive","dative","accusative","instrumental","prepositional"], cases_index: [0,1,2,3,4,5]
    else
      for check in inclineRe
        if check[0].test surname
          result = found: surname.replace(check[0], check[1]), src: surname
          cases_index = []
          surname_cases = []
          i = 0
          for c in casesRe
            if c.test surname
              cases_index.push i
              surname_cases.push cases[i] # clobal cases closure
            i++
          if surname_cases.length is 0
            result.found = null
            result.cases = null
          else
            result.cases = surname_cases
          result.cases_index = cases_index
          break
    if result.surname_cases
      result.guess_case = result.surname_cases[0]
    result

  exports.inclineFemaleSurname = inclineFemaleSurname = (surname) ->
    noInclinesRe = /((их)|(ых)|(е)|(о)|(э)|(и)|(ы)|(^[нв]у)|(^ую)|(уа)|(иа)|(ман)|(вич)|(ян))$/g
    inclineRe = [
      [/((ова)|(овой)|(ову))$/g, "ова"]
      [/((ева)|(евой)|(еву))$/g, "ева"]
      [/((ёва)|(ёвой)|(ёву))$/g, "ёва"]
      [/((ина)|(иной)|(ину))$/g, "ина"]
      [/((ая)|(ой)|(ую))$/g, "ая"]
      ]
    casesRe = [
      /((ова)|(ева)|(ёва)|(ина)|(ая))$/g,
      /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g,
      /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g,
      /((ову)|(еву)|(ёву)|(ину)|(ую))$/g,
      /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g,
      /((овой)|(евой)|(ёвой)|(иной)|(ой))$/g
      ]

    inclineSurname surname, noInclinesRe, inclineRe, casesRe


  exports.inclineMaleSurname = inclineMaleSurname = (surname) ->
    noInclinesRe = /((их)|(ых)|(^ве)|(^го)|(э)|(и)|(ы)|(^му)|(ю)|(уа)|(иа))$/g
    inclineRe = [
      [/((ов)|(ова)|(ову)|(овым)|(ове))$/g, "ов"]
      [/((ев)|(ева)|(еву)|(евым)|(еве))$/g, "ев"]
      [/((ёв)|(ёва)|(ёву)|(ёвым)|(ёве))$/g, "ёв"]
      [/((ин)|(ина)|(ину)|(иным)|(ине))$/g, "ин"]
      [/((ский)|(ского)|(скому)|(ским)|(ском))$/g, "ский"]
      [/((ской)|(ского)|(скому)|(ским)|(ском))$/g, "ской"]
      [/((ман)|(мана)|(ману)|(маном)|(мане))$/g, "ман"]
      [/((ой)|(ого)|(ому)|(ого)|(ым)|(ом))$/g, "ой"]
      [/((ий)|(ого)|(ому)|(ого)|(им)|(ом))$/g, "ий"]
      [/((ый)|(ого)|(ому)|(ого)|(ым)|(ом))$/g, "ый"]
      [/((ич)|(ича)|(ичу)|(ича)|(ичем)|(иче))$/g, "ич"]
      [/((ян)|(яна)|(яну)|(яна)|(яном)|(яне))$/g, "ян"]
      ]
    casesRe = [
      /((ов)|(ев)|(ёв)|(ин)|(ский)|(ской)|(ой)|(ий)|(ый)|(ман)|(ич)|(ян))$/g,
      /((ова)|(ева)|(ёва)|(ина)|(ского)|(ого)|(мана)|(ича)|(яна))$/g,
      /((ову)|(еву)|(ёву)|(ину)|(скому)|(ому)|(ману)|(ичу)|(яну))$/g,
      /((ова)|(ева)|(ёва)|(ина)|(ского)|(ого)|(мана)|(ича)|(яна))$/g,
      /((овым)|(евым)|(ёвым)|(иным)|(ским)|(им)|(ым)|(маном)|(ичем)|(яном))$/g,
      /((ове)|(еве)|(ёве)|(ине)|(ском)|(ом)|(мане)|(иче)|(яне))$/g
      ]
    inclineSurname surname, noInclinesRe, inclineRe, casesRe


  inclineMiddleNameOrSurname = (src, fem, male) ->
    if fem.found == male.found == null
      result = {found: no, src: src, value: null, gender: null}
    else if fem.found && male.found
      result = {found: yes, src: src, gender: ["male", "female"]}
      result.nominative_male = male.found
      result.nominative_female = fem.found
      result.female_cases = fem.cases
      result.male_cases = male.cases
      if fem.cases.length is 6 # not inclined
        if male.cases.length is 6   # not inclined too, unknown
          result.guess_sex = "unknown"
          result.possible_cases = util.merge fem.cases, male.cases
        else # suppose, that it's a man
          result.guess_sex = "male"
          result.nominative = male.found
          result.possible_cases = male.cases
      # nominative female, and multiple male cases, suppose it's a woman
      else if fem.cases.length is 1 && male.cases.length > 1
        result.guess_sex = "female"
        result.nominative = fem.found
        result.possible_cases = fem.cases
      else
        result.possible_cases = util.merge fem.cases, male.cases
    else if !fem.found
      result = {found: yes, src: src, gender: "male", male_cases: male.cases, guess_case: male.guess_case, nominative: male.found, possible_cases: male.cases}
    else if !male.found
      result = {found: yes, src: src, gender: "female", female_cases: fem.cases, guess_case: fem.guess_case, nominative: fem.found, possible_cases: fem.cases}
    result


  exports.inclineSurname = inclinePersonSurname = (surname) ->
    inclineMiddleNameOrSurname surname, inclineFemaleSurname(surname), inclineMaleSurname(surname)


  exports.inclineMaleMiddleName = inclineMaleMiddleName = (mname) ->
    inclineRe = [
      [/((евич)|(евича)|(евичу)|(евича)|(евичем)|(евиче))$/g, "евич"],
      [/((ович)|(овича)|(овичу)|(овича)|(овичем)|(овиче))$/g, "ович"],
      [/((ич)|(ича)|(ичу)|(ича)|(ичем)|(иче))$/g, "ич"],
      ]
    casesRe = [
      /((евич)|(ович)|(ич))$/g,
      /((евича)|(овича)|(ича))$/g,
      /((евичу)|(овичу)|(ичу))$/g,
      /((евича)|(овича)|(ича))$/g,
      /((евичем)|(овичем)|(ичем))$/g,
      /((евиче)|(овиче)|(иче))$/g
      ]
    inclineSurname mname, null, inclineRe, casesRe

  exports.inclineFemMiddleName = inclineFemMiddleName = (mname) ->
    inclineRe = [
      [/((вна)|(вны)|(вне)|(вну)|(вной)|(вне))$/g, "вна"],
      [/((чна)|(чны)|(чне)|(чну)|(чной)|(чне))$/g, "чна"]
      ]
    casesRe = [
      /((вна)|(чна))$/g,
      /((вны)|(чны))$/g,
      /((вне)|(чне))$/g,
      /((вну)|(чну))$/g,
      /((вной)|(чной))$/g,
      /((вне)|(чне))$/g
      ]
    inclineSurname mname, null, inclineRe, casesRe


  exports.inclineMiddleName = inclineMiddleName = (mname) ->
    inclineMiddleNameOrSurname mname, inclineFemMiddleName(mname), inclineMaleMiddleName(mname)


  #--------------------------------------------------------------------------------
  genderMatch = (g1, g2) ->
    if g1 == g2 || g1 in g2
      g1
    else if g2 in g1
      g2
    else
      null


  ###
  match gender of first name (comes first) middlename and surname
  ###
  matchNameParts = (fn, mn, sn) ->
    theCase = util.intersection fn.possible_cases, mn.possible_cases
    overallGender = genderMatch genderMatch(fn.gender, mn.gender), sn.gender
    if overallGender && (theCase in sn.possible_cases)||(theCase in sn["#{overallGender}_cases"])
      surname = sn.nominative || sn["nominative_#{overallGender}"]
      return  {first_name: fn.nominative, middle_name: mn.nominative, surname: surname, gender: overallGender, found: yes, case: theCase}
    else
      return {found: no}

  matchNameAndSurname = (fn, sn) ->
    overallGender = genderMatch fn.gender, sn.gender
    theCase = util.intersection fn.possible_cases, sn.possible_cases
    # if case not found
    unless theCase                   # try extract cases (and nominative) from custom gender
      sn.possible_cases = sn["#{overallGender}_cases"]
      sn.nominative = sn["nominative_#{overallGender}"]
      theCase = util.intersection fn.possible_cases, sn.possible_cases

    if overallGender && (theCase in sn.possible_cases)||(theCase in sn["#{overallGender}_cases"])
      surname = sn.nominative || sn["nominative_#{overallGender}"]
      return  {first_name: fn.nominative, middle_name: "", surname: surname, gender: overallGender, found: yes, case: theCase}
    else
      return {found: no}


  matchCase = (pObj, target_case, gender) ->
    target_case in pObj["#{gender}_cases"]

  getNominative = (pObj, gender) ->
    gnstr = "nominative_#{gender}"
    nom =  pObj.nominative && pObj.nominative || pObj[gnstr]
  #  console.log "#{gender} nominative = #{nom} \npObj = #{pObj[gnstr]} nom = #{nom}\n\n"
    nom

  exports.findProperName = findProperName = (listOfWords, opts={}) ->
    result = {found: no}
    switch listOfWords.length
      when 1                      # just surname
        result  = inclineName listOfWords[0]
        unless result.found
          result  = inclinePersonSurname listOfWords[0]
          if result.found
            result.surname = result.nominative
        else
          result.first_name = result.nominative
      when 2
        sr1     = inclinePersonSurname listOfWords[0]
        sr2     = inclinePersonSurname listOfWords[1]

        nr1     = inclineName listOfWords[0]
        nr2     = inclineName listOfWords[1]

        if nr1.found && sr2.found
          result = matchNameAndSurname nr1, sr2
        if !result.found && sr1.found && nr2.found
          result = matchNameAndSurname sr1, nr2

      when 3
        sr1   = inclinePersonSurname listOfWords[0]
        sr2   = inclinePersonSurname listOfWords[1]
        sr3   = inclinePersonSurname listOfWords[2]

        mnr2  = inclineMiddleName listOfWords[1]
        mnr3  = inclineMiddleName listOfWords[2]

        nr1   = inclineName listOfWords[0]
        nr2   = inclineName listOfWords[1]
        nr3   = inclineName listOfWords[2]

        # the cases are:
        # #1 Surname Name MiddleName
        # #2 Name MiddleName Surname
        # #3 Trash Name Surname
        # #4 Name Surname Trash
        if nr3.found
          result =
            found: no
            error: "name at the end of 3-component proper name"
        else if nr1.found              # cases #2 and #4
          # #2
          if mnr2.found && sr3.found # check compliance
            result = matchNameParts nr1, mnr2, sr3
          if !result.found && sr2.found
            result = matchNameAndSurname nr1, sr2
        else if sr1.found && nr2.found && mnr3.found  # case 1
            result = matchNameParts nr2, mnr3, sr1
        else if nr2.found && sr3.found
            result = matchNameAndSurname nr2, sr3


    result.first_name  ||= ""
    result.middle_name ||= ""
    result.surname     ||= ""
    unless (result.first_name || result.middle_name || result.surname)
      result =
        found: no
        error: "person not found"
    result.src = listOfWords.join " "
    result

  exports.inclineNoun =  inclineNoun = (noun) ->
    nounEndings = ["аб", "ав", "аг", "ад", "аж", "аз", "ай", "ак", "ал", "ам", "ан", "ап", "ар", "ас", "ат", "ау", "аф", "ах", "ац", "ач", "аш", "ащ", "ба", "бе", "би", "бл", "бо", "бр", "бу", "бы", "ва", "ве", "ви", "во", "вр", "ву", "вш", "вы", "вя", "га", "го", "да", "де", "др", "ду", "ды", "еб", "ев", "ег", "ед", "еж", "ез", "ей", "ек", "ел", "ем", "ен", "ер", "ес", "ет", "еф", "ех", "ец", "еч", "ещ", "ея", "жа", "за", "зе", "зи", "зл", "зм", "зу", "зы", "зя", "иа", "иб", "ив", "иг", "ид", "ие", "иж", "из", "ии", "ий", "ик", "ил", "им", "ин", "ио", "ип", "ир", "ис", "ит", "иф", "их", "иц", "ич", "иш", "ищ", "ию", "ия", "ка", "ке", "ки", "ко", "кс", "кт", "ку", "кэ", "кё", "ла", "лб", "лг", "лд", "ле", "лз", "ли", "лк", "лм", "лн", "ло", "лп", "лт", "лу", "лы", "ля", "лё", "ма", "мб", "ме", "мж", "ми", "мн", "мо", "мп", "мс", "мт", "му", "мф", "мы", "мэ", "мя", "на", "нг", "нд", "ни", "нк", "но", "нс", "нт", "нч", "нш", "ню", "нь", "ня", "об", "ов", "ог", "од", "ож", "оз", "ои", "ой", "ок", "ол", "ом", "он", "оп", "ор", "ос", "от", "ох", "оц", "оч", "оэ", "ою", "оя", "па", "пе", "пи", "по", "пу", "пы", "пэ", "ра", "рг", "ре", "ри", "рн", "рп", "рс", "рт", "ру", "рф", "рч", "рщ", "ры", "рю", "ря", "са", "се", "си", "ск", "сл", "см", "со", "сп", "ст", "су", "сы", "сю", "ся", "та", "тв", "те", "ти", "тл", "тм", "то", "тр", "тс", "ту", "тц", "тч", "ты", "тэ", "тю", "тя", "тё", "уа", "уб", "уг", "уд", "уж", "уз", "уй", "ук", "ул", "ум", "ун", "уп", "ур", "ус", "ут", "ух", "уч", "уш", "уя", "фт", "ха", "хв", "ца", "це", "цк", "цо", "цу", "цы", "ча", "чв", "че", "чи", "чо", "чу", "ша", "ши", "ща", "ще", "щи", "щу", "ыб", "ыв", "ыд", "ыж", "ык", "ыл", "ым", "ын", "ыр", "ыс", "ыт", "ыч", "ыш", "ыщ", "ье", "ьи", "ью", "ья", "ьё", "юв", "юг", "юд", "юз", "юй", "юк", "юм", "юн", "юп", "юр", "юс", "ют", "юф", "юх", "юц", "юч", "юш", "ющ", "яб", "яг", "яд", "яж", "яз", "як", "ял", "ям", "ян", "яп", "яр", "яс", "ят", "ях", "яч", "яш", "ящ", "яя", "ёб", "ём", "ёс"]
    ending = if noun.length >= 2 then noun[-2..] else "йй"
    unless ending in nounEndings
      return {found: no}

    match  = noun.match /(а|е|и|о|ы|я|ь)$/g
    rest   = if match then noun[..-2] else noun

    i = {}                      # personal inclines
    p = {}                      # plural inclines
    m = if match then match[0] else ""
    switch (m)
      when "а", "я"
        i.genitive       = [ if m is "а" then "#{rest}ы" else "#{rest}и" ]
        p.genitive       = [ "#{rest}", "#{rest}ов", "#{rest}ев", "#{rest}ей" ]

        i.dative         = [ "#{rest}и", "#{rest}е" ]
        p.dative         = [ "#{rest}ам", "#{rest}ям" ]

        i.accusative     = [ "#{rest}у", "#{rest}ю" ]
        p.accusative     = [ "#{rest}а", "#{rest}я", "#{rest}ы", "#{rest}и" ]

        i.instrumental   = [ "#{rest}ой", "#{rest}ою", "#{rest}ей", "#{rest}ею" ]
        p.instrumental   = [ "#{rest}ами", "#{rest}ями" ]

        i.prepositional  = ["#{rest}е", "#{rest}и" ]
        p.prepositional  = [ "#{rest}ах", "#{rest}ях" ]

      when "ы", "и"
        i =
          genitive      : null
          dative        : null
          accusative    : null
          instrumental  : null
          prepositional : null

        p.genitive       = [ "#{rest}", "#{rest}ей", "#{rest}ов", "#{rest}ев" ]
        p.dative         = [ "#{rest}ам", "#{rest}ям" ]
        p.accusative     = [ "#{rest}", "#{rest}и", "#{rest}ы", "#{rest}ей", "#{rest}а", "#{rest}я" ]
        p.instrumental   = [ "#{rest}ами", "#{rest}ями" ]
        p.prepositional  = [ "#{rest}ах", "#{rest}ях" ]

      when "о", "е"
        p =
          genitive      : null
          dative        : null
          accusative    : null
          instrumental  : null
          prepositional : null

        i.genitive       = [ "#{rest}а", "#{rest}я" ]
        i.dative         = [ "#{rest}у", "#{rest}ю" ]
        i.accusative     = [ noun ]
        i.instrumental   = [ "#{rest}ом", "#{rest}ем" ]
        i.prepositional  = [ "#{rest}и", "#{rest}е" ]
      when "ь"
        i =
          genetive      : ["#{rest}я", "#{rest}и"]
          dative        : ["#{rest}ю", "#{rest}и"]
          accusative    : [noun, "#{rest}я", "#{rest}ю"]
          instrumental  : ["#{rest}ём", "#{rest}ем", "#{noun}ю"]
          prepositional : ["#{rest}е", "#{rest}и"]
        p =
          genetive      : ["#{rest}ей"]
          dative        : ["#{rest}ям"]
          accusative    : ["#{rest}ей", noun]
          instrumental  : ["#{rest}ями"]
          prepositional : ["#{rest}ях"]
      when ""
        p =
          genitive      : null
          dative        : null
          accusative    : null
          instrumental  : null
          prepositional : null

        i.genitive       = [ "#{rest}а", "#{rest}я", "#{rest}и" ]
        i.dative         = [ "#{rest}у", "#{rest}ю", "#{rest}и" ]
        i.accusative     = [ noun ]
        i.instrumental   = [ "#{rest}ом", "#{rest}ем", "#{rest}ю" ]
        i.prepositional  = [ "#{rest}и", "#{rest}е" ]


    personal : i
    plural   : p
    found    : yes


  exports.analyseNoun = (noun) ->
    # suffixes:
    # ек, енк, енств, еньк, еств, ец, ечк, изн, ик, ин, инк, иц, ичк,
    # ишк, ищ, л, ность, овств, оньк, ость, от, отн, ств, ушк, чик, щик, ышк, юшк
    # +
    # есть, овн
    #
    # ends:
    # (null), а, е, ей, ем, ею, и, о, ой, ом, ою, у, ью, ю, я
    # +
    # ам, ям, ыми, ими, ов, ев, ей, ами, ями, ах, ях
    #
    noun       = noun.toLowerCase()
    wordEndRe  = /(енств|ность|овств|еньк|еств|есть|оньк|ость|енк|ечк|изн|инк|ичк|ишк|овн|отн|ств|ушк|чик|щик|ышк|юшк|ек|ец|ик|ин|иц|ищ|от|л|)(ей|ем|ею|ой|ом|ою|ью|а|е|и|о|у|ю|я|)$/g
    if wordEndRe.test noun
      endRe          = /(ами|ями|ам|ах|ей|ем|ём|ею|ой|ом|ою|ью|а|е|и|о|у|ю|я|)$/g
      end            = noun.match(endRe)[0]
      suffixes       = []
      rest           = if end.length > 0 then noun[...-(end.length)] else noun
      longestSuffix  = 0
      found          = yes

      for suff in "енств|ность|овств|еньк|еств| есть|оньк|ость|енк|ечк|изн|инк|ичк|ишк|овн|отн|ств|ушк|чик|щик|ышк|юшк|ек|ец|ик|ин|иц|ищ|от|л|".split "|"
        ind = rest.indexOf suff
        if ind > 2 and (ind + suff.length) is rest.length
          longestSuffix = suff.length if suff.length > longestSuffix
          suffixes.push suff

      console.log "end = #{end}"

      # end analysis
      # source http://rich62.ru/lib/misc/pravila.html
      switch end
        when "а", "я"
          infinitive  = [noun, rest, "#{rest}о", "#{rest}е"]
          cases       = ["nominative", "genitive"]
        when "ы"
          infinitive  = ["#{rest}а", noun]
          cases       = ["nominative", "genitive"]
        when "и"
          infinitive  = ["#{rest}я", "#{rest}о", "#{rest}е", rest, noun]
          cases       = ["nominative", "genitive", "dative", "accusative", "prepositional"]
        when "о"
          infinitive  = [noun]
          cases       = ["nominative", "accusative"]
        when "е"
          infinitive  = [noun, "#{rest}а"]
          cases       =  ["nominative", "dative", "accusative", "prepositional"]
        when "у"
          infinitive  = ["#{rest}а", "#{rest}е", "#{rest}ь"]
          cases       = ["dative", "accusative"]
        when "ю"
          infinitive  = ["#{rest}я", "#{rest}е", "#{rest}ь"]
          cases       = ["dative", "accusative"]
        when "ой", "ою"
          infinitive  = ["#{rest}а"]
          cases       = ["instrumental"]
        when "ею"
          infinitive  = ["#{rest}я"]
          cases       = ["instrumental"]
        when ""
          infinitive  = [noun, "#{rest}а", "#{rest}ы"]
          cases       = ["nominative", "genitive", "accusative"]
        when "ей"
          infinitive  = ["#{rest}и", "#{rest}я"]
          cases       = ["genitive", "accusative", "instrumental"]
        when "ам", "ям"
          infinitive  = ["#{rest}а", "#{rest}я", "#{rest}ы", "#{rest}и"]
          cases       = ["dative"]
        when "ами", "ями"
          infinitive  = ["#{rest}а", "#{rest}я", "#{rest}ы", "#{rest}и"]
          cases       = ["instrumental"]
        when "ах", "ях"
          infinitive  = ["#{rest}а", "#{rest}я", "#{rest}ы", "#{rest}и"]
          cases       = ["prepositional"]
        when "ом"
          infinitive  = [ rest]
          cases       = ["instrumental"]
        when "ем", "ём"
          infinitive  = ["#{rest}ь"]
          cases       = ["instrumental"]
        else
          found       = no
          infinitive  = []
          cases       = []

      infinitive = infinitive.map (n) -> n.replace /ьь/, "ь"

      rest = rest[...-longestSuffix] if longestSuffix > 0

      personalInfinitives  = []
      pluralInfinitives    = []

      console.log "infinitives = #{infinitive}"
      for inf in infinitive
        inclines = inclineNoun inf
        unless inclines.found
          continue
        console.log "inclines for [#{inf}]: #{JSON.stringify(inclines)}"
        for c in cases
          if inclines.personal[c]
#            console.log "personal inclines for [#{c} / #{inf}]: #{JSON.stringify(inclines.personal[c])}"
            for word in inclines.personal[c]
              personalInfinitives.push inf if word is noun  and not (inf in personalInfinitives)
          if inclines.plural[c]
#            console.log "plural inclines for [#{c} / #{inf}]: #{JSON.stringify(inclines.plural[c])}"

            for word in inclines.plural[c]
              pluralInfinitives.push inf if word is noun  and not (inf in pluralInfinitives)


      pi = []
      pluralInfinitives.map (inf) ->
        # ья - valid
        # <other>я - invalid
        end = inf[-2..]
        if "я" is end[1]
          if end in ["ья", "ля"]
            pi.push inf
        else
          pi.push inf

      found        : found
      infinitive   : personalInfinitives
      pluralInfinitive : pi
      infinitive0   : infinitive
      cases        : cases
      suffix       : suffixes
      end          : end
      rest         : rest
      probably     : end.length + suffixes.length
      prepositions :
        "nominative"    : null
        "genitive"      : "без,у,до,от,с,около,из,возле,после,для,вокруг".split ","
        "dative"        : "к,по".split ","
        "accusative"    : "в,за,на,про,через".split ","
        "instrumental"  : "за,над,под,перед,с".split ","
        "prepositional" : "в,на,о,об,обо,при".split ","
    else
      {found: no}

  ###
  Get inital form of adjective (мужской род, именительный падеж, единственное число)

  @param {String} adj Adjective word (or we suspect so)
  @return {Array|null} result Return multiple variants in array or null, if not found
  ###
  exports.getInitialFormOfAdjective = (adj) ->
    # masculine : ый, ий, его, ого, ему, ому, ым, им, ом
    # feminine  : ая, яя, ой, ей, ую, юю, ою
    # neuter    : ое, ее, ого, ому, ым, им, ом
    # plural    : ые, ие, ых, их, ым, им, ыми, ими
    # min length: 5 chars (ясный, голый, белый) 4 chars (ярый)

    value =
      found      : no
      src        : adj
      gender     : no
      plural     : no
      infinitive : no
      cases      : []

    adj = adj.toLowerCase()
    match = adj.match /^[а-яё]{2,}(ая|ее|ие|ий|им|ими|их|ого|его|ое|ой|ом|ому|ою|ую|ые|ый|ым|ыми|ых|юю|яя)$/
    unless match
      return value
    adjNoEnd = adj[...-(match[0].length)]

    if /(ые|ие|ых|их|ым|им|ыми|ими)$/.test adj
      value.plural = yes        # todo add cases

    # cases
    if /(ый|ий|ая|яя|ое|ее)$/.test adj
      value.cases = ["nominative"]

    # infinitive - nominative
    if adj[-2] in ["ий", "ый"]
      value.gender = "masculine"
      value.infinitive = adj
    else if adj[-2..] in ["ая", "яя"]
      value.infinitive = "#{adjNoEnd}#{adj[-2] is 'а' and 'ый' or 'ий'}"
      value.gender = "feminine"
    else if adj[-2..] in ["ое", "ее"]
      value.infinitive = "#{adjNoEnd}#{adj[-2] is 'о' and 'ый' or 'ий'}"
      value.gender = "neuter"
    else if adj[-2..] in ["ые", "ие"]
      value.infinitive = "#{adjNoEnd}#{adj[-2] is 'ы' and 'ый' or 'ий'}"

    # infinitive - genitive
    else if adj[-3..] in ["ого", "его"]
      value.gender = ["masculine", "neuter"]
      value.infinitive = "#{adjNoEnd}#{adj[-3] is 'о' and 'ый' or 'ий'}"
    else if adj[-2..] in ["ой", "ей"]
      value.gender = "feminine"
      value.infinitive = "#{adjNoEnd}#{adj[-2] is 'о' and 'ый' or 'ий'}"
    else if adj[-2..] in ["ых", "их"]
      value.infinitive = "#{adjNoEnd}#{adj[-2] is 'ы' and 'ый' or 'ий'}"

    # infinitive - dative
    else if adj[-3..] in ["ому", "ему"]
      value.gender = ["masculine", "neuter"]
      value.infinitive = "#{adjNoEnd}#{adj[-3] is 'о' and 'ый' or 'ий'}"
#     else if

# value.gender =
#       value.infinitive = "#{adj[..-3]}"
#     else

    if /^[а-яё]{2,}(ими|ого|его|ому|ыми)$/gi.test adj
      base = adj[..-4]
    else
      base = adj[..-3]
    ["#{base}ый", "#{base}ий", "#{base}ой"]

  ###
  Get verb infinitive

  @param {String} verb Verb in any form
  @return {Object} result If result.found is false, other fields, except src can be ommited.
          result.found      : verb found {true|false}
          result.src        : source strings
          result.person     : verb person {false|1|2|3}, false for infinitive
          result.time       : verb time {false|"past"|"present"}, false for infinitive
          result.plural     : verb plural {true|false}
          result.infinitive : verb infinirtive form {String|Array}, array if multiple
                              forms applyed, all forms in lover case
          result.reflexive  : verb in reflexive form {true|false}
  ###
  exports.getVerbInfinitive = (verb) ->
    value =
      found      : no
      src        : verb
      person     : no
      time       : no
      plural     : no
      infinitive : no
      reflexive  : no
    verb = verb.toLowerCase()

    # verbs with other incline:  хотеть, бежать, брезжить
    if /^[а-яё]{3,}(сь|ся)$/.test verb    # возвратные
      value.reflexive  = yes
      verbEnd          = "ся"
      verb             = verb[..-3]
    else
      verbEnd          = ""

    # past time
    pastTime = verb.match /^[а-яё]{3,}(л|ла|ло|ли)$/
    if pastTime
      value.time = "past"       # todo add person ??
      if /ли$/.test verb
        value.plural = yes
      value.found = yes
      value.infinitive = verb[..-(1+pastTime[1].length)] + "ть#{verbEnd}"
    else
      # exceptions verbs: брить, стелить, зиждиться, видеть, ненавидеть, обидеть, зависеть, терпеть, вертеть, смотреть, гнать, дышать, держать, слышать
      exceptVerbs = [
        ["брить", "брею", "бреешь", "бреет", "бреем", "бреете", "бреют"]
        ["стелить", "стелю", "стелишь", "стелит", "стелим", "стелите", "стелят"]
        ["зиждиться", "зиждюсь", "зиждишься", "зиждится", "зиждимся", "зиждитесь", "зиждются"]
        ["видеть", "вижу", "видишь", "видит", "видим", "видите", "видят"]
        ["ненавидеть", "ненавижу", "ненавидишь", "ненавидит", "ненавидим", "ненавидите", "ненавидят"]
        ["обидеть", "обижу", "обидишь", "обидит", "обидим", "обидите", "обидят"]
        ["зависеть", "завишу", "зависишь", "зависит", "зависим", "зависите", "зависят"]
        ["терпеть", "терплю", "терпишь", "терпит", "терпим", "терпите", "терпят"]
        ["вертеть", "верчу", "вертишь", "вертит", "вертим", "вертите", "вертят"]
        ["смотреть", "смотрю", "смотришь", "смотрит", "смотрим", "смотрите", "смотрят"]
        ["гнать", "гоню", "гонишь", "гонит", "гоним", "гоните", "гонят"]
        ["дышать", "дышу", "дышишь", "дышит", "дышим", "дышите", "дышат"]
        ["держать", "держу", "держишь", "держит", "держим", "держите", "держат"]
        ["слышать", "слышу", "слышишь", "слышит", "слышим", "слышите", "слышат"]
        ["быть", "есть", "есть", "есть", "есть", "есть", "есть"]
        ["дать", "дам", "дашь", "даст", "дадим", "дадите", "дадут"]
        ["создать", "создам", "создашь", "создаст", "создадим", "создадите", "создадут"]
        ["есть", "ем", "ешь", "ест", "едим", "едите", "едят"]
        ["хотеть", "хочу", "хочешь", "хочет", "хотим", "хотите", "хотят"]
        ["бежать", "бегу", "бежишь", "бежит", "бежим", "бежите", "бегут"]
        ["брезжить", "брезжу", "брезжишь", "брезжит", "брезжим", "брезжите", "брезжут"]
        ["чтить", "чту", "чтишь", "чтит", "чтим", "чтите", "чтят"]
        ]
      for verbs in exceptVerbs
        ind = verbs.indexOf verb
        if ind >= 0
          value.found       = yes
          value.infinitive  = verbs[0] + verbEnd
          value.time        = "present"
          value.plural      = ind > 3
          value.person      = 1 + (ind - 1) % 3
          return value

      if /^[а-яё]{3,}(ать|ить|еть|оть|оться|уть|утся|ются|ть|ться)$/.test verb # infinitive
        value.infinitive = verb
        value.found = yes
        return value

      value.found = yes
      value.time = "present"
      # present time
      # оть, -уть, -ть  ???
      if /[ую]$/.test verb      # I спр. 1-е лицо, ед. число
        value.infinitive = "#{verb[..-2]}ать"
        value.person = 1
      else if /ем$/.test verb      # I спр. 1-е лицо, мн. число
        value.infinitive = "#{verb[..-3]}ать"
        value.person = 1

      else if /(ешь|ете|ёте)$/.test verb # I спр. 2-е лицо, ед. и мн. число
        value.infinitive = "#{verb[..-4]}ать"
        value.person = 2
        value.plural = verb[-1] is "е"

      else if /(ишь|ите)$/.test verb  # II спр. 2-е лицо, ед. и мн. число
        value.infinitive = "#{verb[..-4]}ить"
        value.person = 2
        value.plural = verb[-1] is "е"

      else if verb[..-3] is "ет"      # I спр. 3-е лицо, ед. число
        value.infinitive = "#{verb[..-3]}ать"
        value.person = 3
        value.plural = no

      else if verb[..-3] is "ет"      # I спр. 3-е лицо, мн. число
        value.infinitive = "#{verb[..-3]}ать"
        value.person = 3
        value.plural = yes

      else if /(ит|ат|ят)$/.test verb # II спр. 2-е лицо, ед. и мн. число
        value.infinitive = "#{verb[..-4]}ить"
        value.person = 2
        value.plural = verb[-2] isnt "и"
      else
        value.found = no
        value.time = no

      # # todo remove verb conjugations at all?
      # if /[а-яё]{3,}(у|ю|ем|ешь|ете|ет|ут|ют|им|ишь|ите|ит|ат|ят)$/.test verb # невозвратные
      #   # II спряжение (I conjugation)
      #   # [у, ю,] ишь, ит, им, ите, ат, ят
      #   # ить, еть, ать
      #   if /[а-яё]{3,}(ишь|ит|им|ите|ат|ят)$/.test verb
      #     result = ["#{verb}ить#{verbEnd}", "#{verb}ать#{verbEnd}", "#{verb}еть#{verbEnd}"]
      #   else if /[а-яё]{3,}(у|ю|ешь|ет|ем|ете|ут|ют)$/.test verb
      #   # I спряжение (II conjugation)
      #   # у, ю, ешь, ет, ем, ете, ут, ют
      #   # ить, еть, ать, оть, уть, ть
      #     result = ["#{verb}ить#{verbEnd}", "#{verb}ать#{verbEnd}", "#{verb}еть#{verbEnd}", "#{verb}оть#{verbEnd}", "#{verb}уть#{verbEnd}", "#{verb}ть#{verbEnd}"]
    value

)(exports, util, ref)