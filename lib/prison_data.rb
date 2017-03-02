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

def write_morton_hall_history address
  write(
    prison: 'MH',
    name: 'HMP Morton Hall',
    address: address
  )
end

def write_the_verne_history address
  write(
    prison: 'VE',
    name: 'HMP The Verne',
    address: address
  )
end

def write_history prison, address
  case prison.prison
  when 'MH'
    write_morton_hall_history address
    '2011-05'
  when 'VE'
    write_the_verne_history address
    '2014-05'
  end
end

def operator code, contracted_out_map, contracted_out
  if name = contracted_out_map[code].try(:first).try(:name)
    if number = contracted_out[name].try(:first).try(:company)
      "company:#{number}"
    end
  end
end

def address code, address_map
  address_map[code].try(:first).try(:address)
end

def clean_name name
  name.
    sub('Grendon/ Spring Hill','Grendon/Spring Hill').
    sub('Mount, The','The Mount').
    sub('Verne, The','The Verne')
end

def estate_name prison
  if prison.name == 'Usk / Prescoed'
    "HMP Usk and HMP/YOI Prescoed"
  else
    [prison.prefix, clean_name(prison.name), prison.suffix].select{|x| x.present?}.join(" ")
  end
end

def write_current_prisons prisons, address_map, contracted_out_map, contracted_out
  prisons.sort_by{|x| clean_name(x.name)}.each do |prison|
    fix_prefix! prison
    operator = operator prison.prison, contracted_out_map, contracted_out
    address = address prison.prison, address_map
    change_date = write_history prison, address
    write(
      prison: prison.prison,
      name: estate_name(prison),
      operator: operator,
      address: address,
      change_date: change_date
    )
  end
end

def write_former_prisons prisons, address_map
  prisons.each do |prison|
    address = address prison.prison, address_map
    write(
      prison: prison.prison,
      name: prison.official_name,
      address: address,
      end_date: prison.end_date
    )
  end
end

current_prisons = Morph.from_tsv IO.read('./lists/prison-estate/list.tsv'), :prison ; nil
former_prisons = Morph.from_tsv IO.read('./lists/former-prisons/prisons.tsv'), :former_prison ; nil
contracted_out = Morph.from_tsv(IO.read('./lists/contracted-out/prisons.tsv'), :contracted_out).group_by(&:name) ; nil
contracted_out_map = Morph.from_tsv(IO.read('./maps/contracted-out.tsv'), :contracted_out_map).group_by(&:prison) ; nil
address_map = Morph.from_tsv(IO.read('./maps/address.tsv'), :contracted_out_map).group_by(&:prison) ; nil

puts %w[prison name operator address change-date start-date end-date].join("\t")
write_current_prisons current_prisons, address_map, contracted_out_map, contracted_out
write_former_prisons former_prisons, address_map
