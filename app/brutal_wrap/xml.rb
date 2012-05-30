module BrutalWrap

  module XML

    class ParserWorker

      attr_reader :tickets

      def initialize
        @tickets = []
      end

      def parser(parser, didStartElement:element, namespaceURI:namespace, qualifiedName:name, attributes:attrs)
        @current_element = element
      end

      def parser(parser, foundCharacters:string)
        if @current_element == 'summary'
          unless string.strip.empty?
            @tickets << string
          end
        end
      end
    end

    def self.parse(str_data)
      data = str_data.respond_to?(:to_data) ? str_data.to_data : str_data
      xmlParser = NSXMLParser.alloc.initWithData(data)

      parser = ParserWorker.new

      xmlParser.setDelegate(parser)

      unless xmlParser.parse
        raise 'Did not parse XML'
      end

      parser
    end
  end
end