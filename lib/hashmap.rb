require 'prime'

class HashMap

    attr_reader :weight

    def initialize
        @data = Array.new(10)
        @weight = 0.8
        @rehash_threshold = 2.0
        @prime = Prime.first(100).sample
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

    def reweight_needed
        size >= (@weight * underlying_size)
    end

    def reweight
        return unless reweight_needed
        new_size = underlying_size * 20
        olddata = @data
        @data = Array.new(new_size)
        olddata.each do |bucket|
            while not bucket.nil?
                put(bucket.key, bucket.value)
                bucket = bucket.next_bucket
            end
        end
    end

    def rehash_needed
        average_get_operations > @rehash_threshold
    end

    def rehash
        return unless rehash_needed
        @prime = Prime.first(100).sample
        olddata = @data
        @data = Array.new(underlying_size)
        olddata.each do |bucket|
            while not bucket.nil?
                put(bucket.key, bucket.value)
                bucket = bucket.next_bucket
            end
        end
    end

    def average_get_operations
        # Return the average number of operations to get an element
        # If we are in a chain, the operations would be 1 + 2 + 3 + ... n operations to get all of them, this is helpfully (n*(n+1)/2).
        # Sum up all of these, then divide by size
        @data.map{|bucket| bucket.nil? ? 0 : bucket.size}.inject(0){|sum,size| sum + (size*(size+1)/2.0)}/size
    end

    def hash(key)
        key.chars.map{|c| c.ord}.inject(@prime){|hash,c| hash = hash*@prime + c}
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
        reweight if reweight_needed
        rehash if rehash_needed
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
            bucket = bucket.next_bucket
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
            bucket = bucket.next_bucket
        end
        ret
    end

end

class HashBucket
    # Linked list

    attr_reader :key
    attr_accessor :value, :next_bucket

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
