require 'pry'
require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

def map_name_match? map_prison_name, prison, prison_map
  Matcher.short_name(map_prison_name) == Matcher.short_name(prison.name)
end

codes = LoadData.laa_codes ; nil
prison_map = LoadData.prison_map_prisons ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil

puts %w[prison-map-prison prison].join("\t")
prison_map.each do |map_prison|
  map_prison_name = map_prison.name
  prison = prisons.detect { |prison| map_name_match?(map_prison_name, prison, prison_map) }
  unless prison
    prison = former_prisons.detect { |p| map_name_match?(map_prison_name, p, prison_map) }
  end

  code = if prison
           short_name = Matcher.short_name(prison.name)
           Matcher.match_code(short_name, codes)
         else
           nil
         end
  puts [map_prison.official_name, code].join("\t")
end
