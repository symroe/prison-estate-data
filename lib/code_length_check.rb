

estate_count=`wc -l ./lists/prison-estate/prison_estate.tsv`.split(" ").first.to_i
map_count=`wc -l ./maps/prison-estate.tsv`.split(" ").first.to_i

if estate_count > map_count
  puts
  puts "Exiting script early:"
  puts
  puts "Not all prisons have a code in maps/prison-estate.tsv"
  puts "Please add new codes to maps/prison-estate.tsv"
  puts
  Kernel.exit(1)
end
