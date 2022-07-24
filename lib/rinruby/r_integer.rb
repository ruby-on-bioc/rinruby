class RinRuby
  class R_Integer < R_DataType
    ID = RinRuby_Type_Integer
    class << self
      def convertable?(value)
        value.all? do |x|
          x.nil? ||
            (x.is_a?(Integer) && (x >= RinRuby_Min_R_Integer) && (x <= RinRuby_Max_R_Integer))
        end
      end

      def send(value, io)
        # Integer format: size, data, ...
        io.write([value.size].pack('l'))
        value.each do |x|
          io.write([x.nil? ? RinRuby_NA_R_Integer : x].pack('l'))
        end
      end

      def receive(io)
        length = io.read(4).unpack1('l')
        io.read(4 * length).unpack('l*').collect do |v|
          v == RinRuby_NA_R_Integer ? nil : v
        end
      end
    end
  end
end
