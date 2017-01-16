require 'morph'

class Morph::Prison
  include Morph

  def address_parts
    address_text.split('|') if address_text
  end

  def to_s separator="\n"
    ([prison] + Array(address_parts) + Array(postcode)).compact.join(separator)
  end
end
