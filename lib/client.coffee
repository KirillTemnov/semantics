

((lastname) ->

  lastname.findProperName = (lang, args...) ->
    inclines = lastname["plugins"]["#{lang}"]["inclines"]
    inclines.findProperName.apply @, args

)(window.lastName ||= {})
