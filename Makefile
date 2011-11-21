.PHONY: client server

client:
	coffee -b -c lib/plugins/ru
	coffee -b -c lib/client.coffee 
	coffee -b -c lib/util.coffee 
	coffee -b -c lib/counters.coffee
	coffee -b -c lib/misc.coffee
	coffee -b -c lib/analysis.coffee
	cat lib/*.js >> out.js

	cat lib/plugins/ru/ref.js  >> out.js
	cat lib/plugins/ru/words.js  >> out.js
	cat lib/plugins/ru/dates.js  >> out.js
	cat lib/plugins/ru/inclines.js  >> out.js
	cat lib/plugins/ru/morpho.js  >> out.js
	cat lib/plugins/ru/propernames.js  >> out.js

	rm -f lib/plugins/ru/*.js
	rm -f lib/*.js
	uglifyjs -nm -b -i 2 out.js > browser/lastname.js
	rm out.js


server:
	coffee -b -c lib/*.coffee
	coffee -b -c lib/plugins/ru/*.coffee
