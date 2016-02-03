class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    input = (hash || {})
    #output = {}
    #input.each_pair do |key, value|
    #  number = key.to_i
    #  number = key if (number.to_s != key)
    #  output.store(number, value)
    #end
    #output.with_indifferent_access
    input.with_indifferent_access
  end
end
