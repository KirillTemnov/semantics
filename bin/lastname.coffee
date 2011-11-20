#!/usr/bin/env coffee
#
lastname  = require "../lib/index"
sys       = require "util"

word      = process.argv[2]
switch word
  when "help", undefined
    help = """
  USAGE:
    lastname Surname
    lastname Name Surname
    lastname Name MiddleName Surname
    lastname [-i]  words
    lastname [-v|--version]
    lastname option path/to/file

  Options:
    -v, --version    - show version

    -f               - search persons in text file. Path to file must be set.

    -a               - analyse text file.

    -i               - incline words, (must be 2-5 words)
  """
    console.log help
  when "-v", "--version"
    console.log "lastname #{lastname.version}"
  when "-f"
    console.log  lastname.findInFile process.argv[3]
  when "-i"
        # unless result.found       # todo get rid of this message
        #   console.log "not found((, name? \n#{sys.inspect inclineName listOfWords[0]}"

    console.log  lastname.inclineWords process.argv[3..]
  when "-a"
    console.log lastname.analyseFile process.argv[3], all: yes
  else
    console.log "#{sys.inspect lastname.findProperName process.argv[2..]}"



