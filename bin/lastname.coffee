#!/usr/bin/env coffee
#
lastname = require "../lib/index"
sys = require "sys"

word = process.argv[2]
switch word
  when "help", undefined
    help = """
  USAGE:
    lastname Surname
    lastname Name Surname
    lastname Name MiddleName Surname
    lastname -f path/to/file

  pass -f flag for search persons in file, and valid path to file

  OR

  pass Surname, Name and MiddleName params in order to incline them.


  """
    console.log help
  when "-f"
    console.log  lastname.findInFile process.argv[3]
  else
    console.log "#{sys.inspect lastname.findProperName process.argv[2..]}"



