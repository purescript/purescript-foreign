all: lib test docs

lib:
	mkdir -p js/Data
	psc src/Data/JSON.purs \
	  -o js/Data/JSON.js \
	  -e js/Data/JSON.e.purs \
	  --module Data.JSON \
	  --tco --magic-do

test:
	mkdir -p js/test
  
	psc src/Data/JSON.purs examples\Applicative.purs \
	  -o js/test/Applicative.js \
	  --main Applicative \
	  --module Applicative \
	  --tco --magic-do
	node js/test/Applicative.js
  
	psc src/Data/JSON.purs examples\Complex.purs \
	  -o js/test/Complex.js \
	  --main Complex \
	  --module Complex \
	  --tco --magic-do
	node js/test/Complex.js
  
	psc src/Data/JSON.purs examples\JSONArrays.purs \
	  -o js/test/JSONArrays.js \
	  --main JSONArrays \
	  --module JSONArrays \
	  --tco --magic-do
	node js/test/JSONArrays.js
  
	psc src/Data/JSON.purs examples\JSONSimpleTypes.purs \
	  -o js/test/JSONSimpleTypes.js \
	  --main JSONSimpleTypes \
	  --module JSONSimpleTypes \
	  --tco --magic-do
	node js/test/JSONSimpleTypes.js
  
	psc src/Data/JSON.purs examples\MaybeNullable.purs \
	  -o js/test/MaybeNullable.js \
	  --main MaybeNullable \
	  --module MaybeNullable \
	  --tco --magic-do
	node js/test/MaybeNullable.js
  
	psc src/Data/JSON.purs examples\Objects.purs \
	  -o js/test/Objects.js \
	  --main Objects \
	  --module Objects \
	  --tco --magic-do
	node js/test/Objects.js
  
	psc src/Data/JSON.purs examples\ParseErrors.purs \
	  -o js/test/ParseErrors.js \
	  --main ParseErrors \
	  --module ParseErrors \
	  --tco --magic-do
	node js/test/ParseErrors.js

docs: src/Data/JSON.purs
	mkdir -p docs
	docgen src/Data/JSON.purs > docs/README.md
