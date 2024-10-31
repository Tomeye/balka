#!/bin/sh

if [ -z "$1" ]
  then
    echo "please provide your listing (B0D9KZKYWX)"
    exit 0
fi

my_listing=$1

listings_directory="listings"

# delete file for all keywords if already exists
if [ -f "competitors_keywords_sorted" ]; then
  rm "competitors_keywords_sorted"
fi

# delete file for all keywords sorted if already exists
if [ -f "competitors_keywords" ]; then
  rm "competitors_keywords"
fi

# create file for all keywords 
touch "competitors_keywords"

for f in "$listings_directory"/*; do
  echo "$(basename $f)"

  touch "keywords_$(basename $f)"
  
  # product tile key words
  # TODO: replace , with new line, then later remove empty lines
  cat "$f" | grep -Eo "<span id=\"productTitle\".*(</span>|>)" | cut -d "<" -f2 | cut -d ">" -f2 | awk '{$1=$1;print}' | tr " " "\n" | tr "/" "\n" | grep -vwE "(&amp;|\|)" | tr -d ',' | tr A-Z a-z | sort >> "keywords_$(basename $f)"
   
  # bullets points
  cat "$f" | grep -A50 "feature-bullets" | grep -Eo "<span class=\"a-list-item\".*(</span>|>)" | awk '{$1=$1;print}' | tr " " "\n" | grep -vwE "(&amp;|-->|<\!--|</span></li>|</ul>|<li|<span|class=\"a-list-item\">)" | tr -d '】' | tr -d '.' | tr -d ',' | tr -d '【' | grep -vwE "(&amp;)" | tr A-Z a-z | sort >> "keywords_$(basename $f)"
   
  # first element of 
  if [ "$f" != "$listings_directory/$my_listing" ]
  then
    cat "keywords_$(basename $f)" >> "competitors_keywords"
    rm "keywords_$(basename $f)"
  fi
done

cat "competitors_keywords" | sort > "competitors_keywords_sorted"
rm competitors_keywords
