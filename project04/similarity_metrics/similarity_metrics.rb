class ComparisonObject
  @values
  
  def values
    return @values
  end
  
  def initialize(args)
    @values = args
  end
end

def euclidean(object1, object2)
  if object1.values.length != object2.values.length
    return "Euclidean Distance can't be calculated as objects have a different number of values!"
  else
    length = object1.values.length
    result = 0
    for i in (0...length)
      result = result + (object1.values[i]-object2.values[i])**2
    end
    result = Math.sqrt(result)
  end

  puts "Euclidean distance is #{result}!"
end

def smc(object1, object2)
  if object1.values.length != object2.values.length
    return "SMC can't be calculated as objects have a different number of values!"
  else
    length = object1.values.length
    denom = length.to_f
    result = 0
    for i in (0...length)
      if(object1.values[i] == object2.values[i])
        result = result + 1
      end
    end
    result = result / denom
  end
  
  puts "SMC is #{result}!"
end

def jaccard(object1, object2)
  if object1.values.length != object2.values.length
    return "Jaccard can't be calculated as objects have a different number of values!"
  else
    length = object1.values.length
    denom = length.to_f
    result = 0
    for i in (0...length)
      if(object1.values[i] == object2.values[i])
        if(object1.values[i] != 0)
          result = result + 1
        end
      end
    end
    result = result / denom
  end
  
  puts "Jaccard Similarity is #{result}!"
end

def pearson(object1, object2)
  if object1.values.length != object2.values.length
    return "Pearson's Correlation Coefficient can't be calculated as objects have a different number of values!"
  else
    length = object1.values.length
    numerator = covariance(object1.values, object2.values)
    denom = standardDeviation(object1.values) * standardDeviation(object2.values)
    result = numerator / denom
  end
  
  puts "Pearson's Correlation Coefficient is #{result}!"
end

def cosine(object1, object2)
  numerator = dotProduct(object1.values, object2.values)
  denominator = Math.sqrt(dotProduct(object1.values, object1.values)) * Math.sqrt(dotProduct(object2.values, object2.values))
  result = numerator/denominator
  puts "Cosine distance is #{result}!"
end

#Takes two arrays and calculates their covariance
def covariance(val1, val2)
  if val1.length != val2.length
    return "Covariance can't be calculated as objects have a different number of values!"
  else
    length = val1.length
    average1 = average(val1)
    average2 = average(val2)
    sum = 0
    for i in (0...length)
      sum = sum + ((val1[i] - average1) * (val2[i] - average2))
    end
    
    result = 1 / (length.to_f - 1) * sum.to_f
  end
end

#Takes an array of values and calculates its standard deviation
def standardDeviation(values)
  n = values.length
  average = average(values)
  sumSquared = 0
  for i in (0...n)
    sumSquared = sumSquared + ((values[i] - average)**2)
  end
  result = Math.sqrt((1 / (n.to_f - 1)) * sumSquared)
end

#Takes an array of values and calculates its average
def average(values)
  sum = 0
  values.each do |value|
    sum = sum + value
  end
  return sum.to_f / values.length
end

#Takes two arrays corresponding to two vectors and calculates their dot product
def dotProduct(vector1, vector2)
  if vector1.length != vector2.length
    return "Dot product can't be calculated as objects have a different number of values!"
  else
    length = vector1.length
    result = 0
    for i in (0...length)
      result = result + (vector1[i]*vector2[i])
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
