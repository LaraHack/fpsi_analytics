#!/usr/bin/env bash

set -e

cat np-graph.head.dot > np-graph.dot

while read line; do
  query=${line% *}
  color=${line#* }
  cat sparql-results/$query.csv \
    | sed 1d \
    | sed -r 's/^"([^"]*)".*$/\1/' \
    | grep 'http://purl.org/np/' \
    | sort \
    | uniq \
    | awk -v color=$color '{print "\""substr($1,20,10)"\" [fillcolor="color",URL=\""$1"\"]"}' \
    >> np-graph.dot
done < color-map.txt

ls sparql-results \
  | grep -- -to- \
  | awk '{print "cat sparql-results/"$1" | sed 1d"}' \
  | bash \
  | sed -r 's/^"([^"]*)","([^"]*)".*$/\1 \2/' \
  | grep '^http://purl.org/np/.* http://purl.org/np/' \
  | sort \
  | uniq \
  | awk '{print "\""substr($1,20,10)"\" ->\""substr($2,20,10)"\""}' \
  >> np-graph.dot

#ls sparql-results \
#  | grep -v -- -to- \
#  | awk '{print "cat sparql-results/"$1" | sed 1d"}' \
#  | bash \
#  | sed -r 's/^"([^"]*)","([^"]*)".*$/\1 \2/' \
#  | grep '^http://purl.org/np/.* http://purl.org/np/' \
#  | sort \
#  | uniq \
#  | awk '{print "\""substr($1,20,10)"\" ->\""substr($2,20,10)"\" [color = red]"}' \
#  >> np-graph.dot

cat np-graph.tail.dot >> np-graph.dot

dot -Tsvg np-graph.dot > np-graph.svg
