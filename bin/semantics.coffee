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
    opts = all: yes, r: no
    if process.argv[3][0] is "-" # recursive
      opts.r = parseInt process.argv[3][1..]
      fname = process.argv[4]
    else
      fname = process.argv[3]
    console.log sys.inspect semantics.analyseFile(fname, opts), yes, null
  else
    console.log sys.inspect semantics.plugins.ru.inclines.findProperName process.argv[2..]



