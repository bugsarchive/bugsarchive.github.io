#!/bin/bash

start=$PWD
rm -rf md proc build || echo "Files already absent"

# clone the md repo so we have the articles
git clone https://github.com/bugsarchive/md
cd md

# remove license as its not necessary for rendering our files
rm LICENSE

# create these directories if they don't exist
[ ! -d ../proc ] && mkdir ../proc
[ ! -d ../build ] && mkdir ../build

# loop over every directory in md/
for dir in */
do
	# get the category name
	dir=${dir%*/}
	category="${dir##*/}"

	# start the list for the category and append to ../proc/posts.html (a temporary file)
	catstart="<ul class='grid grid-cols-1 text-wrap sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-x-12'>" 
	echo "<h3>$category</h3>$catstart" >> ../proc/posts.html

	# create a directory for the category in the build directory (which is what will be served) for navigation
	mkdir "$start/build/$category"
	cat "$start/src/cattop.html" > "$start/build/$category/index.html"

	# cd into the category so we can start rendering and linking the articles
	cd "${dir##*/}"

	# append rendered main.md to {category}/index.html and get rid of the file
	if [ -e "main.md" ]; then
		echo "main.md exists"
		$start/node_modules/.bin/md2html "$PWD/main.md" >> "$start/build/$category/index.html"
		rm main.md
	fi

	# create a list of articles in {category}/index.html
	echo "<h2>Articles</h2>$catstart" >> "$start/build/$category/index.html"	

	# replace any text that says CATEGORY with the name of the category, and the Browse Articles heading with the category name
	sed -i "s/CATEGORY/$category/" "$start/build/$category/index.html"
	sed -i "s/Browse Articles/$category/" "$start/build/$category/index.html"

	# loop over every article in the category
	for filepath in *md
	do
		file="${filepath%*.md}"
		
		# create the post's html page with the top from the template
		cat "$start/src/posttop.html" > "$start/build/$category/${file##*/}.html"
		# replace the text POST with the article's name, this is for metadata
		sed -i "s/POST/${file##*/}/" "$start/build/$category/${file##*/}.html"
		# render the md as html and append to the {category}/{post}.html
		$start/node_modules/.bin/md2html "$PWD/${filepath##*/}" >> "$start/build/$category/${file##*/}.html"
		# end {post}.html with the template's bottom part
		cat "$start/src/postbtm.html" >> "$start/build/$category/${file##*/}.html"

		# add the link to the post to proc/posts.html (to be inserted into the main homepage), and into the {category}/index.html
		echo "<li><a href='/$category/${file##*/}.html'>${file##*/}</a></li>" >> ../../proc/posts.html
		echo "<li><a href='/$category/${file##*/}.html'>${file##*/}</a></li>" >> "$start/build/$category/index.html"
	done

	# add closing tags to {category}/index.html and to proc/posts.html
	echo "</ul>" >> "$start/build/$category/index.html"
	cat "$start/src/catbtm.html" >> "$start/build/$category/index.html"
	echo "</ul>" >> ../../proc/posts.html
	cd -
done

cd $start

# create our homepage index.html by combining top.html, proc/posts.html and btm.html
cat src/top.html > build/index.html
cat proc/posts.html >> build/index.html
cat src/btm.html >> build/index.html

# serve CNAME file
echo "bugs.lewoof.xyz" > build/CNAME

# im cute
yarn prettier -w build/*html
