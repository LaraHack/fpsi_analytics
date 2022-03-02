# fpsi_analytics

This repository contains data and code (SPARQL queries and scripting) to extract the published formalization papers (in the form of nanopublications) from the nanopublication decentralized network. It also contains the scripts made for the automatic visualization of these nanopublications in the form of a graph (using GraphViz) and a script to create the index for these nanopublications.

The network visualization of the formalization papers is in the file *np-graph.svg* (and its corresponding *np-graph.pdf*), while the interactive version can be accessed on https://raw.githubusercontent.com/LaraHack/fpsi_analytics/main/np-graph.svg. The icons used as legend can be found in the *icons* directory.

The nanopublications retrieved following the SPARQL queries (the _*.rq_ files) and their results (see the sparql-results directory) are in the *nanopubs* folder. The script to generate the nanopublication index (published on http://purl.org/np/RAkLJW7vIsnKKJDf1iswdgtFPQSo3lEG_z8DhHfD7dofE) is *make-nanopub-index.sh*.

These formalization papers will be published in the IOS Press journal Data Science, in a special issue with formalization papers in late March 2022. 
