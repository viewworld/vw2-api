class ArraySerializer
  def self.dump(array)
    array.to_json
  end

  def self.load(array)
    return array if array.nil? || array.empty? || !array.is_a?(Array)
    array = array.map do |hash|
      output = {}
      hash.each_pair do |key, value|
        numeric_id = key.to_i
        numeric_id = key if (numeric_id.to_s != key)
        output.store(numeric_id, value)
      end
      hash = output
    end
    array
  end
end
