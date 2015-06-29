require 'bigdecimal'

module EDN

  class ExtParser

    # call the c-side method
    def set_input(data)
      ext_set_stream(data)
    end

    # token-by-token read
    def read
      return EDN::EOF if ext_eof
      ext_next
    end

    # entire stream read
    def parse(data)
      ext_read(data)
    end

  end

  def self.big_decimal(str)
    BigDecimal.new(str)
  end

end
