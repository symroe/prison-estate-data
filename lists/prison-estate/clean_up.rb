require 'morph'

def set_postcode! prison
  prison.postcode = if prison.postal_address.present?
                      prison.postal_address.
                      gsub("\n"," ")[/[A-Z][A-Z]?\d\d?\s?\d\d?[A-Z][A-Z]?/].to_s
                    else
                      nil
                    end
end

def set_address! prison
  prison.address = if prison.postal_address.present?
                      prison.postal_address.
                      gsub("\n"," ").sub(prison.postcode,"").strip.chomp(",").strip.chomp('0').strip
                    else
                      nil
                    end
end

def sub_ampersand! prison
  if prison.lead_resettlement_cpa_if_resettlement_prison
    prison.lead_resettlement_cpa_if_resettlement_prison.sub!(' & ',';')
  end
end

prisons = Morph.from_csv IO.read('./prison_estate_and_cpas.csv'), :prison ; nil
prisons.each do |prison|
  set_postcode! prison
  set_address! prison
  sub_ampersand! prison
end

headers = prisons.first.morph_attributes.keys.join("\t")

rows = prisons.map do |x|
  x.morph_attributes.values.map do |w|
    w.to_s.gsub("\n"," ").squeeze(" ").strip
  end.join("\t")
end

puts headers
rows.each {|r| puts r}
