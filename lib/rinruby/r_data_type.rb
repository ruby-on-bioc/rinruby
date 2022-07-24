class RinRuby
  class R_DataType
    ID = RinRuby_Type_Unknown
    class << self
      def convertable?(_value)
        false
      end

      def ===(value)
        convertable?(value)
      end

      def send(_value, _io)
        nil
      end

      def receive(_io)
        nil
      end
    end
  end
end
