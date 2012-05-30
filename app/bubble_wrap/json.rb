module BubbleWrap
  module JSON
    def self.parse_from_resource_file(name, type = 'json')
      resource_file = NSBundle.mainBundle.pathForResource(name, ofType: type)
      error = Pointer.new(:object)

      file_contents = NSData.alloc.initWithContentsOfFile(resource_file,
        options:NSDataReadingUncached, error:error)

      raise 'Error reading resource file' if error[0]

      parse(file_contents)
    end
  end
end