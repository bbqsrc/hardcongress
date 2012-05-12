BASEDIR=$(PWD)
BUILD=$(BASEDIR)/build
NODE_MODULES=$(BASEDIR)/node_modules
NODE_BIN=$(NODE_MODULES)/.bin
COFFEE=$(NODE_BIN)/coffee
COFFEELINT=$(NODE_BIN)/coffeelint
UGLIFYJS=$(NODE_BIN)/uglifyjs
JSHINT=$(NODE_BIN)/jshint
CLIENT_SRC=$(shell find $(BASEDIR)/client/src -type f -name "*.coffee")
CLIENT_DEPS=$(NODE_MODULES)/backbone/node_modules/underscore/underscore.js \
						$(NODE_MODULES)/backbone/backbone.js \
						$(BASEDIR)/deps/jquery-1.7.2.js
SERVER_SRC=$(shell find $(BASEDIR)/server -type f -name "*.coffee")

build: $(BUILD)/server.js $(BUILD)/client.min.js $(BUILD)/app.html

watch:
	make -j2 watch-client watch-server

watch-client: $(BUILD)/client.js $(CLIENT_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEE) -j $< -cw $(subst $<,,$^)

watch-server: $(BUILD)/server.js $(SERVER_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEE) -j $< -cw $(subst $<,,$^)

$(BUILD)/app.html:
	cp $(BASEDIR)/client/app.html $@
	
$(BUILD)/client.min.js: $(CLIENT_DEPS) $(BUILD)/client.js
	$(JSHINT) $(BUILD)/client.js --config $(BASEDIR)/jshintrc-client.json
	rm -f $(BUILD)/client.cat.js
	cat $< | $(UGLIFYJS) --unsafe --lift-vars --no-copyright -o $@

$(BUILD)/client.js: $(CLIENT_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEELINT) $^
	$(COFFEE) -j $@ -c $^

$(BUILD)/server.js: $(SERVER_SRC) | $(NODE_MODULES) $(BUILD)
	$(COFFEELINT) $<
	$(COFFEE) -j $@ -c -b $<

$(BUILD):
	mkdir -p $@

$(NODE_MODULES):
	npm install

clean-all: clean clean-modules

clean:
	rm -rf $(BUILD)

clean-modules:
	rm -rf $(NODE_MODULES)
