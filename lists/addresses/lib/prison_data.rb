require 'fileutils'
require 'pry'
require_relative 'prison'
require_relative 'address'
require_relative 'load_data'
require_relative 'matcher'
require_relative 'write_data'

codes = LoadData.laa_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil
jointly_managed_prison_second_location = LoadData.jointly_managed_prison_second_location ; nil
official_names = LoadData.prison_map_prisons ; nil
contracted_out = LoadData.contracted_out_prisons ; nil
addresses = LoadData.addresses ; nil

puts %w[prison name organisation address start-date end-date].join("\t")

prisons.sort_by{|p| Matcher.massage_name(p.name)}.each do |prison|
  name = prison.name
  address = Matcher.address_uprn(name, prison, addresses)
  official_name = Matcher.match_official_name(name, official_names)
  short_name = Matcher.short_name(name)
  end_date = Matcher.end_date(short_name)
  code = Matcher.match_code(short_name, codes)
  binding.pry if code.blank?
  company_number = Matcher.company_number(short_name, contracted_out)
  puts [
    code,
    official_name,
    company_number,
    address,
    nil,
    end_date
  ].join("\t")
end

former_prisons.each do |prison|
  address = Matcher.address_uprn(prison.name, prison, addresses)
  code = prison.prison
  puts [
    code,
    prison.official_name,
    nil,
    address,
    nil,
    prison.end_date
  ].join("\t")
end
