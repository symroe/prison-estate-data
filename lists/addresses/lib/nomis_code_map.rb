require 'pry'
require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

codes = LoadData.laa_codes ; nil
nomis_codes = LoadData.nomis_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil

puts %w[nomis prison name].join("\t")
nomis_codes.each do |n|
  prison = prisons.detect do |p|
    n.nomis == Matcher.match_nomis_code(Matcher.short_name(p.name), nomis_codes)
  end
  prison = former_prisons.detect do |p|
    n.nomis == Matcher.match_nomis_code(Matcher.short_name(p.name), nomis_codes)
  end unless prison
  code = if prison
           short_name = Matcher.short_name(prison.name)
           Matcher.match_code(short_name, codes)
         else
           nil
         end
  puts [n.nomis, code, n.name].join("\t")
end
