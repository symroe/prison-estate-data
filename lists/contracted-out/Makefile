# Scrape list of suppliers paid to operate prisons from
# National Offender Management Service (NOMS) spend over £25,000 data.
# https://www.gov.uk/government/publications/national-offender-management-service-spend-over-25000-2016
#
# Match to company numbers in data cache from company-data repo.

target: prisons.tsv

prisons.tsv: company-numbers.csv
	csvjoin -c supplier,name suppliers.csv company-numbers.csv \
	| csvcut -C name \
	| csvformat -T \
	> $@
	
company-numbers.csv: companies.csv
	(\
	echo "name,company" && \
	csvcut -tc 1,2 companies.csv \
	)\
	> $@

companies.csv: suppliers.csv
	[[ -e $@ ]] || ./bin/get_companies.sh supplier ./suppliers.csv > $@
	
suppliers.csv:
	(\
	curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/560005/noms-aug-2016.csv \
	&& curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/555425/noms-jul-2016.csv \
	&& curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/544987/noms-jun16.csv \
	&& curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/545023/noms-may16.csv \
	&& curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/526432/noms.csv \
	&& curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/520883/noms-spend-march-2016.csv \
	&& curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/510360/noms-feb16.csv \
	&& curl -s https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/503037/noms-jan-2016.csv \
	)\
	| iconv -f ISO-8859-1 -t UTF-8 \
	| csvgrep -c Description -m 'Prisons and detention centres operated by an external provider' \
	| csvcut -c "Expense Area",Supplier \
	| sed 's/^Expense Area,Supplier/name,supplier/' \
	| csvsort \
	| uniq \
	| sed 's/ LTD/ LIMITED/g' \
	| sed 's/ & / AND /g'\
	> $@
	
clean:
	rm -f suppliers.csv
	rm -f companies.csv
