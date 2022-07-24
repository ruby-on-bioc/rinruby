class RinRuby
  class R_Character < R_DataType
    ID = RinRuby_Type_Character
    class << self
      def convertable?(value)
        value.all? do |x|
          x.nil? || x.is_a?(String)
        end
      end

      def send(value, io)
        # Character format: data_size, data1_bytes, data1, data2_bytes, data2, ...
        io.write([value.size].pack('l'))
        value.each do |x|
          if x
            bytes = x.to_s.bytes # TODO: taking care of encoding difference
            io.write(([bytes.size] + bytes).pack('lC*')) # .bytes.pack("C*").encoding equals to "ASCII-8BIT"
          else
            io.write([RinRuby_NA_R_Integer].pack('l'))
          end
        end
        value
      end

      def receive(io)
        length = io.read(4).unpack1('l')
        Array.new(length) do |_i|
          nchar = io.read(4).unpack1('l')
          # negative nchar means NA, and "+ 1" for zero-terminated string
          nchar >= 0 ? io.read(nchar + 1)[0..-2] : nil
        end
      end
    end
  end
end
