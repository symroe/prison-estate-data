
target: data/prison/prison.tsv \
	maps/contracted-out.tsv \
	maps/prison-finder.tsv \
	maps/nomis-code.tsv

lists/prison-estate/list.tsv: maps/prison-estate.tsv maps/designation-to-name-affix.tsv
	ruby ./lib/code_length_check.rb
	csvcut -tc name,designation,operator lists/prison-estate/prison_estate.tsv \
	| csvformat -T \
	> $@.tmp

	csvjoin -tc name $@.tmp maps/prison-estate.tsv \
	| csvcut -c prison,name,designation,operator \
	| csvformat -T \
	> $@.tmp2

	csvjoin -tc designation $@.tmp2 maps/designation-to-name-affix.tsv \
	| csvcut -c prison,prefix,name,suffix,designation,operator \
	| csvformat -T \
	> $@

	rm -f $@.tmp
	rm -f $@.tmp2

maps/prison-estate.tsv:
	# manually edited file

maps/designation-to-name-affix.tsv:
	# manually edited file

../address-discovery-data-matching/maps/prison.tsv: Gemfile.lock
	bundle exec ruby ./lists/addresses/lib/address_street_postcode_data_map.rb > $@

../address-discovery-data/maps/prison.tsv: ../address-discovery-data-matching/maps/prison.tsv
	bundle exec ruby ./lists/addresses/lib/address_data_map.rb > $@

data/prison/prison.tsv: Gemfile.lock lists/prison-estate/list.tsv
	bundle exec ruby ./lib/prison_data.rb > $@

maps/address.tsv: ../address-discovery-data-matching/lists/prison-data/list.tsv
	mkdir -p maps
	csvcut -tc 9,1,10,15 ../address-discovery-data-matching/lists/prison-data/list.tsv \
	| csvformat -T \
	> $@

maps/contracted-out.tsv:
	bundle exec ruby ./lists/addresses/lib/contracted_out_map.rb > $@

maps/nomis-code.tsv:
	bundle exec ruby ./lists/addresses/lib/nomis_code_map.rb > $@

maps/hmi.tsv:
	bundle exec ruby ./lists/addresses/lib/hmi_map.rb > $@

maps/prison-map-prison.tsv:
	bundle exec ruby ./lists/addresses/lib/prison_finder_map.rb > $@

maps/prison-finder.tsv:
	bundle exec ruby ./lists/addresses/lib/prison_finder.rb > $@

Gemfile.lock:
	bundle install

clean:
	rm -f data/prison/prison.tsv
	rm -f ../address-discovery-data-matching/maps/prison.tsv
	rm -f ../address-discovery-data/maps/prison.tsv
	rm -f lists/prison-estate/list.tsv
