require_relative 'prison'
require_relative 'load_data'
require_relative 'matcher'

codes = LoadData.laa_codes ; nil
prisons = LoadData.prison_finder_prisons ; nil
contracted_out = LoadData.contracted_out_prisons ; nil

puts %w[name prison].join("\t")
contracted_out.each do |c|
  puts [c.original_location, Matcher.contracted_code(c.location,prisons,codes)].join("\t")
end
