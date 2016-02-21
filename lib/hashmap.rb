class HashMap

    attr_reader :weight

    def initialize
        @keys = []
        @data = Array.new(10)
        @weight = 0.8
    end

    def empty?
        size == 0
    end

    def size
        @keys.length
    end

    def underlying_size
        @data.length
    end

end
