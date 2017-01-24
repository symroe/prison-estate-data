require 'pry'
require_relative 'prison'
require_relative 'address'
require_relative 'load_data'
require_relative 'matcher'

codes = LoadData.laa_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil
addresses = LoadData.addresses ; nil

puts (%w[prison prison-name address] + addresses.first.morph_attributes.keys).join("\t")
prisons.each do |prison|
  name = prison.prison
  address = Matcher.address_uprn(name, prison, addresses)
  code = Matcher.match_code(name, codes)
  short_name = Matcher.short_name(name)
  puts ([
    code,
    short_name,
    address
  ] + addresses.detect{|a| a.key == address}.morph_attributes.values ).join("\t") if address
end
former_prisons.each do |prison|
  address = Matcher.address_uprn(prison.name, prison, addresses)
  code = prison.prison
  short_name = Matcher.short_name(prison.name)
  puts ([
    code,
    short_name,
    address
  ] + addresses.detect{|a| a.key == address}.morph_attributes.values ).join("\t") if address
end
