require 'pry'
require_relative 'prison'
require_relative 'address'
require_relative 'load_data'
require_relative 'matcher'

codes = LoadData.laa_codes ; nil
nomis_codes = LoadData.nomis_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
jointly_managed_prison_second_location = LoadData.jointly_managed_prison_second_location ; nil
addresses = LoadData.addresses ; nil

puts %w[prison address addresses].join("\t")
prisons.each do |prison|
  name = prison.prison
  address = Matcher.address_uprn(prison, addresses)
  all_addresses = Matcher.all_addresses(prison, prisons, addresses, jointly_managed_prison_second_location)
  code = Matcher.match_code(name, codes)
  puts [
    code,
    address,
    all_addresses
  ].join("\t") if address
end
