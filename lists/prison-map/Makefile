# Used Tabula to extract list of prison names from prison map 2016 PDF:
# https://www.justice.gov.uk/downloads/contacts/hmps/prison-finder/prison-map-2016.pdf
#
# Extracted to: ./tabula-prison-map-2016.csv

prisons.tsv: tabula-prison-map-2016.csv
	ruby clean_names.rb > prisons.tsv
