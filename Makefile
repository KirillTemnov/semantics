.PHONY: all client server clean

all: client server

client:
	coffee -b -c lib/plugins/ru
	coffee -b -c lib/client.coffee 
	coffee -b -c lib/util.coffee 
	coffee -b -c lib/mimimi.coffee 
	coffee -b -c lib/quotes.coffee
	coffee -b -c lib/misc.coffee
	coffee -b -c lib/analysis.coffee

	cat lib/client.js > out.js
	cat lib/util.js >> out.js
	cat lib/mimimi.js >> out.js
	cat lib/quotes.js  >> out.js
	cat lib/misc.js >> out.js
	cat lib/analysis.js >> out.js

	cat lib/plugins/ru/ref.js  >> out.js
	cat lib/plugins/ru/words.js  >> out.js
	cat lib/plugins/ru/dates.js  >> out.js
	cat lib/plugins/ru/abbrevs.js  >> out.js
	cat lib/plugins/ru/inclines.js  >> out.js
	cat lib/plugins/ru/twitter.js  >> out.js
	cat lib/plugins/ru/propernames.js  >> out.js
	cat lib/plugins/ru/feelings.js  >> out.js

	rm -f lib/plugins/ru/*.js
	rm -f lib/*.js
	mkdir -p release
	uglifyjs -nm -b -i 2 out.js > release/lastname.min.js
	mv out.js release/lastname.js

server:
	coffee -b -c lib/*.coffee
	coffee -b -c lib/plugins/ru/*.coffee

clean: 
	rm lib/plugins/ru/*.js
	rm lib/*.js
