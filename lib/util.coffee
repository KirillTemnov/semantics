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
  ###
  Capitalize word.

  @param {String} s Source word
  @return  {String} result Capitalized word
  ###
  exports.capitalize = capitalize = (s) ->
    if s
      "#{s[0].toUpperCase()}#{s[1..].toLowerCase()}"


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
  Merge two arrays.

  @param {Array} arr1 First array
  @param {Array} arr2 Seconds array
  @return {Array} arr Array contain unique values from arr1 and arr2
  ###
  exports.merge = merge = (l1, l2) ->
    l = []
    l1.map (x) -> l.push x
    l2.map (x) -> l.push x
    unique l

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

)(exports)