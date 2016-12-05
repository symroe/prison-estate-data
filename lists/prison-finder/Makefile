
target: prison-address-text.tsv

prison-urls.tsv:
	curl -s https://www.justice.gov.uk/contacts/prison-finder \
	| awk '/all-prisons/ { show=1 } show; /\/select/ { show=0 }' \
	| grep option \
	| sed 's/<option value="//' \
	| sed 's/".*//' \
	| grep https \
	> $@
	
prison-cache: prison-urls.tsv
	@mkdir -p cache
	[[ -e cache/wymott ]] || \
	cd cache && cat ../prison-urls.tsv \
	| xargs -P4 -n 1 curl -s -S -O

bundle-install:
	[[ -e Gemfile.lock ]] || bundle install

prison-address-text.tsv: prison-cache bundle-install
	bundle exec ruby ./bin/scrape_address.rb > $@

clean:
	rm -f prison-address-text.tsv
