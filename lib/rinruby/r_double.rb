class RinRuby
  class R_Double < R_DataType
    ID = RinRuby_Type_Double
    class << self
      def convertable?(value)
        value.all? do |x|
          x.nil? || x.is_a?(Numeric)
        end
      end

      def send(value, io)
        # Double format: data_size, data, ..., na_index_size, na_index, ...
        io.write([value.size].pack('l'))
        nils = []
        value.each.with_index do |x, i|
          if x.nil?
            nils << i
            io.write([Float::NAN].pack('D'))
          else
            io.write([x.to_f].pack('D'))
          end
        end
        io.write(([nils.size] + nils).pack('l*'))
        value
      end

      def receive(io)
        length = io.read(4).unpack1('l')
        res = io.read(8 * length).unpack('D*')
        na_indices = io.read(4).unpack1('l')
        io.read(4 * na_indices).unpack('l*').each { |i| res[i] = nil }
        res
      end
    end
  end
end
