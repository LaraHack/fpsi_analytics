#!/usr/bin/env bash

set -e

mkdir -p nanopubs

while read line; do
  query=${line% *}
  echo "Reading file $query.csv..."
  cat sparql-results/$query.csv \
    | sed 1d \
    | sed -r 's/^"([^"]*)".*$/\1/' \
    | grep '^http://purl.org/np/' \
    | sort \
    | uniq \
    | sed -r 's/^(.*)$/>\&2 echo "Retrieving \1..."\nnp get \1/' \
    | bash \
    > nanopubs/$query.trig
done < color-map.txt

echo "Checking retrieved nanopubs"
echo

for f in nanopubs/*.trig; do
  echo $f
  np check $f
  echo
done
