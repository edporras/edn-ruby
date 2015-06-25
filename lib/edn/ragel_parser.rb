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

  # ----------------------------------------------------------------------------
  # handles creation of a set from an array
  #
  def self.make_set(elems)
    Set.new(elems)
  end

  # ----------------------------------------------------------------------------
  # to create Big Ints (for now)
  #
  def self.string_int_to_bignum(str)
    str.to_i
  end

  # ----------------------------------------------------------------------------
  # to create Big Ints (for now)
  #
  def self.string_double_to_bignum(str)
    str.to_f
  end

end
