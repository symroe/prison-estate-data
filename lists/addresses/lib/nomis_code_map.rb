require 'pry'
require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

codes = LoadData.laa_codes ; nil
nomis_codes = LoadData.nomis_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil

puts %w[nomis prison name].join("\t")
nomis_codes.each do |n|
  prison = prisons.detect do |p|
    n.nomis == Matcher.match_nomis_code(Matcher.short_name(p.name), nomis_codes)
  end
  code = if prison
           name = prison.name
           short_name = Matcher.short_name(name)
           Matcher.match_code(short_name, codes)
         else
           nil
         end
  puts [n.nomis, code, n.name].join("\t")
end
