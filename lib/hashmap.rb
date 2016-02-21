class HashMap

    attr_reader :weight
    attr_reader :size

    def initialize
        @data = Array.new(10)
        @size = 0
        @weight = 0.8
    end

    def empty?
        @size == 0
    end

    def underlying_size
        @data.length
    end

end
