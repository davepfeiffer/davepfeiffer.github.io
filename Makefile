
SRC=./src
BIN=./articles
$(BIN)/The_Kettle_In_Regard_To_The_Pot.html: $(SRC)/The_Kettle_In_Regard_To_The_Pot.md
	 pandoc -s -t html5 --output $@ --css ../article.css $<

all:  $(BIN)/The_Kettle_In_Regard_To_The_Pot.html
