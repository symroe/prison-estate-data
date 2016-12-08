require 'nokogiri'

def clean_name text
  name = text.
    to_s.
    sub(/ (Prison|IRC) (contacts|information)/i,'').
    sub(/Information for /i,'').
    sub(/HMP and YOI /,'').
    sub(/HMP /,'')
end

def name doc
  if doc.at('title')
    clean_name(doc.at('title').inner_text)
  end
end

def address_postcode name, doc
  address = doc.search('p').
    select{|x| x.inner_text[/[0-9][A-Z][A-Z]/] && !x.inner_text["ACCT"] }.
    map do |x|
      $pc = false
      x.inner_html.
        gsub("\r\n","\n").
        gsub("<br>","\n").
        gsub("<br />","\n").
        squeeze("\n").
        strip.
        gsub("\n","|").
        sub('addressing','').
        sub(/(.*)?(Address|Cyfeiriad):?/i,"").
        gsub("|","\n").
        strip.
        sub("</strong>","").
        sub(':','').
        split("\n").
        map(&:strip).
        map{|w| w.chomp(",")}.
        map(&:strip).
        delete_if do |w| 
          opc = $pc
          $pc = w[/[0-9][A-Z][A-Z]/].to_s.size > 0 unless $pc
          opc || w.size == 0 
        end
  end.first
  address = address.first.split(",") if address && address.size == 1
  address = address.map do |x|
    x.squeeze(' ').
      sub('<!--?xmlnamespace prefix = st1 /?--> ','').
      sub(/ \(Sat Nav.*/,'').
      sub('     ','').
      strip.
      split(', ')
  end.flatten if address
  postcode = address.pop if address

  if address.nil? && name == 'Humber'
    address = ['Everthorpe', 'Brough']
    postcode = 'HU15 2JZ'
  end

  address = address.nil? ? "" : address.join('|')

  [address, postcode.to_s]
end

def doc file
  Nokogiri::HTML IO.read(file).
    gsub('div class="text"', 'p').
    gsub('<strong>Address','<p><strong>Address')
end

def name_address_postcodes
  Dir.glob("./cache/*").map do |file|
    doc = doc(file)
    name = name(doc)
    address, postcode = address_postcode(name, doc)
    [name, address, postcode]
  end
end

def ignore? name
  name == 'CEM Abertawe' ||
  name == 'CEM Caerdydd' ||
  name == 'Usk/Prescoed'
end

puts "prison\taddress-text\tpostcode"
name_address_postcodes.
  reject{|name, a, p| ignore?(name)}.
  each {|p| puts p.join("\t")}
