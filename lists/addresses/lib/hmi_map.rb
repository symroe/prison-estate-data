require 'pry'
require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

# convert ALTCOURSE (HMP) to HMP ALTCOURSE
# def rearrange_name name
#   if name == 'MEDWAY (STC)'
#     'Medway STC'
#   elsif m = /^([^\(]+)\s+\(([^\)]+)\)$/.match(name)
#     [m[2], m[1].split.map(&:capitalize).join(' ') ].join(' ')
#   else
#     name.split.map(&:capitalize).join(' ')
#   end
# end

def hmi_name_match? hmi_name, prison, hmi_names
  hmi_name == Matcher.match_hmi_name(Matcher.short_name(prison.name), hmi_names)
end

codes = LoadData.laa_codes ; nil
hmi_names = LoadData.hmi_names ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil

puts %w[hmi prison].join("\t")
hmi_names.each do |hmi|
  hmi_name = hmi.name
  prison = prisons.detect { |prison| hmi_name_match?(hmi_name, prison, hmi_names) }
  unless prison
    prison = former_prisons.detect { |p| hmi_name_match?(hmi_name, p, hmi_names) }
  end

  code = if prison
           short_name = Matcher.short_name(prison.name)
           Matcher.match_code(short_name, codes)
         else
           nil
         end
  puts [hmi_name, code].join("\t")
end
