# Manually extracted using Tabula http://tabula.technology/ tool from PDF a
# list of the prisons and their resettlement providers - November 2016:
# https://www.gov.uk/government/publications/prisons-and-their-resettlement-providers
# https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/568912/2016-11-03_Breakdown_List_of_the_Prison_Estate_and_CPAs_for_Publication.pdf
# 
# The Prison Estate in England and Wales, including public and contracted prisons,
# NOMS Immigration Removal Centres operated on behalf of the Home Office and
# Secure Training Centre.
#

prison_estate.tsv: prison_estate_and_cpas.csv
	bundle exec ruby clean_up.rb | sed 's/^prison/name/' > prison_estate.tsv

clean:
	rm -f prison_estate.tsv

init:
	bundle install
