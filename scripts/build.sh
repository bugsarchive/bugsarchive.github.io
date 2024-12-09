#!/bin/bash

start=$PWD
rm -rf md proc build || echo "Files already absent"
git clone https://github.com/bugsarchive/md
cd md
rm LICENSE

[ ! -d ../proc ] && mkdir ../proc
[ ! -d ../build ] && mkdir ../build

for dir in */
do
	dir=${dir%*/}
	category="${dir##*/}"

	catstart="<ul class='grid grid-cols-1 text-wrap sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-x-12'>" 
	echo "<h3>$category</h3>$catstart" >> ../proc/posts.html

	mkdir "$start/build/$category"
	cat "$start/src/cattop.html" > "$start/build/$category/index.html"

	cd "${dir##*/}"

	if [ -e "main.md" ]; then
		echo "main.md exists"
		$start/node_modules/.bin/md2html "$PWD/main.md" >> "$start/build/$category/index.html"
		rm main.md
	fi

	echo "<h2>Articles</h2>$catstart" >> "$start/build/$category/index.html"	
	cat "$start/src/catbtm.html" >> "$start/build/$category/index.html"

	for filepath in *md
	do
		file="${filepath%*.md}"
		cat "$start/src/posttop.html" > "$start/build/$category/${file##*/}.html"
		sed -i "s/Bugs Archive/${file##*/}/" "$start/build/$category/${file##*/}.html"
		$start/node_modules/.bin/md2html "$PWD/${filepath##*/}" >> "$start/build/$category/${file##*/}.html"
		cat "$start/src/postbtm.html" >> "$start/build/$category/${file##*/}.html"
		echo "<li><a href='$category/${file##*/}.html'>${file##*/}</a></li>" >> ../../proc/posts.html
		echo "<li><a href='$category/${file##*/}.html'>${file##*/}</a></li>" >> "$start/build/$category/index.html"
		sed -i "s/Bugs Archive/$category/" "$start/build/$category/index.html"
		sed -i "s/Browse Articles/$category/" "$start/build/$category/index.html"
	done
	echo "</ul>" >> "$start/build/$category/index.html"
	echo "</ul>" >> ../../proc/posts.html
	cd -
done

cd $start

cat src/top.html > build/index.html
cat proc/posts.html >> build/index.html
cat src/btm.html >> build/index.html
echo "bugs.lewoof.xyz" > build/CNAME

yarn prettier -w build/*html
