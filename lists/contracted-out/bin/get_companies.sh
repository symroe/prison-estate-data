#!/bin/sh

PATTERN=$(csvcut -c $1 $2 \
  | grep -v $1 \
  | tr '\n' '|' \
  | sed 's/|$//' \
  | sed 's/(/\\(/g'\
  | sed 's/)/\\)/g'\
)

grep -E "^($PATTERN)" ../../../company-data/cache/companies.tsv
