
ROOT=.
SRC=articles
BIN=pages

ART_STYLE= css/skinned.css

PAGES=
#!eop (end of pages)


#--{ General Rules }------------------------------------------------------------

# The index is the obvious root page to build
$(ROOT)/index.html: $(ROOT)/index.md
	pandoc --metadata title="David Pfeiffer" -s -t html5 \
	--output index.html --css $(ART_STYLE) index.md

$(ROOT)/index.md: $(PAGES) $(ROOT)/index.template
	python generator/build_index.py $(ROOT)/index.template

clean:
	rm $(BIN)/*.html

.PHONY: publish
publish:
$(REM)/index.html: $(ROOT)/index.html $(RPAGES)
	cp $(ROOT)/index.html $(REM)/index.html

#--{ Page Rules }---------------------------------------------------------------
