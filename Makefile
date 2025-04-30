# Copyright 2012 Erlware, LLC. All Rights Reserved.
#
# This file is provided to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file
# except in compliance with the License.  You may obtain
# a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

ERLFLAGS= -pa $(CURDIR)/.eunit -pa $(CURDIR)/ebin -pa $(CURDIR)/deps/*/ebin

DEPS_PLT=$(CURDIR)/.deps_plt
DEPS=erts kernel stdlib

# =============================================================================
# Verify that the programs we need to run are installed on this system
# =============================================================================
ERL = $(shell which erl)

ifeq ($(ERL),)
$(error "Erlang not available on this system")
endif

REBAR = REBAR_GLOBAL_CONFIG_DIR=${HOME} REBAR_CACHE_DIR=${HOME}/.cache/rebar3 rebar3

ifeq ($(REBAR),)
$(error "Rebar not available on this system")
endif

APPS := $(shell \
  for d in apps/*; do \
    if [ -d "$$d/test" ] && find "$$d/test" -type f -name "*test*.erl" -print -quit | grep -q .; then \
      basename $$d; \
    fi; \
  done \
)

.PHONY: all compile doc clean lint format tree compile-test test dialyzer typer shell distclean pdf \
  update-deps clean-common-test-data rebuild

all: deps compile dialyzer test

# =============================================================================
# Rules to build the system
# =============================================================================

deps:
		$(REBAR) get-deps
		$(REBAR) compile

update-deps:
		$(REBAR) update-deps
		$(REBAR) compile

compile:
		$(REBAR) compile

compile-test:
		$(REBAR) as test compile

# Format the code (if you use the rebar3_format plugin)
lint:
		$(REBAR) lint

format:
		$(REBAR) fmt

tree:
		$(REBAR) tree 

build-release:
		$(REBAR) as prod tar

doc:
		$(REBAR) doc

test: compile-test
	ERL_LIBS=./_build/test/lib/ ./scripts/eunit_run.escript $(APPS) || true

$(DEPS_PLT):
		@echo Building local plt at $(DEPS_PLT)
		@echo
		dialyzer --output_plt $(DEPS_PLT) --build_plt \
		   --apps $(DEPS) -r apps

dialyzer: $(DEPS_PLT)
		dialyzer --fullpath --plt $(DEPS_PLT) -Wrace_conditions --src -r ./apps

typer:
		typer --plt $(DEPS_PLT) -r ./src

shell: 
# You often want *rebuilt* rebar tests to be available to the
# shell you have to call eunit (to get the tests
# rebuilt). However, eunit runs the tests, which probably
# fails (thats probably why You want them in the shell). This
# runs eunit but tells make to ignore the result.
		$(REBAR) as test shell

pdf:
		pandoc README.md -o README.pdf

clean:
		- rm -rf $(CURDIR)/_build
		$(REBAR) clean

distclean: clean
		- rm -rf $(DEPS_PLT)
		- rm -rvf $(CURDIR)/deps

rebuild: distclean deps compile escript dialyzer test

