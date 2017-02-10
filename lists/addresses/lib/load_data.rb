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
        ['Usk/Prescoed (Prescoed)','Spring Hill'].include?(prison.name)
      end
    end

    def remove_closed_prisons prisons
      prisons.reject do |prison|
        ['Haslar Immigration Removal Centre','Dover Immigration Removal Centre'].include?(prison.name)
      end
    end

    def laa_codes
      codes = Morph.from_tsv read('../../legal-aid-agency/prison-codes.tsv'), :laa_code
      codes.each {|x| x.code = x.code[0..1]}
      codes
    end

    def old_nomis_codes
      Morph.from_tsv read('../../noms-codes/prison-codes.tsv'), :old_nomis
    end

    def current_nomis_codes
      Morph.from_tsv read('../../nomis-codes/nomis-codes.tsv'), :nomis
    end

    def closed_nomis_codes old_nomis, nomis
      current_codes = nomis.map(&:nomis)
      closed_codes = old_nomis.select do |x|
        x.nomis.size > 0 && !current_codes.include?(x.nomis)
      end
      closed_codes.map do |x|
        Morph.from_hash nomis: { nomis: x.nomis, name: x.name.strip }
      end
    end

    def nomis_codes
      nomis = current_nomis_codes
      nomis.each {|x| x.name = x.name.strip}
      old_nomis = old_nomis_codes
      closed_nomis_codes = closed_nomis_codes old_nomis, nomis
      nomis + closed_nomis_codes
    end

    def add_medway(prisons)
      medway = Morph::Prison.new.tap do |p|
        p.name = 'Medway'
        p.address_text = 'Sir Evelyn Road|Rochester'
        p.postcode = 'ME1 3LU'
      end
      prisons << medway
      prisons
    end

    def prison_finder_prisons
      prisons = Morph.from_tsv read('../../prison-finder/prison-address-text.tsv'), :prison
      prisons = remove_jointly_managed(prisons)
      prisons = remove_closed_prisons(prisons)
      add_medway(prisons)
    end

    def former_prisons
      Morph.from_tsv read('../../former-prisons/prisons.tsv'), :prison
    end

    def jointly_managed_prison_second_location
      prisons = Morph.from_tsv read('../../prison-finder/prison-address-text.tsv'), :prison
      prisons.select do |prison|
        ['Usk/Prescoed (Prescoed)','Spring Hill'].include?(prison.name)
      end
    end

    def prison_map_prisons
      Morph.from_tsv read('../../prison-map/prisons.tsv'), :name
    end

    def contracted_out_prisons
      contracted_out = Morph.from_tsv read('../../contracted-out/prisons.tsv'), :contracted
      contracted_out.each do |x|
        x.original_location = x.location
        x.location = x.location.sub('G4S ','').sub('Sodexo ','')
      end
      contracted_out
    end

    def addresses
      Morph.from_csv(read('../../../../address-discovery-data-matching/lists/prison-data/prison-address-street-postcode.csv'), :address)
    end
  end
end
