##
## Environment Setup:
##
## (Note: bin/institute_makefile.py specifies similar variables seperatly)
##

include makefile.docs
-include build/makefile.projects

BUILD_DIR = build
PROJECTS_DIR = ~/projects
PUBLISH_DIR = $(PROJECTS_DIR)/output
SPHINX_TYPE = dirhtml


##
## Makefile boilerplate
##

.PHONY: push deploy setup clean rebuild clean-all help
.DEFAULT_GOAL = help
makefile.projects:bin/institute_makefile.py
	python $<

help:
	@echo "Use the following targets to build and deploy the Cyborg Institute:"
	@echo ""
	@echo "    rebuild  - rebuild all institute sites."
	@echo "    stage    - stage a deployments of the Institute content."
	@echo "    push     - move all updated content to the production environment."
	@echo "    themes   - reimport themes to all Institute projects (as needed.)"
	@echo ""
	@echo "    clean          - remove $(BUILD_DIR)/ and its contents"
	@echo "	   clean-stage    - remove $(PUBLISH_DIR)/ and its contents"
	@echo "    clean-all      - remove $(PUBLISH_DIR)/ and build directories for"
	@echo "                     all institute sphinx projects"
	@echo "    clean-theme    - remove theme files for all institute projects"
	@echo ""
	@echo "Note: all default Sphinx targets are avalible."
	@echo ""

##
## Setup and dependency establishment
##

setup:$(PROJECTS_DIR)/output/issues $(BUILD_DIR) makefile.projects

$(PROJECTS_DIR)/output/:makefile.projects
	mkdir -p $@
$(PROJECTS_DIR)/output/issues:
	mkdir -p $@
$(BUILD_DIR):
	mkdir $@

##
## Meta-worker targets for building and migration
##

push:themes stage
	rsync -arz $(PUBLISH_DIR)/ institute@foucault.cyborginstitute.net:/home/institute/public
push-stage:themes stage
	rsync -arz $(PUBLISH_DIR)/ institute@foucault.cyborginstitute.net:/home/institute/staging

##
## Force Rebuilders
##

clean:
	-rm -rf $(BUILD_DIR)/*
	-rm -rf makefile.projects
clean-stage:
	-rm -rf $(PUBLISH_DIR)/*
