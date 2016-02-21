class HashMap

    attr_reader :weight

    def initialize
        @data = Array.new(10)
        @size = 0
        @weight = 0.8
    end

    def empty?
        @size == 0
    end

end
