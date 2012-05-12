BASEDIR=$(PWD)
BUILD=$(BASEDIR)/build
NODE_MODULES=$(BASEDIR)/node_modules
NODE_BIN=$(NODE_MODULES)/.bin
COFFEE=$(NODE_BIN)/coffee
LINT=$(NODE_BIN)/coffeelint
SERVER_SRC=$(shell find $(BASEDIR)/server -type f -name "*.coffee")

run-server: $(BUILD)/server.js | $(NODE_MODULES)
	node $<

$(BUILD)/server.js: $(SERVER_SRC) | $(NODE_MODULES) $(BUILD)
	$(LINT) $<
	$(COFFEE) -o $(BUILD) --compile $<

$(BUILD):
	mkdir -p $@

$(NODE_MODULES):
	npm install

clean-all: clean clean-modules

clean:
	rm -rf $(BUILD)

clean-modules:
	rm -rf $(NODE_MODULES)
