#!/usr/bin/env bash

set -e

cat np-graph.head.dot > np-graph.dot

while read line; do
  args=($(echo $line | tr ' ' '\n'))
  query=${args[0]}
  color=${args[1]}
  label=${args[2]}
  cat sparql-results/$query.csv sparql-results/${query}_x.csv \
    | sed 1d \
    | sed -r 's/^"([^"]*)".*$/\1/' \
    | grep '^http://purl.org/np/' \
    | sort \
    | uniq \
    | awk -v color=$color -v label=$label '{print "\""substr($1,20,10)"\" [fillcolor="color",label="label",URL=\""$1"\"]"}' \
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
  cat np-graph.head.dot > icons/$query.dot
  echo "\"node\" [fillcolor=\"$color\",label=\"$label\"]" >> icons/$query.dot
  cat np-graph.tail.dot >> icons/$query.dot
  dot -Tsvg icons/$query.dot > icons/$query.svg
  inkscape icons/$query.svg --export-pdf=icons/$query.pdf 2> /dev/null
  rm icons/$query.dot
done < node-map.txt

while read line; do
  args=($(echo $line | tr ' ' '\n'))
  query=${args[0]}
  color=${args[1]}
  label=${args[2]}
  cat sparql-results/$query.csv sparql-results/${query}_x.csv \
    | sed 1d \
    | sed -r 's/^"([^"]*)"."([^"]*)"$/\2/' \
    | grep '^http://purl.org/np/' \
    | sort \
    | uniq \
    | awk -v color=$color -v label=$label '{print "\""substr($1,20,10)"\" [fillcolor="color",label="label",URL=\""$1"\"]"}' \
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

inkscape np-graph.svg --export-pdf=np-graph.pdf 2> /dev/null
