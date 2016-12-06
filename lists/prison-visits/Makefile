
target: prisons.tsv

prisons.tsv:
	( echo name && \
	curl -s https://www.prisonvisits.service.gov.uk/en/request \
	| awk '/prisoner_step_prison_id/ { show=1 } show; /\/select/ { show=0 }' \
	| grep option \
	| grep -v prisoner_step_prison_id \
	| sed 's/^<.*>\([^<]*\)<\/.*/\1/' \
	) \
	> $@
	
clean:
	rm -f prisons.tsv
