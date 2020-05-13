serve:
	bundler exec jekyll serve --host=0.0.0.0 2>/dev/null 1>/dev/null
vserve:
	bundler exec jekyll serve --host=0.0.0.0
build:
	bundler exec jekyll build
wiki:
	cd ../wiki ; pwd ; git pull
	( cd ../wiki ; sh make.sh ) | tee _data/wiki.tsv
daily: wiki
	git add _data/wiki.tsv
	git add index.md
	git commit -m "daily update"
	git push
post:
	( echo "---" ; echo "layout: top-page" ; date +"date: %Y-%m-%d %H:%M:%S %z" ; echo "---" ) > .post
	echo -n "title: " ; mv .post `date +_posts/%Y-%m-%d-\`head -n 1\`.md`
	emacs `ls -1t _posts/* | head -n 1`
