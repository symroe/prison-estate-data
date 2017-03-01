module WriteData
  class << self

    def prefix estate
      case estate.designation
        when 'Dual Designated Prison'
          'HMP/YOI'
        when 'Prison'
          'HMP'
        when 'Young Offender Institution'
          'HMYOI'
        when 'Not in use'
          if estate.name[/Blantyre House/]
            'HMP'
          else
            '???'
          end
        when 'Secure Training Centre'
          nil
        when 'Immigration Removal Centre'
          'HMIRC'
        else
          '???'
      end
    end

    def suffix estate
      if estate.designation == 'Secure Training Centre'
        'STC'
      end
    end

    def estate_name estate
      if estate.name == 'Usk / Prescoed'
        "HMP Usk and HMP/YOI Prescoed"
      else
        location = estate.name.
          sub('Grendon/ Spring Hill','Grendon/Spring Hill').
          sub('Mount, The','The Mount').
          sub('Verne, The','The Verne')
        [prefix(estate), location, suffix(estate)].compact.join(" ")
      end
    end

    def print_match prison, match
      puts '==='
      puts prison.to_s("<br/>")
      puts '---'
      if match[0]
        puts 'score: ' + match[1].to_s
        puts 'uprn: ' + match[0].key.to_s
        puts '---'
        puts match[0].to_s("<br/>")
      else
        puts 'NO MATCH'
      end
      puts '==='
    end

    def print_match_html prison, match
      puts '<tr style="margin-top: 2em;">'
      puts '<td style="vertical-align: top">' + prison.name + '</td>'
      puts '<td style="vertical-align: top">' + prison.to_s("<br/>") + '</td>'
      if match[0] && match[1] > 2.4
        puts '<td style="vertical-align: top">' + match[0].to_s("<br/>") + '</td>'
        puts '<td style="vertical-align: top">' + 'score: ' + match[1].to_s + '</td>'
        puts '<td style="vertical-align: top">' + 'uprn: ' + match[0].key.to_s + '</td>'
      else
        puts '<td>'
        puts 'NO MATCH'
        puts '</td>'
      end
      puts '</tr>'
    end

    def print_matches_html prisons, addresses
      puts '<html><body style="font-family: sans-serif;"><table style="border-spacing:2em;">'
      prisons.sort_by do |x|
        Matcher.match_address(x, addresses)[1].to_s + x.name
      end.each do |x|
        WriteData.print_match_html x, match_address(prison, addresses)
      end
      puts '</table></body></html>'
    end

  end
end
