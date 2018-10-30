#!/usr/bin/bash


ARTICLE_BASE=articles
SITE_BASE=dmpfeiffer.com
SRC=src
ALL="all: "

cp index.template index.md
cp Makefile.template Makefile

for ARTICLE in $(ls $SRC | grep -e "^[^_]")
do
  echo "* [${ARTICLE%.*}]($ARTICLE_BASE/${ARTICLE%.*}.html)" >> index.md
  printf "\$(BIN)/${ARTICLE%.*}.html: \$(SRC)/$ARTICLE\n" >> Makefile
  printf "\t pandoc -s -t html5 --output \$@ --css ../article.css \$<\n\n" >> Makefile
  ALL="${ALL} \$(BIN)/${ARTICLE%.*}.html"
done

echo "$ALL" >> Makefile

pandoc \
  -s -t html5 \
  --output index.html \
  --css article.css \
  index.md

make all
