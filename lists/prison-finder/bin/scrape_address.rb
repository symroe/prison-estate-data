require 'nokogiri'

puts "prison\taddress-text"
Dir.glob("./cache/*").each do |f| 
	doc = Nokogiri::HTML(IO.read(f).gsub('div class="text"', 'p').gsub('<strong>Address','<p><strong>Address'))
	if doc.at('title')
		print doc.at('title').
			inner_text.
			to_s.
			sub(/ (Prison|IRC) (contacts|information)/i,'').
			sub(/Information for /i,'') 
	end
	print "\t"
	
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
  puts address.nil? ? "" : address.join('|')
end
