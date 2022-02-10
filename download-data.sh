#!/usr/bin/env bash

set -e

for f in get-*.rq ; do
  q=${f%.rq}
  r=${q#get-}
  echo "Retrieving $r..."
  wget -O sparql-results/$r.csv http://grlc.io/api-git/LaraHack/fpsi_analytics/get-$r.csv
done
