require 'morph'

def fix_prefix! prison
  if prison.prison[/BH/] && prison.prefix == '???'
    prison.prefix = 'HMP'
  end
end

def write map
  row = %i[prison name operator address change_date start_date end_date].map do |key|
    map[key]
  end
  puts row.join("\t")
end

def write_morton_hall_history
  write(
    prison: 'MH',
    name: 'HMP Morton Hall'
  )
end

def write_the_verne_history
  write(
    prison: 'VE',
    name: 'HMP The Verne'
  )
end

def write_history prison
  case prison.prison
  when 'MH'
    write_morton_hall_history
    '2011-05'
  when 'VE'
    write_the_verne_history
    '2014-05'
  end
end

def write_current_prisons prisons
  prisons.each do |prison|
    fix_prefix! prison
    change_date = write_history prison
    write(
      prison: prison.prison,
      name: [prison.prefix, prison.name, prison.suffix].select{|x| x.present?}.join(" "),
      change_date: change_date
    )
  end
end

def write_former_prisons prisons
  prisons.each do |prison|
    write(
      prison: prison.prison,
      name: prison.official_name,
      end_date: prison.end_date
    )
  end
end

current_prisons = Morph.from_tsv IO.read('./lists/prison-estate/list.tsv'), :prison
former_prisons = Morph.from_tsv IO.read('./lists/former-prisons/prisons.tsv'), :former_prison

puts %w[prison name operator address change-date start-date end-date].join("\t")
write_current_prisons current_prisons
write_former_prisons former_prisons
