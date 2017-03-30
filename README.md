# Prison register data

Data for an alpha prison register,
a list of parts of the Prison Estate in England and Wales, including public and contracted prisons, NOMS Immigration Removal Centres operated on behalf of the Home Office and Secure Training Centre.

| Data for register                | Active count | Closed count | Total distinct prison count |
| :---                             | :---:        | :---:        | :---:                       |
| [prison](data/prison/prison.tsv) | 121          | 30           | 151                         |


## Address Data
[address](maps/prison-address.tsv)


## What is a prison?

A prison in the data is an administrative prison. These are the prisons as
reported in the [prison annual performance ratings](https://www.gov.uk/government/statistics/prison-performance-statistics-2015-to-2016).

In some systems, for example NOMIS (an internal system in the National
Offender Management Service), a prison is based on location.

A jointly-managed prison in the data for registers can be recorded as
more than one prison in the NOMIS system. For example, here's register data
and nomis data compared for two jointly-managed prison:

| prison                                                | name                         | nomis-codes | nomis-names |
| ---:   | :---                         | ---:       | :---        |
| [UK](https://prison.alpha.openregister.org/record/UK) | HMP Usk and HMP/YOI Prescoed | UKI <br>UPI | USK (HMP) <br>PRESCOED (HMP & YOI)  |
| [GN](https://prison.alpha.openregister.org/record/GN) | HMP Grendon/Spring Hill      | GNI <br>SPI | GRENDON (HMP) <br>SPRING HILL (HMP) |

## Prison data

Here is an example of the fields in the prison data for registers:

| Field       | Value |
| :---        | :---  |
| prison      | [AC](http://prison.alpha.openregister.org/record/AC) |
| name        | HMP/YOI Altcourse |
| operator    | [company:02984969](https://beta.companieshouse.gov.uk/company/02984969) |
| address     | [38076557](http://address.discovery.openregister.org/record/38076557) |
| start-date  | |
| change-date | |
| end-date    | |

## Maps

Maps assist in the translation of existing codes and names to register records:

| Map  | Fields |
| :--- | :---   |
| [contracted-out](maps/contracted-out.tsv) | Prison name from [National Offender Management Service (NOMS) spend over £25,000 data](https://www.gov.uk/government/publications/national-offender-management-service-spend-over-25000-2016) |
| [designation-to-name-affix](maps/designation-to-name-affix.tsv) | Prison designation to [prefix and suffix used in prison name](https://github.com/openregister/prison-data/blob/readme-update/lib/prison_data.rb#L66) |
| [hmi](maps/hmi.tsv) | HM Inspectorate of Prisons name for prison in [inspection reports](https://www.justiceinspectorates.gov.uk/hmiprisons/inspections/) |
| [nomis-code](maps/nomis-code.tsv) | NOMIS three letter code |
| [prison-estate](maps/prison-estate.tsv) | Prison name from NOMS [prisons and their resettlement providers list](https://www.gov.uk/government/publications/prisons-and-their-resettlement-providers) |
| [prison-finder](maps/prison-finder.tsv) | Prison name from [prison finder](https://www.justice.gov.uk/contacts/prison-finder) digital service |
| [prison-map-prison](maps/prison-map-prison.tsv) | Prison name from [prison map](https://www.justice.gov.uk/downloads/contacts/hmps/prison-finder/prison-map.pdf) PDF on prison finder site |


## Lists

The data has been compiled from existing lists of prisons found
in a number of different government datasets:

| List | Source | Count |
| :---         |    :--- | ---: |
| [prison-estate](lists/prison-estate) | Prisons from National Offender Management Service (NOMS) [prisons and their resettlement providers list](https://www.gov.uk/government/publications/prisons-and-their-resettlement-providers) |[121](lists/prison-estate/list.tsv)|
| [prison-map](lists/prison-map) | Prisons from [prison map](https://www.justice.gov.uk/downloads/contacts/hmps/prison-finder/prison-map.pdf) PDF on prison finder site |[123](lists/prison-map/prisons.tsv)|
| [prison-finder](lists/prison-finder) | Prisons from [prison finder](https://www.justice.gov.uk/contacts/prison-finder) digital service |[124](lists/prison-finder/prison-address-text.tsv)|
| [nomis-codes](lists/nomis-codes) | Prison NOMIS establishment codes and names taken from the current production database on 16 Jan 2017 |[128](lists/nomis-codes/nomis-codes.tsv)|
| [noms-codes](lists/noms-codes) | LIDS and NOMIS codes extracted from prison codes PDF file from custodian |[153](lists/noms-codes/prison-codes.tsv)|
| [legal-aid-agency](lists/legal-aid-agency) | Prisons from Guidance for Reporting Crime Lower Work PDF published on gov.uk |[141](lists/legal-aid-agency/prison-codes.tsv)|
| [prison-performance-stats-2016](lists/prison-performance-stats-2016) | Prison list from [prison annual performance ratings 2015-2016](https://www.gov.uk/government/statistics/prison-performance-statistics-2015-to-2016) published on gov.uk. |[118](lists/prison-performance-stats-2016/prisons.tsv)|
| [prison-visits](lists/prison-visits) | Prisons scraped from Prison Visits booking digital service |[110](lists/prison-visits/prisons.tsv)|
| [contracted-out](lists/contracted-out) | Prison names and supplier names sourced from NOMS spend data files |[14](lists/contracted-out/prisons.tsv)|
| [former-prisons](lists/former-prisons) | Manually created from various sources - end dates found from various sources including HMI reports |[30](lists/former-prisons/prisons.tsv)|

# Licence

The software in this project is covered by LICENSE file.

The data is [© Crown copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/copyright-and-re-use/crown-copyright/)
and available under the terms of the [Open Government 3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.
