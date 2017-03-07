require 'pry'
require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

codes = LoadData.laa_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil

puts %w[prison-finder prison].join("\t")
prisons.each do |finder_prison|
  finder_prison_name = finder_prison.name

  code = if finder_prison
           short_name = Matcher.short_name(finder_prison.name)
           Matcher.match_code(short_name, codes)
         else
           nil
         end
  puts [finder_prison_name, code].join("\t")
end
