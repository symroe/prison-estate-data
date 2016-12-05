
def cleaned_names names
  names.map do |name|
    official_name = name.sub('&','and').gsub('*','')
    [
      official_name.
        sub('HMYOI ','').
        sub('HMP/YOI ','').
        sub('HMIRC ','').
        sub('HMP ','').
        sub(' STC','').
        sub(' (FNP)','').
        sub(' (IRC)','').      
        sub(' (F)','').      
        sub(' (YP)','').
        chomp('*'),
      official_name 
    ]
  end
end

names = IO.read('./tabula-prison-map-2016.csv').gsub("\r",'').split("\n") ; nil
names = cleaned_names names ; nil
names = names.sort_by(&:first) ; nil
puts "name\tofficial-name"

names.each do |both|
  puts both.join("\t")
end
  
