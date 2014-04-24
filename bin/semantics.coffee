#!/usr/bin/env coffee
#
semantics  = require "../lib/index"
sys        = require "util"
_          = require "underscore"


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
    semantics [-v|--version]
    semantics option path/to/file

  Options:

    -a                 - analyse text file.  Path to file must be set.

    -s                 - sentences

    -t                 - shorten text

    -f                 - analyse and filter output (after file name may be keywords)
       -b, --abbrevs      - abbrevs
       -c, --contacts     - contacts
       -p, --peoples      - peoples
       -d, --dates        - dates        
       -n, --proper-names - proper names
       -m, --money        - money
       -S, --stat         - statistics

  """
    console.log help
  when "-v", "--version"
    console.log "semantics #{semantics.version}"
  when "-a"
    opts = all: yes, r: no
    if process.argv[3][0] is "-" # recursive
      opts.r = parseInt process.argv[3][1..]
      fname = process.argv[4]
    else
      fname = process.argv[3]
    console.log sys.inspect semantics.analyseFile(fname, opts), yes, null
  when "-t", "-s"
    opts = all: yes, r: no
    fname = process.argv[3]
    data = semantics.analyseFile fname, opts
    if word is "-s"
      console.log "#{JSON.stringify data.misc.sentences, null, 2}"
    else
      console.log "#{printKeys data.meaning}"
      console.log "#{data.meaning.shorten_text.join '\n'}"
  when "-f"
    cmd_line_opts  = process.argv[3..]
    search_words   = []
    fname          = null
    opts           = {}
  
    found_opts = no
    while cmd_line_opts.length > 0
      o = cmd_line_opts.shift()
      if o[0] is "-"            # option
        switch o
          when "-c", "--contacts"
            found_opts         = yes
            opts.contacts      = yes
          when "-p", "--peoples"
            found_opts         = yes
            opts.peoples       = yes
          when "-d", "--dates"
            found_opts         = yes
            opts.dates         = yes
          when "-m", "--money"
            found_opts         = yes
            opts.money         = yes
          when "-n", "--proper-names"
            found_opts         = yes
            opts.proper_names  = yes
          when "-b", "--abbrevs"
            found_opts         = yes
            opts.abbrevs       = yes
          when "-S", "--stat"
            found_opts         = yes
            opts.stat          = yes
      else if fname is null
        fname = o
      else
        search_words.push o
    unless found_opts
      opts.all = yes

    data = semantics.analyseFile fname, all: yes, r: no
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

    if opts.all or opts.abbrevs
      keys = _.keys(data.ru.abbrevs)
      if keys.length > 0
        console.log "# АББРЕВИАТУРЫ"
        console.log "#{keys.join '\n'}"
        console.log "________________________________________\n"



    if opts.all or opts.contacts
      keys = _.union _.keys(data.misc.phones), _.keys(data.misc.emails)
      if keys.length > 0
        console.log "# КОНТАКТЫ"
        console.log "#{keys.join '\n'}"
        console.log "________________________________________\n"



    #console.log "#{JSON.stringify data.misc, null, 2}"

    # persons
    if opts.all or opts.persons

      first_run = yes
      for n, p of data.ru.persons
        if first_run
          first_run = no
          console.log "# ЛЮДИ"
        gender = if "male" is p.gender then "муж" else "жен"
        console.log "#{p.first_name} #{p.middle_name} #{p.surname} [#{gender}] (#{p.count})"
      unless first_run
        console.log "________________________________________\n"  


    # console.log "#{printKeys data.meaning.collocations}"
    # collocations
    # for c in data.meaning.collocations
    #   console.log "#{c.forms[0].src.join ' '}"
    # console.log "#{  }"

    # proper names
    if opts.all or opts.proper_names
      if _.keys(data.meaning.proper_names).length > 0
        console.log "# ИМЕНА СОБСТВЕННЫЕ"
        for k,v of data.meaning.proper_names
          console.log "#{k[0].toUpperCase()}#{k[1..]}"
        console.log "________________________________________\n"  


    if (opts.all or opts.dates) and data.dates
      keys = _.keys data.dates
      if 0 < keys.length 
        console.log "# ДАТЫ"
        console.log "#{keys.join '\n'}"
        console.log "________________________________________\n"


    if (opts.all or opts.money) and (0 < data.ru.money.length)
      console.log "ДЕНЬГИ: \n#{data.ru.money.join '\n'}"
      console.log "________________________________________\n"

    if need_search
      for k,v of search_result
        delete search_result[k] if 0 is v
      console.log "# ПОИСК ПО СЛОВАМ: #{search_words}"
      console.log "________________________________________"
      console.log "#{JSON.stringify(search_result, null, 2)[1...-1]}"

    if opts.all or opts.stat
      console.log "# СТАТИСТИКА:"
      console.log "символов:\t#{data.counters.chars_total}"
      console.log "всего слов:\t#{data.counters.words_total}"
      console.log "слов (ru):\t#{words_total}"
      console.log "пробелов:\t#{data.counters.spaces_total}"
      console.log "стоп слов:\t#{stop_words_total} (#{(100 * stop_words_total / words_total).toFixed(2)}%)"
      console.log "время анализа:\t#{(data.time/1000).toFixed 2} сек."
    console.log "\n"


  else
    console.log sys.inspect semantics.plugins.ru.inclines.findProperName process.argv[2..]
    



