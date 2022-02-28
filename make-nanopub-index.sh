#!/usr/bin/env bash

set -e

cat nanopubs/*.trig > all-nanopubs.trig
np mkindex -p -o nanopub-index.pre.trig all-nanopubs.trig
np sign -o nanopub-index.trig nanopub-index.pre.trig
rm all-nanopubs.trig nanopub-index.pre.trig
