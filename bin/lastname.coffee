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
    lastname [options] [path/to/file]

  Options:
    -v, --version    - show version

    -f               - search persons in text file. Path to file must be set.

  """
    console.log help
  when "-v", "--version"
    console.log "lastname #{lastname.version}"
  when "-f"
    console.log  lastname.findInFile process.argv[3]
  else
    console.log "#{sys.inspect lastname.findProperName process.argv[2..]}"



