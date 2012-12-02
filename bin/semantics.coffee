#!/usr/bin/env coffee
#
semantics  = require "../lib/index"
sys       = require "util"

word      = process.argv[2]
switch word
  when "help", undefined
    help = """
  USAGE:
    semantics Surname
    semantics Name Surname
    semantics Name MiddleName Surname
    semantics [-i]  words
    semantics [-v|--version]
    semantics option path/to/file

  Options:
    -v, --version    - show version

    -a               - analyse text file.  Path to file must be set.

    -i               - incline words, (must be 2-5 words)
  """
    console.log help
  when "-v", "--version"
    console.log "semantics #{semantics.version}"
  # when "-i"
  #   console.log  semantics.inclineWords process.argv[3..]
  when "-a"
    console.log sys.inspect semantics.analyseFile(process.argv[3], all: yes), yes, null
  else
    console.log sys.inspect semantics.plugins.ru.inclines.findProperName process.argv[2..]



