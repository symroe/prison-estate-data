
target: data/discovery/prison/prisons.tsv maps/address.tsv

../address-discovery-data-matching/maps/prison.tsv: Gemfile.lock
	bundle exec ruby ./lists/addresses/lib/address_street_postcode_data_map.rb > $@

../address-discovery-data/maps/prison.tsv: Gemfile.lock
	bundle exec ruby ./lists/addresses/lib/address_data_map.rb > $@

data/discovery/prison/prisons.tsv: Gemfile.lock
	bundle exec ruby ./lists/addresses/lib/prison_data.rb > $@

maps/address.tsv: ../address-discovery-data-matching/maps/prison.tsv
	mkdir -p maps
	csvcut -tc address,prison,name,name_cy ../address-discovery-data-matching/maps/prison.tsv \
	| csvformat -T \
	> $@

Gemfile.lock:
	bundle install

clean:
	rm -f data/discovery/prison/prisons.tsv
	rm -f ../address-discovery-data/maps/prison.tsv
