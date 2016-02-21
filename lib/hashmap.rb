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

    def hash(key)
        0
    end

    def put(key, value)
        index = hash(key)
        index %= underlying_size
        existing_bucket = @data[index]
        bucket = HashBucket.new(key, value, existing_bucket)
        @data[index] = bucket
        @keys << key
        true
    end

    def get(key)
        index = hash(key)
        index %= underlying_size
        bucket = @data[index]
        ret = nil
        while not bucket.nil?
            if bucket.key == key
                ret = bucket.value
                break
            end
            bucket = bucket.next
        end
        ret
    end

    def delete(key)
        index = hash(key)
        index %= underlying_size
        bucket = @data[index]
        previous = nil
        while not bucket.nil?
            if bucket.key == key
                if previous.nil?
                    @data[index] = bucket.next_bucket
                else
                    previous.next_bucket = bucket.next_bucket unless previous.nil?
                end
                break
            end
            previous = bucket
            bucket = bucket.next
        end
    end

end

class HashBucket
    # Linked list

    attr_reader :key, :value, :next_bucket

    def initialize(key, value, next_bucket=nil)
        @key = key
        @value = value
        @next_bucket = next_bucket
    end

end
