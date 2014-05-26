#!/bin/bash
# jekyll.sh
# description: Start ghpages version of jekyll. Opts: -i to install, -u to update

cd "$(dirname $0)"
if [ -d _site ]; then
  rm -rf _site
fi

if [ "$1" == "-i" ]; then
  bundle install
elif [ "$1" == "-u" ]; then
  bundle update
fi
  
bundle exec jekyll serve --watch
