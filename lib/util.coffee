###
Module with common functions.
###

if "undefined" is typeof global
    window.lastName ||= {}
    window.lastName.util ||= {}
    exports = window.lastName.util
else
    exports = module.exports

((exports) ->
  exports.version   = "0.3.119"

  ###
  Capitalize word.

  @param {String} s Source word
  @return  {String} result Capitalized word
  ###
  exports.capitalize = capitalize = (s) ->
    if s then "#{s[0].toUpperCase()}#{s[1..].toLowerCase()}"


  ###
  Get keys from dictionary.

  @param {Object} dict Dictonary object
  @return {Array} result Array of keys
  ###
  exports.dictKeys = dictKeys = (dict) ->
    keys = []
    keys.push k for k,v of dict
    keys


  ###
  Check if word capitalized. Word can contain several words, like "Петров-Водкин"

  @param {String} s Source word
  @return {Boolean} result Return true if word capitalized
  ###
  exports.isCapitalized = isCapitalized = (word) ->
    if 0 <= word.indexOf "-"
      cap = yes
      word.split("-").map (wrd) -> cap &&= isCapitalized wrd
      cap
    else
      word &&  word is capitalize(word) || no

  ###
  Check if word in upper case.

  @param {String} word Word for check
  @param {Boolean} result
  ###
  exports.isUpperCase = isUpperCase = (word) ->  word is word.toUpperCase()


  ###
  Check if word in lower case.

  @param {String} word Word for check
  @param {Boolean} result
  ###
  exports.isLowerCase = isLowerCase = (word) ->  word is word.toLowerCase()

  ###
  Remove duplicates from array.

  @param {Array} array Array that may contain duplicates
  @param {Array} newArray New array without duplicates
  ###
  exports.unique = unique = (array) ->
    output = {}
    output[array[key]] = array[key] for key in [0...array.length]
    value for key, value of output


  ###
  Merge several arrays. Accept any quantity of arrays as params.

  @return {Array} arr Array contain unique values from arr1 and arr2
  ###
  exports.merge = merge = (args...) ->
    l = []
    for arg in args || []
      arg.map (x) ->  l.push x
    l


  ###
  Merge several dicts: key from first dict replaced by key from second dict (if keys match)

  @return {Object} d Resulting object
  ###
  exports.mergeDicts = (args...) ->
    d = {}
    for dx in args || []
      for k,v of dx
        d[k] = v
    d

  ###
  Translate text to dict. Each key-value pair must be on new line.

  @example
  text = "foo\t123\nbar\t456"
  textToDict(text) # -> {"foo": "123", "bar": "456"}

  @param {String} text Text with keys and values
  @param {Object} opts Options for translation
                  opts.splitChar    : char or regexp for split key and value, :default /\s+/
                  opts.convertValue : Function for convert values, :default parseFloat
  ###
  exports.textToDict = (text, opts={}) ->
    splitChar = opts.splitChar || /\s+/
    convertValue = opts.convertValue || parseFloat
    d = {}
    for line in (text.split("\n").filter (x) -> !!x)
      splitedLine = line.trim().split splitChar
      if splitedLine.length > 1
        key = splitedLine[0].trim()
        val = splitedLine[1..].join " "
        value = convertValue val
        val = if !!value then value else val
        d[key] = val
    d

  ###
  Get first intersection of two arrays.

  @param {Array} arr1 First array
  @param {Array} arr2 Seconds array
  @return {Object|null} elem First element, that appear in arr1 and arr2
  ###
  exports.intersection = intersection = (l1, l2) ->
    for i in l1
      return i if i in l2
    null

  ###
  Translate array to dics with counters.

  @example
  a = [1,2,1,2,3]
  util.arrayToDict a
  # result:
  {1: 2, 2: 2, 3: 1}

  @param {Array} arr Array
  @return {Object} result
  ###
  exports.arrayToDict = (arr) ->
    d = {}
    for i in arr
      unless d[i]
        d[i] = 1
      else
        d[i]++
    d

  ###
  Get top of dictionary by analyse elements count (@see arrayToDict)

  @param {Object} obj Dictionary object
  @param {Number} maxNum Maximum number of elements
  @return {Object} result Return new dictionary, containing maxNum or less elements and counts.
  ###
  exports.topFromDict = (obj, maxNum=10) ->
    arr = []
    for k,v of obj
      arr.push [v, k]
    arr.sort (a, b) -> b[0] - a[0]
    result = {}
    for elem, i in arr
      break if i >= maxNum
      result[elem[1]] = elem[0]
    result

)(exports)