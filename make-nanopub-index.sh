#!/usr/bin/env bash

set -e

cat nanopubs/*.trig > all-nanopubs.trig
np mkindex -p -o nanopub-index.pre.trig \
  -c https://orcid.org/0000-0002-7114-6459 \
  -c https://orcid.org/0000-0002-1267-0234 \
  -t "Nanopublications for the special issue of formalization papers at the journal Data Science 2021/2022" \
  -d "This set includes the nanopublications of the submissions, auxiliary class definitions, reviews, responses, and decisions for the special issue at the journal Data Science by IOS Press." \
  all-nanopubs.trig
np sign -o nanopub-index.trig nanopub-index.pre.trig
rm all-nanopubs.trig nanopub-index.pre.trig
