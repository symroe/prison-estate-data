require_relative 'prison'
require_relative 'address'

module LoadData
  class << self
    DIR = File.dirname(__FILE__)

    def read file
      IO.read File.expand_path(File.join(DIR, file))
    end

    def remove_jointly_managed prisons
      prisons.reject do |prison|
        ['Usk/Prescoed (Prescoed)','Spring Hill'].include?(prison.prison)
      end
    end

    def remove_closed_prisons prisons
      prisons.reject do |prison|
        ['Haslar Immigration Removal Centre','Dover Immigration Removal Centre'].include?(prison.prison)
      end
    end

    def laa_codes
      codes = Morph.from_tsv read('../../legal-aid-agency/prison-codes.tsv'), :code
      codes.each {|x| x.code = x.code[0..1]}
      codes
    end

    def nomis_codes
      Morph.from_tsv read('../../noms-codes/prison-codes.tsv'), :code
    end

    def prison_finder_prisons
      prisons = Morph.from_tsv read('../../prison-finder/prison-address-text.tsv'), :prison
      prisons = remove_jointly_managed(prisons)
      remove_closed_prisons(prisons)
    end

    def former_prisons
      Morph.from_tsv read('../../former-prisons/prisons.tsv'), :former_prison
    end

    def jointly_managed_prison_second_location
      prisons = Morph.from_tsv read('../../prison-finder/prison-address-text.tsv'), :prison
      prisons.select do |prison|
        ['Usk/Prescoed (Prescoed)','Spring Hill'].include?(prison.prison)
      end
    end

    def prison_map_prisons
      Morph.from_tsv read('../../prison-map/prisons.tsv'), :name
    end

    def contracted_out_prisons
      contracted_out = Morph.from_tsv read('../../contracted-out/prisons.tsv'), :contracted
      contracted_out.each{|x| x.location = x.location.sub('G4S ','').sub('Sodexo ','')}
      contracted_out
    end

    def addresses
      Morph.from_csv(read('../address_street_postcode.csv'), :address)
    end
  end
end
