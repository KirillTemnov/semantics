###
English language words
###

if "undefined" is typeof global
  window.semantics                  ||= {}
  window.semantics.plugins          ||= {}
  window.semantics.plugins.en       ||= {}
  window.semantics.plugins.en.words   = {}
  exports                            = window.semantics.plugins.en.words
  util                               = window.semantics.util
else
  exports                            = module.exports
  util                               = require "../../util"

((exports, util) ->

  exports.regWords = regWords = "the,of,and,to,a,in,is,that,was,it,for,on,with,he,be,I,by,as,at,you,are,his,had,not,this,have,from,but,which,she,they,or,an,her,were,there,we,their,been,has,will,one,all,would,can,if,who,more,when,said,do,what,about,its,so,up,into,no,him,some,could,them,only,time,out,my,two,other,then,may,over,also,new,like,these,me,after,first,your,did,now,any,people,than,should,very,most,see,where,just,make,between,back,way,many,year,being,our,how,work,us,get,come,think,go,take,tell,use,sir,thing,shall,same,such,much,find,here,each,again,still,old,little,state,present,against,know,under,before,above,place,part,through,across,although,upon,though".split ","

  exports.stopWords = stopWords = "a's,able,about,above,according,accordingly,across,actually,after,afterwards,again,against,ain't,all,allow,allows,almost,alone,along,already,also,although,always,am,among,amongst,an,and,another,any,anybody,anyhow,anyone,anything,anyway,anyways,anywhere,apart,appear,appreciate,appropriate,are,aren't,around,as,aside,ask,asking,associated,at,available,away,awfully,be,became,because,become,becomes,becoming,been,before,beforehand,behind,being,believe,below,beside,besides,best,better,between,beyond,both,brief,but,by,c'mon,c's,came,can,can't,cannot,cant,cause,causes,certain,certainly,changes,clearly,co,com,come,comes,concerning,consequently,consider,considering,contain,containing,contains,corresponding,could,couldn't,course,currently,definitely,described,despite,did,didn't,different,do,does,doesn't,doing,don't,done,down,downwards,during,each,edu,eg,eight,either,else,elsewhere,enough,entirely,especially,et,etc,even,ever,every,everybody,everyone,everything,everywhere,ex,exactly,example,except,far,few,fifth,first,five,followed,following,follows,for,former,formerly,forth,four,from,further,furthermore,get,gets,getting,given,gives,go,goes,going,gone,got,gotten,greetings,had,hadn't,happens,hardly,has,hasn't,have,haven't,having,he,he's,hello,help,hence,her,here,here's,hereafter,hereby,herein,hereupon,hers,herself,hi,him,himself,his,hither,hopefully,how,howbeit,however,i'd,i'll,i'm,i've,ie,if,ignored,immediate,in,inasmuch,inc,indeed,indicate,indicated,indicates,inner,insofar,instead,into,inward,is,isn't,it,it'd,it'll,it's,its,itself,just,keep,keeps,kept,know,knows,known,last,lately,later,latter,latterly,least,less,lest,let,let's,like,liked,likely,little,look,looking,looks,ltd,mainly,many,may,maybe,me,mean,meanwhile,merely,might,more,moreover,most,mostly,much,must,my,myself,name,namely,nd,near,nearly,necessary,need,needs,neither,never,nevertheless,new,next,nine,no,nobody,non,none,noone,nor,normally,not,nothing,novel,now,nowhere,obviously,of,off,often,oh,ok,okay,old,on,once,one,ones,only,onto,or,other,others,otherwise,ought,our,ours,ourselves,out,outside,over,overall,own,particular,particularly,per,perhaps,placed,please,plus,possible,presumably,probably,provides,que,quite,qv,rather,rd,re,really,reasonably,regarding,regardless,regards,relatively,respectively,right,said,same,saw,say,saying,says,second,secondly,see,seeing,seem,seemed,seeming,seems,seen,self,selves,sensible,sent,serious,seriously,seven,several,shall,she,should,shouldn't,since,six,so,some,somebody,somehow,someone,something,sometime,sometimes,somewhat,somewhere,soon,sorry,specified,specify,specifying,still,sub,such,sup,sure,t's,take,taken,tell,tends,th,than,thank,thanks,thanx,that,that's,thats,the,their,theirs,them,themselves,then,thence,there,there's,thereafter,thereby,therefore,therein,theres,thereupon,these,they,they'd,they'll,they're,they've,think,third,this,thorough,thoroughly,those,though,three,through,throughout,thru,thus,to,together,too,took,toward,towards,tried,tries,truly,try,trying,twice,two,un,under,unfortunately,unless,unlikely,until,unto,up,upon,us,use,used,useful,uses,using,usually,value,various,very,via,viz,vs,want,wants,was,wasn't,way,we,we'd,we'll,we're,we've,welcome,well,went,were,weren't,what,what's,whatever,when,whence,whenever,where,where's,whereafter,whereas,whereby,wherein,whereupon,wherever,whether,which,while,whither,who,who's,whoever,whole,whom,whose,why,will,willing,wish,with,within,without,won't,wonder,would,wouldn't,yes,yet,you,you'd,you'll,you're,you've,your,yours,yourself,yourselves,zero,a,dear,i,tis,twas,amoungst,amount,back,bill,bottom,call,computer,con,couldnt,cry,de,describe,detail,due,eleven,empty,fifteen,fify,fill,find,fire,forty,found,front,full,give,hasnt,herse”,himse”,hundred,interest,itse”,made,mill,mine,move,myse”,part,put,show,side,sincere,sixty,system,ten,thick,thin,top,twelve,twenty".split ","

  ###
  Extract english words.
  Update result.counter.stop_words_total (incremental) and result.counter.stop_words_persent.

  @param {String} text Source text
  @param {Object} result Resulting object, that contain fields:
                 en.words      : Dict of english words and count of occurrences for each
                 en.reg_words  : Dict of english immutable words and count of occurrences
                 en.stop_words : Dict of english stop words and count of occurrences
  @param {Object} opts Options, :default {}
                 opts.replaceStopWords : Replace stop words with new array, :default false
                 opts.stopWords        : Array of stop words, :default []
  ###
  exports.preFilter = (text, result, opts={}) ->
    result.en    ||= {}
    words          = []
    reg_words      = []
    stop_words     = []

    if opts.replaceStopWords
      swArray  = opts.stopWords || []
    else
      swArray  = util.merge stopWords, opts.stopWords || []
    for s in result.misc.sentences || []
      reduce   = s.toLowerCase().split(" ").filter (wrd) ->  /^[-\.\d]{0,}[a-z]+[\-\.\da-z]{0,}$/ig.test(wrd)
      for w in reduce
        if w in swArray
          stop_words.push w
        else if w in regWords
          reg_words.push w
        else
          words.push w
    result.en.words       = util.arrayToDict words
    result.en.reg_words   = util.arrayToDict reg_words
    result.en.stop_words  = util.arrayToDict stop_words


    result.counters.stop_words_total ||= 0
    result.counters.stop_words_total  += stop_words.length
    result.counters.stop_words_persent = result.counters.stop_words_total / result.counters.words_total




)(exports, util)
