
SRC=./src
BIN=./articles
$(BIN)/Switch_Debouncing_August_2018.html: $(SRC)/Switch_Debouncing_August_2018.md
	 pandoc -s -t html5 --output $@ --css ../article.css $<

all:  $(BIN)/Switch_Debouncing_August_2018.html
