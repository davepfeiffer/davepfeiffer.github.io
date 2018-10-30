
SRC=./src
BIN=./articles
$(BIN)/2017-08-22-debounce.html: $(SRC)/2017-08-22-debounce.md
	 pandoc -s -t html5 --output $@ --css ../article.css $<

all:  $(BIN)/2017-08-22-debounce.html
