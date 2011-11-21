.PHONY: client server

client:
	rm out.js
	coffee -b -c lib/plugins/ru
	coffee -b -c lib/client.coffee 
	coffee -b -c lib/util.coffee 
	cat lib/*.js >> out.js
	cat lib/plugins/ru/*.js  >> out.js
	rm -f lib/plugins/ru/*.js
	rm -f lib/*.js
	uglifyjs -nm -b -i 2 out.js > browser/lastname.js


server:
	coffee -b -c lib/*.coffee
	coffee -b -c lib/plugins/ru/*.coffee
