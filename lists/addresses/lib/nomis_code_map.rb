require 'pry'
require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

# convert ALTCOURSE (HMP) to HMP ALTCOURSE
def rearrange_name name
  if m = /^([^\(]+)\s+\(([^\)]+)\)$/.match(name)
    [m[2], m[1].split.map(&:capitalize).join(' ') ].join(' ')
  else
    name.split.map(&:capitalize).join(' ')
  end
end

codes = LoadData.laa_codes ; nil
nomis_codes = LoadData.nomis_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil

puts %w[nomis prison name nomis-name].join("\t")
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
  puts [n.nomis, code, rearrange_name(n.name), n.name].join("\t")
end
