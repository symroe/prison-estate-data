require 'pry'
require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

# convert ALTCOURSE (HMP) to HMP ALTCOURSE
def rearrange_name name
  if name == 'MEDWAY (STC)'
    'Medway STC'
  elsif m = /^([^\(]+)\s+\(([^\)]+)\)$/.match(name)
    prefix = m[2].sub('HMP & YOI', 'HMP/YOI')
    [prefix, m[1].split.map(&:capitalize).join(' ') ].join(' ')
  else
    name.split.map(&:capitalize).join(' ')
  end
end

def nomis_code_match? nomis_code, prison, nomis_codes
  nomis_code == Matcher.match_nomis_code(Matcher.short_name(prison.name), nomis_codes)
end

codes = LoadData.laa_codes ; nil
nomis_codes = LoadData.nomis_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
former_prisons = LoadData.former_prisons ; nil

puts %w[nomis prison name nomis-name].join("\t")
nomis_codes.each do |n|
  nomis_code = n.nomis
  prison = prisons.detect { |prison| nomis_code_match?(nomis_code, prison, nomis_codes) }
  unless prison
    prison = former_prisons.detect { |p| nomis_code_match?(nomis_code, p, nomis_codes) }
  end

  code = if prison
           short_name = Matcher.short_name(prison.name)
           Matcher.match_code(short_name, codes)
         else
           nil
         end
  puts [nomis_code, code, rearrange_name(n.name), n.name].join("\t")
end
