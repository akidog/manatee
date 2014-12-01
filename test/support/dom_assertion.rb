module JavascriptRenderer
  class DomAssertion
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def attributes
      Hash[ @node.attributes.map{ |name, attr| [name.to_sym, attr.value] } ]
    end

    def children
      @node.children.map do |child|
        DomAssertion.new child
      end
    end

    def text
      @node.to_s
    end

    def inspect
      @node.to_s
    end

    def ==(other)
      case @node
      when Nokogiri::XML::Element
        other.node.class == Nokogiri::XML::Element && self.attributes == other.attributes && self.children == other.children
      when Nokogiri::XML::CDATA
        other.node.class == Nokogiri::XML::CDATA && self.text == other.text
      when Nokogiri::XML::Text
        other.node.class == Nokogiri::XML::Text && self.text == other.text
      else
        false
      end
    end

    def self.parse(xml_code)
      Nokogiri::XML(xml_code).children.map do |child|
        DomAssertion.new child
      end
    end
  end
end
