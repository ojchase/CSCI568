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
    return "Jaccard can't be calculated as objects have a different number of values!"
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
  if val1.values.length != val2.values.length
    return "Pearson's Correlation Coefficient can't be calculated as objects have a different number of values!"
  else
    length = val1.values.length
    numerator = covariance(val1, val2)
    denom = standardDeviation(val1.values) * standardDeviation(val2.values)
    result = numerator / denom
  end
  
  puts "Pearson's Correlation Coefficient is #{result}!"
end

def covariance(val1, val2)
  if val1.values.length != val2.values.length
    return "Covariance can't be calculated as objects have a different number of values!"
  else
    length = val1.values.length
    average1 = average(val1.values)
    average2 = average(val2.values)
    sum = 0
    for i in (0...length)
      sum = sum + ((val1.values[i] - average1) * (val2.values[i] - average2))
    end
    
    result = 1 / (length.to_f - 1) * sum.to_f
  end
end

def standardDeviation(values)
  n = values.length
  average = average(values)
  sumSquared = 0
  for i in (0...n)
    sumSquared = sumSquared + ((values[i] - average)**2)
  end
  result = Math.sqrt((1 / (n.to_f - 1)) * sumSquared)
end

def average(values)
  sum = 0
  values.each do |value|
    sum = sum + value
  end
  sum.to_f / values.length
end

def cosine(val1, val2)
  numerator = dotProduct(val1, val2)
  denominator = Math.sqrt(dotProduct(val1, val1)) * Math.sqrt(dotProduct(val2, val2))
  result = numerator/denominator
  puts "Cosine distance is #{result}!"
end

def dotProduct(vector1, vector2)
  if vector1.values.length != vector2.values.length
    return "Dot product can't be calculated as objects have a different number of values!"
  else
    length = vector1.values.length
    result = 0
    for i in (0...length)
      result = result + (vector1.values[i]*vector2.values[i])
    end
  end
  return result
end


if __FILE__ == $0
  x = ComparisonObject.new([1, 5, "fish", 2, 3])
  
  a = ComparisonObject.new([3, 6, 0, 3, 6])
  b = ComparisonObject.new([1, 2, 0, 1, 2])

  a = ComparisonObject.new([1, 0, 3, 4])
  b = ComparisonObject.new([5, 0, 7, 4])
  
  
  functions = [:euclidean, :smc, :jaccard, :pearson, :cosine]
  functions.each do |func|
    m = x.method(func)
    m.call(a, b)
  end
  
end
