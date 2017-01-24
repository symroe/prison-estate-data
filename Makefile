
target: data/discovery/prison/prisons.tsv ../address-discovery-data/maps/prison.tsv

../address-discovery-data-matching/maps/prison.tsv: Gemfile.lock
	bundle exec ruby ./lists/addresses/lib/address_street_postcode_data_map.rb > $@

../address-discovery-data/maps/prison.tsv: Gemfile.lock
	bundle exec ruby ./lists/addresses/lib/address_data_map.rb > $@

data/discovery/prison/prisons.tsv: Gemfile.lock
	bundle exec ruby ./lists/addresses/lib/prison_data.rb > $@

Gemfile.lock:
	bundle install

clean:
	rm -f data/discovery/prison/prisons.tsv
	rm -f ../address-discovery-data/maps/prison.tsv
