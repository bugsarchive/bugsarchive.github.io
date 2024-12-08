#!/bin/bash

start=$PWD
cd md
git pull

[ ! -d ../proc ] && mkdir ../proc
[ ! -d ../build ] && mkdir ../build

for dir in ./*/
do
	dir=${dir%*/}
	category="${dir##*/}"

	echo "<h3>$category</h3><ul class='grid grid-cols-1 text-wrap sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-x-12'>" >> ../proc/posts.html

	mkdir "$start/build/$category"

	cd "${dir##*/}"

	for filepath in ./*md
	do
		file="${filepath%*.md}"
		echo "$PWD Running md2html $PWD/${filepath##*/}"
		cat "$start/src/posttop.html" > "$start/build/$category/${file##*/}.html"
		$start/node_modules/.bin/md2html "$PWD/${filepath##*/}" >> "$start/build/$category/${file##*/}.html"
		cat "$start/src/postbtm.html" >> "$start/build/$category/${file##*/}.html"
		echo "<li><a href='$category/${file##*/}.html'>${file##*/}</a></li>" >> ../../proc/posts.html
	done
	echo "</ul>" >> ../../proc/posts.html
	cd -
done

cd $start

cat src/top.html > build/index.html
cat proc/posts.html >> build/index.html
cat src/btm.html >> build/index.html

yarn prettier -w build/*
yarn prettier -w md/*
