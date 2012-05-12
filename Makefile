BASEDIR=$(PWD)
BUILD=$(BASEDIR)/build
NODE_MODULES=$(BASEDIR)/node_modules
NODE_BIN=$(NODE_MODULES)/.bin
COFFEE=$(NODE_BIN)/coffee
LINT=$(NODE_BIN)/coffeelint
CLIENT_SRC=$(shell find $(BASEDIR)/client/src -type f -name "*.coffee")
SERVER_SRC=$(shell find $(BASEDIR)/server -type f -name "*.coffee")

build: $(BUILD)/server.js $(BUILD)/client.js

$(BUILD)/client.js: $(CLIENT_SRC) | $(NODE_MODULES) $(BUILD)
	$(LINT) $^
	$(COFFEE) -j $@ -c $^

$(BUILD)/server.js: $(SERVER_SRC) | $(NODE_MODULES) $(BUILD)
	$(LINT) $<
	$(COFFEE) -j $@ -c $<

$(BUILD):
	mkdir -p $@

$(NODE_MODULES):
	npm install

clean-all: clean clean-modules

clean:
	rm -rf $(BUILD)

clean-modules:
	rm -rf $(NODE_MODULES)
