class ComparisonObject
  @values
  
  def values
    return @values
  end
  
  def initialize(args)
    @values = args
  end
end

def euclidean(val1, val2)
  if val1.values.length != val2.values.length
    return "Euclidean Distance can't be calculated as objects have a different number of values!"
  else
    length = val1.values.length
    result = 0
    for i in (0...length)
      result = result + (val1.values[i]-val2.values[i])**2
    end
    result = Math.sqrt(result)
  end
  
  puts "Euclidean distance is #{result}!"
end

def smc(val1, val2)
  if val1.values.length != val2.values.length
    return "SMC can't be calculated as objects have a different number of values!"
  else
    length = val1.values.length
    denom = length.to_f
    result = 0
    for i in (0...length)
      if(val1.values[i] == val2.values[i])
        result = result + 1
      end
    end
    result = result / denom
  end
  
  puts "SMC is #{result}!"
end

def jaccard(val1, val2)
  if val1.values.length != val2.values.length
    return "SMC can't be calculated as objects have a different number of values!"
  else
    length = val1.values.length
    denom = length.to_f
    result = 0
    for i in (0...length)
      if(val1.values[i] == val2.values[i])
        if(val1.values[i] != 0)
          result = result + 1
        end
      end
    end
    result = result / denom
  end
  
  puts "Jaccard Similarity is #{result}!"
end

def pearson(val1, val2)
  result = "Not yet implemented"
  puts "Pearson Correlation Coefficient is #{result}!"
end

def cosine(val1, val2)
  result = "Not yet implemented"
  puts "Cosine distance is #{result}!"
end


if __FILE__ == $0
  x = ComparisonObject.new([1, 5, "fish", 2, 3])
  
  a = ComparisonObject.new([1, 0, 3, 4])
  b = ComparisonObject.new([5, 0, 7, 4])
  
  functions = [:euclidean, :smc, :jaccard, :pearson, :cosine]
  functions.each do |func|
    m = x.method(func)
    m.call(a, b)
  end
  
end
