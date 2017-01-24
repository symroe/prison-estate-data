module Matcher
  class << self
    def name_include? text, address
      address.name.to_s.include?(text) || address.name_cy.to_s.include?(text)
    end

    def score name, address_parts, postcode, address
      score = 0.0
      score += 1.3 if address.name.to_s.include?(name) || address.name_cy.to_s.include?(name)
      if name == 'LANCASTER' && address.name.to_s.include?('LANCASTER FARMS')
        score -= 5
      end
      if name_include?('PRISON', address)
        score += 0.1
      else
        # score -= 0.1
      end
      if name_include?('LAND AT', address) ||
        name_include?('VISITOR CENTRE', address) ||
        name_include?('VISITORS CENTRE', address) ||
        name_include?('PHARMACY', address) ||
        name_include?('BUS SHELTER', address) ||
        name_include?('CAR PARK', address) ||
        name_include?('ELECTRICITY SUBSTATION', address)
        score -= 3.0
      end
      if name_include?('DETENTION CENTRE', address) ||
        name_include?('REMAND CENTRE', address)
        score -= 1.0
      end

      address_parts.each do |part|
        score += 1.0 if address.address_parts.include?(part)
      end
      if postcode.strip == address.postcode.strip
        score += 1.5
      else
        # $stderr.puts [postcode.strip, address.postcode.strip].join(",")
      end
      score
    end

    def match_address name, address_parts, postcode, addresses
      name = name.sub('HMP and YOI ','').upcase
      address_parts = address_parts.map(&:upcase)

      match = [nil, 0.0]
      addresses.each do |address|
        score = score(name, address_parts, postcode, address)
        if match[0].nil? || score > match[1]
          match = [address, score]
        end
      end
      if match[1] == 0
        [nil, 0.0]
      else
        match
      end
    end

    def clean_name name
      name.sub('HMP and YOI ','').
        sub(' Immigration Removal Centre','').
        sub(' Young Offender Institution information','').
        sub('HMP ','')
    end

    def match_code name, codes
      name = case name
             # Announced June 2013 HM Prisons Everthorpe and Wolds
             # will merge into one larger prison under a new name HMP Humber.
             when 'Humber'
               return 'HM'
             when 'Hatfield'
               'MOORLAND (OPEN)'
             when 'Highpoint'
               'HIGHPOINT SOUTH'
             when 'Oakwood'
               return 'OW'
             when 'Isis'
               return 'IS'
             when 'Isle of Wight'
               'PARKHURST'
             when 'Kirklevington Grange'
               'KIRKLEVINGTON'
             when 'Manchester (Strangeways)'
               'MANCHESTER'
             when 'Moorland'
               'MOORLAND (CLOSED)'
             # On 31 October 2011 HM Prison Acklington merged with
             # HM Prison Castington to form HMP Northumberland
             when 'Northumberland'
               return 'NL'
             when 'Thameside'
               return 'TS'
             when 'The Mount'
               'MOUNT'
             when 'Usk/Prescoed (Prescoed)'
               'USK'
             when 'Usk/Prescoed (Usk)'
               'USK'
             when /Sheppey Cluster \((.*)\)/
               massage_name($1).upcase
             when 'Wormwood Scrubs'
               'WORMWOOD'
             when 'Grendon/Spring Hill'
               return 'GN'
             when 'Usk/Prescoed'
               return 'UK'
             when 'The Verne'
               return 'VE'
             else
               clean_name(name).upcase
             end
      name.gsub!(' ','')
      codes.detect {|x| x.location.sub('(IRC)','').gsub(' ','') == name}.try(:code)
    end

    def massage_name name
      name = clean_name(name)
      case name
      when 'Manchester (Strangeways)'
        'Manchester'
      when /Sheppey Cluster \((.*)\)/
        $1
      when 'Verne'
        'The Verne'
      else
        name
      end
    end

    def short_name name
      massage_name(name).
        sub(/^Grendon$/,'Grendon/Spring Hill').
        sub('Usk/Prescoed (Usk)','Usk/Prescoed')
    end

    def match_official_name name, official_names
      name = massage_name(name)
      name = 'Usk and Prescoed' if name.include?('(Usk)') || name.include?('(Prescoed)')
      name = 'Highdown' if name == 'High Down'
      official_name = official_names.detect{|x| x.name == name}.try(:official_name).to_s
      official_name.sub!('Highdown','High Down')
      official_name.sub!(/^HMP Grendon$/,'HMP Grendon/Spring Hill')
      official_name
    end

    def end_date name
      case name
      when /Dover/
        '2015'
      when /Haslar/
        '2015'
      end
    end

    def address_uprn name, prison, address_list
      address_parts = prison.address_parts
      postcode = prison.postcode
      match = match_address(name, address_parts, postcode, address_list)
      match[1] > 2.4 ? match[0].key : nil
    end

    def company_number name, contracted_out
      name = massage_name(name)
      company_number = contracted_out.detect{|x| x.location == name}.try(:company)
      company_number = "company:#{company_number}" if company_number
      company_number
    end

    def other_addresses other_location, address, prisons, addresses
      prison = prisons.detect{|x| x.prison == other_location}
      binding.pry if prison.nil?
      [address, address_uprn(prison.prison, prison, addresses)]
    end

    def all_addresses prison, prisons, addresses, jointly_managed_prison_second_location
      address = address_uprn(prison.prison, prison, addresses)
      case prison.prison
      when 'Usk/Prescoed (Usk)'
        other_addresses('Usk/Prescoed (Prescoed)', address, jointly_managed_prison_second_location, addresses).join(";")
      when 'Grendon'
        other_addresses('Spring Hill', address, jointly_managed_prison_second_location, addresses).join(";")
      else
        address
      end
    end
  end
end
