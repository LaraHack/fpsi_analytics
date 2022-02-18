#!/usr/bin/env bash

set -e

cat np-graph.head.dot > np-graph.dot

while read line; do
  query=${line% *}
  color=${line#* }
  cat sparql-results/$query.csv sparql-results/${query}_x.csv \
    | sed 1d \
    | sed -r 's/^"([^"]*)".*$/\1/' \
    | grep '^http://purl.org/np/' \
    | sort \
    | uniq \
    | awk -v color=$color '{print "\""substr($1,20,10)"\" [fillcolor="color",URL=\""$1"\"]"}' \
    >> np-graph.dot
  cat sparql-results/$query.csv sparql-results/${query}_x.csv \
    | sed 1d \
    | grep ',' \
    | sed -r 's/^"([^"]*)","([^"]*)".*$/\1 \2/' \
    | grep '^http://purl.org/np/.* http://purl.org/np/' \
    | sort \
    | uniq \
    | awk '{print "\""substr($2,20,10)"\" ->\""substr($1,20,10)"\" [color = red]"}' \
    >> np-graph.dot
done < node-map.txt

while read line; do
  query=${line% *}
  color=${line#* }
  cat sparql-results/$query.csv sparql-results/${query}_x.csv \
    | sed 1d \
    | sed -r 's/^"([^"]*)"."([^"]*)"$/\2/' \
    | grep '^http://purl.org/np/' \
    | sort \
    | uniq \
    | awk -v color=$color '{print "\""substr($1,20,10)"\" [fillcolor="color",URL=\""$1"\"]"}' \
    >> np-graph.dot
done < node-map-x.txt

while read line; do
  cat sparql-results/$line.csv sparql-results/${line}_x.csv \
    | sed -r 's/^"([^"]*)","([^"]*)".*$/\1 \2/' \
    | grep '^http://purl.org/np/.* http://purl.org/np/' \
    | sort \
    | uniq \
    | awk '{print "\""substr($1,20,10)"\" ->\""substr($2,20,10)"\""}' \
    >> np-graph.dot
done < edge-map.txt

cat np-graph.tail.dot >> np-graph.dot

mv np-graph.dot np-graph-pre.dot
cat np-graph-pre.dot | grep -v 'RAVYczMihU' > np-graph.dot
rm np-graph-pre.dot

dot -Tsvg np-graph.dot > np-graph.svg

convert np-graph.svg np-graph.pdf
