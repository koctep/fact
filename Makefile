PROJECT = fact
PROJECT_DESCRIPTION = Calculate factorial
ERLANG_MK = erlang.mk

A = $(shell echo $(wildcard $(ELANG_MK)))
ifeq ($(shell ls $(ERLANG_MK)),)
%:
	curl https://erlang.mk/erlang.mk -o $(ERLANG_MK) $(CURL_OPTS)
	$(MAKE) -f $(ERLANG_MK) erlang-mk
	$(MAKE) $@
else
include erlang.mk
endif

force:
