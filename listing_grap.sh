#!/bin/sh

IFS=$'\n' read -d '' -r -a lines < config/listings

mkdir -p listings

for i in "${lines[@]}"
do
    if [ -f "listings/$i" ]; 
    then
        echo "file $i exists. do not download. I added this check because i get throttled all the time by amazon. I should implement force download flag."
    else
        # download listing content
        curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36
" -L https://www.amazon.de/dp/$i --compressed > "listings/$i"
        echo "created listings/$i"
    fi
done