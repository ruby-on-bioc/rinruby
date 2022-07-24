class RinRuby
  class R_Logical < R_DataType
    ID = RinRuby_Type_Logical
    CONVERT_TABLE = Hash[*{
      true => 1,
      false => 0,
      nil => RinRuby_NA_R_Integer
    }.collect do |k, v|
                           [k, [v].pack('l')]
                         end.flatten]
    class << self
      def convertable?(value)
        value.all? { |x| [true, false, nil].include?(x) }
      end

      def send(value, io)
        # Logical format: size, data, ...
        io.write([value.size].pack('l'))
        value.each do |x|
          io.write(CONVERT_TABLE[x])
        end
      end

      def receive(io)
        length = io.read(4).unpack1('l')
        io.read(4 * length).unpack('l*').collect do |v|
          v == RinRuby_NA_R_Integer ? nil : (v > 0)
        end
      end
    end
  end
end
