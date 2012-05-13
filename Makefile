BASEDIR=$(PWD)
BUILD=$(BASEDIR)/build
NODE_MODULES=$(BASEDIR)/node_modules
NODE_BIN=$(NODE_MODULES)/.bin
COFFEE=$(NODE_BIN)/coffee
COFFEELINT=$(NODE_BIN)/coffeelint
UGLIFYJS=$(NODE_BIN)/uglifyjs
JSHINT=$(NODE_BIN)/jshint
RECESS=$(NODE_BIN)/recess
CLIENT_SRC=$(shell find $(BASEDIR)/client/src -type f -name "*.coffee")
CLIENT_DEPS=$(BASEDIR)/deps/jquery-1.7.2.js \
			$(NODE_MODULES)/backbone/node_modules/underscore/underscore.js \
			$(NODE_MODULES)/backbone/backbone.js
SERVER_SRC=$(shell find $(BASEDIR)/server -type f -name "*.coffee")
CLIENT_LESS=$(shell find $(BASEDIR)/client/less -type f -name "*.less")
BOOTSTRAP_CSS=$(BASEDIR)/deps/bootstrap/docs/assets/css/bootstrap.css 

build: $(BUILD)/server.js $(BUILD)/client.min.js $(BOOTSTRAP_CSS) $(BUILD)/client.css $(BUILD)/app.html 

watch:
	make -j2 watch-client watch-server

watch-client: $(BUILD)/client.js $(CLIENT_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEE) -j $< -cw $(subst $<,,$^)

watch-server: $(BUILD)/server.js $(SERVER_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEE) -j $< -cw $(subst $<,,$^)

$(BUILD)/app.html:
	cp $(BASEDIR)/client/app.html $@
	
$(BUILD)/client.min.js: $(CLIENT_DEPS) $(BUILD)/client.js
	#cat $^ | $(UGLIFYJS) --unsafe --lift-vars --no-copyright -o $@
	cat $^ > $@

$(BOOTSTRAP_CSS):
	cd $(BASEDIR)/deps/bootstrap && make

$(BUILD)/client.css: $(CLIENT_LESS)
	$(RECESS) --compile $^ > $(BUILD)/less.css
	cat $(BUILD)/less.css $(BOOTSTRAP_CSS) > $@
	rm $(BUILD)/less.css

$(BUILD)/client.js: $(CLIENT_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEELINT) $^
	$(COFFEE) -j $@ -c $^

$(BUILD)/server.js: $(SERVER_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEELINT) $<
	$(COFFEE) -j $@ -c -b $^

$(BUILD):
	mkdir -p $@

$(NODE_MODULES):
	npm install

clean-all: clean clean-modules

clean:
	rm -rf $(BUILD)

clean-modules:
	rm -rf $(NODE_MODULES)
