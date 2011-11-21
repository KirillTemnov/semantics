

((lastname) ->
  lastname.version = "111"

#  lastname.inclineWords ...

  lastname.findProperName = (lang, args...) ->
    inclines = lastname["plugins"]["#{lang}"]["inclines"]
    inclines.findProperName.apply @, args

)(window.lastName ||= {})
