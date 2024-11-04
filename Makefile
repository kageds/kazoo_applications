# Makefile for an Erlang project using rebar3

# Variables
REBAR = REBAR_GLOBAL_CONFIG_DIR=${HOME} REBAR_CACHE_DIR=${HOME}/.cache/rebar3 ./rebar3

# Default target
all: compile

# Compile the project
compile:
	$(REBAR) compile

# Clean build artifacts
clean:
	$(REBAR) clean

# Run tests
test:
	$(REBAR) eunit
	$(REBAR) ct

# Run the project in an Erlang shell
shell:
	$(REBAR) shell

# Run dialyzer for static analysis
dialyzer:
	$(REBAR) dialyzer

# Format the code (if you use the rebar3_format plugin)
format:
	$(REBAR) fmt

# Build a release
release:
	$(REBAR) release

# Run the release
run_release:
	_build/default/rel/$(shell basename `pwd`)/bin/$(shell basename `pwd`) start

# Stop the release
stop_release:
	_build/default/rel/$(shell basename `pwd`)/bin/$(shell basename `pwd`) stop

# Clean, compile, and run tests in one command
rebuild: clean compile test

# Phony targets to avoid filename conflicts
.PHONY: all compile clean test shell dialyzer format release run_release stop_release rebuild

