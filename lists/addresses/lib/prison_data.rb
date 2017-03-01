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
prison_estate = LoadData.prison_estate ; nil

puts %w[prison name operator address change-date start-date end-date].join("\t")

def estate_name_match? estate_name, prison_name
  name = case prison_name
  when 'Grendon'
    'Grendon/ Spring Hill'
  when 'The Mount'
    'Mount, The'
  when 'Verne'
    'Verne, The'
  when 'Usk/Prescoed (Usk)'
    'Usk/Prescoed'
  else
    prison_name
  end

  estate_name.gsub(' ','') == Matcher.short_name(name).gsub(' ','')
end

prisons.sort_by{|p| Matcher.massage_name(p.name)}.each do |prison|
  name = prison.name
  estate_prison = prison_estate.detect { |estate| estate_name_match?(estate.name, name) }
  address = Matcher.address_uprn(name, prison, addresses)
  official_name = Matcher.match_official_name(name, official_names)
  short_name = Matcher.short_name(name)
  end_date = Matcher.end_date(short_name)
  code = Matcher.match_code(short_name, codes)
  binding.pry if code.blank?
  company_number = Matcher.company_number(short_name, contracted_out)

  change_date = nil

  puts [
    code,
    WriteData.estate_name(estate_prison),
    company_number,
    address,
    change_date,
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
    nil,
    prison.end_date
  ].join("\t")
end

puts ["BW","HMP Berwyn",nil,nil,"2017-02",nil].join("\t") # add new prison
