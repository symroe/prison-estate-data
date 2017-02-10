require 'pry'
require_relative 'prison'
require_relative 'address'
require_relative 'load_data'
require_relative 'matcher'

codes = LoadData.laa_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil
jointly_managed_prison_second_location = LoadData.jointly_managed_prison_second_location ; nil
addresses = LoadData.addresses ; nil

puts %w[prison address].join("\t")
prisons.each do |prison|
  name = prison.name
  address = Matcher.address_uprn(name, prison, addresses)
  all_addresses = Matcher.all_addresses(prison, prisons, addresses, jointly_managed_prison_second_location)
  code = Matcher.match_code(name, codes)
  puts [
    code,
    address,
    # all_addresses
  ].join("\t") if address
end
former_prisons.each do |prison|
  address = Matcher.address_uprn(prison.name, prison, addresses)
  code = prison.prison
  puts [
    code,
    address
  ].join("\t") if address
end
