require 'morph'
require 'base32/crockford'

class Morph::Address
  include Morph

  def address_parts
    @parts ||= [street_name, locality, town, administrative_area].compact
  end

  def to_s separator="\n"
    ([name, name_cy] + Array(address_parts) + Array(postcode)).compact.join(separator)
  end

  def key
    Base32::Crockford.decode(address)
  end
end
