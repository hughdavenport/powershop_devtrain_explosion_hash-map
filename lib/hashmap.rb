class HashMap

    attr_reader :weight

    def initialize
        @data = Array.new(10)
        @weight = 0.8
    end

    def empty?
        size == 0
    end

    def size
        @data.map{|bucket| bucket.nil? ? 0 : bucket.size}.inject(0){|sum,bucket_size| sum+bucket_size}
    end

    def keys
      @data.map{|bucket| bucket.nil? ? nil : bucket.keys}.reject{|keys| keys.nil?}.flatten
    end

    def values
      @data.map{|bucket| bucket.nil? ? nil : bucket.values}.reject{|values| values.nil?}.flatten
    end

    def underlying_size
        @data.length
    end

    def hash(key)
        prime = 31
        key.chars.map{|c| c.ord}.inject(prime){|hash,c| hash = hash*prime + c}
    end

    def put(key, value)
        index = hash(key)
        index %= underlying_size
        bucket = @data[index]
        ret = nil
        if bucket.nil?
            bucket = HashBucket.new(key, value)
            @data[index] = bucket
        else
            while not bucket.nil?
                if bucket.key == key
                    ret = bucket.value
                    bucket.value = value
                    break
                end
                bucket = bucket.next_bucket
            end
            if ret.nil?
                bucket = HashBucket.new(key, value, @data[index])
                @data[index] = bucket
            end
        end
        ret
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
        ret = nil
        while not bucket.nil?
            if bucket.key == key
                if previous.nil?
                    @data[index] = bucket.next_bucket
                else
                    previous.next_bucket = bucket.next_bucket unless previous.nil?
                end
                ret = bucket.value
                break
            end
            previous = bucket
            bucket = bucket.next
        end
        ret
    end

end

class HashBucket
    # Linked list

    attr_reader :key, :next_bucket
    attr_accessor :value

    def initialize(key, value, next_bucket=nil)
        @key = key
        @value = value
        @next_bucket = next_bucket
    end

    def size
        @next_bucket.nil? ? 1 : (1 + @next_bucket.size)
    end

    def keys
        @next_bucket.nil? ? [@key] : ([@key] + @next_bucket.keys)
    end

    def values
        @next_bucket.nil? ? [@value] : ([@value] + @next_bucket.values)
    end

end
