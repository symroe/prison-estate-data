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

puts %w[prison name official-name organisation address start-date end-date].join("\t")

prisons.sort_by{|p| Matcher.massage_name(p.prison)}.each do |prison|
  name = prison.prison
  address = Matcher.address_uprn(prison, addresses)
  official_name = Matcher.match_official_name(name, official_names)
  name = Matcher.short_name(name)
  end_date = Matcher.end_date(name)
  code = Matcher.match_code(name, codes)
  binding.pry if code.blank?
  company_number = Matcher.company_number(name, contracted_out)
  puts [
    code,
    name,
    official_name,
    company_number,
    address,
    nil,
    end_date
  ].join("\t")
end

former_prisons.each do |prison|
  puts [
    prison.prison,
    prison.name,
    prison.official_name,
    nil,
    nil,
    nil,
    prison.end_date
  ].join("\t")
end
