#!/usr/bin/env coffee
#
semantics  = require "../lib/index"
sys       = require "util"


printKeys = (obj) ->
  ks = []
  for k,v of obj
    ks.push k
  console.log "ks = #{JSON.stringify ks, null, 2}"


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

    -a               - analyse text file.  Path to file must be set.

    -s               - shorten text

    -f               - analyse and filter output (after file name may be keywords)

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
  when "-s"
    opts = all: yes, r: no
    fname = process.argv[3]
    data = semantics.analyseFile fname, opts
    console.log "#{printKeys data.meaning}"
    console.log "#{data.meaning.shorten_text.join '\n'}"
  when "-f"
    opts = all: yes, r: no
    fname = process.argv[3]
    data = semantics.analyseFile fname, opts
    #console.log "#{printKeys data.ru.stop_words}"

    search_words = process.argv[4..]
    need_search = no
    search_result = {}
    if 0 < search_words.length 
      need_search = yes
      search_words.map (s) ->
        search_result[s] = 0

    stop_words_total = 0
    for wrd, count of data.ru.stop_words
      stop_words_total += count

    words_total = 0
    for wrd, count of data.ru.words
      words_total += count
      if need_search
        for sw in search_words
          if 0 <= wrd.toLowerCase().indexOf sw.toLowerCase()
            if wrd.toLowerCase() is sw.toLowerCase()
              search_result[sw]++
            else
              search_result[wrd] ||= 0
              search_result[wrd]++

    # phones + emails
    console.log "# ТЕЛЕФОНЫ\n #{JSON.stringify data.misc.phones, null, 2}"
    console.log "# ПОЧТА\n #{JSON.stringify data.misc.emails, null, 2}"



    # persons
    #console.log "#{JSON.stringify data.misc, null, 2}"
    first_run = yes
    for n, p of data.ru.persons
      if first_run
        first_run = no
      console.log "# ЛЮДИ"
      gender = if "male" is p.gender then "муж" else "жен"
      console.log "#{p.first_name} #{p.middle_name} #{p.surname} [#{gender}] : #{p.count}"
  
    #console.log "#{printKeys data.ru.persons}"

    # console.log "#{printKeys data.meaning.collocations}"
    # collocations
    # for c in data.meaning.collocations
    #   console.log "#{c.forms[0].src.join ' '}"
    # console.log "#{  }"
    #console.log "слов: #{data.meaning.wordsAnalysed}"
    # proper names
    console.log "# ИМЕНА СОБСТВЕННЫЕ"
    for k,v of data.meaning.proper_names
      console.log "#{k[0].toUpperCase()}#{k[1..]}"

    #console.log "#{JSON.stringify data.ru.words, null, 2}"
    if need_search
      for k,v of search_result
        delete search_result[k] if 0 is v
      console.log "# ПОИСК ПО СЛОВАМ: #{search_words}"
      console.log "search: #{JSON.stringify search_result, null, 2}"


  else
    console.log sys.inspect semantics.plugins.ru.inclines.findProperName process.argv[2..]
    




