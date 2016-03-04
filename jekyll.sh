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

# I know 0.0.0.0 would work, but this yields a clickable link in my terminal ;)
myip="$(ip route get 8.8.8.8 | sed -e '/src/!d' -e 's/^.*src\s*//' -e 's/\s*$//')"

bundle exec jekyll serve --watch --host "$myip" --destination "$(mktemp -d)"
