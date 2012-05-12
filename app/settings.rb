class Settings

  def self.load(namespace)
    settings = BubbleWrap::JSON.parse_from_resource_file('settings')[namespace]
    Reader.new(settings)
  end

  class Reader
    def initialize(settings)
      @settings = settings
    end

    def [](key)
      @settings[key.to_s]
    end
  end

end
