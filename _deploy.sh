#!/usr/bin/env bash

set -e

Rscript create_markdowns.R
mkdocs gh-deploy
rm -f docs/*.md