

((semantics) ->

  semantics.findProperName = (lang, args...) ->
    inclines = semantics["plugins"]["#{lang}"]["inclines"]
    inclines.findProperName.apply @, args

)(window.semantics ||= {})
