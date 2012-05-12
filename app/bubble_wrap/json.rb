##
# from https://github.com/mattetti/BubbleWrap/blob/master/lib/json.rb
##
module BubbleWrap

  # Handles JSON encoding and decoding in a similar way Ruby 1.9 does.
  module JSON

    class ParserError < StandardError; end

    # Parses a string or data object and converts it in data structure.
    #
    # @param [String, NSData] str_data the string or data to serialize.
    # @raise [ParserError] If the parsing of the passed string/data isn't valid.
    # @return [Hash, Array, NilClass] the converted data structure, nil if the incoming string isn't valid.
    #
    # TODO: support options like the C Ruby module does
    def self.parse(str_data)
      data = str_data.respond_to?(:to_data) ? str_data.to_data : str_data
      opts = NSJSONReadingMutableContainers & NSJSONReadingMutableLeaves & NSJSONReadingAllowFragments
      error = Pointer.new(:id)
      obj = NSJSONSerialization.JSONObjectWithData(data, options:opts, error:error)
      raise ParserError, error[0].description if error[0]
      obj
    end

    def self.parse_from_resource_file(name, type = 'json')
      resource_file = NSBundle.mainBundle.pathForResource(name, ofType: type)
      error = Pointer.new(:object)

      file_contents = NSData.alloc.initWithContentsOfFile(resource_file,
        options:NSDataReadingUncached, error:error)

      raise 'Error reading resource file' if error[0]

      parse(file_contents)
    end

    def self.generate(obj)
      # opts = NSJSONWritingPrettyPrinted
      data = NSJSONSerialization.dataWithJSONObject(obj, options:0, error:nil)
      data.to_str
    end

  end
end