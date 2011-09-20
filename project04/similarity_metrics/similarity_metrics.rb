class ComparisonObject
  @values
  
  def values
    return @values
  end
  
  def initialize(args)
    @values = args
  end
end

def func1()
  puts 1
end

def func2()
  puts 2
end

def printme(method)
  method
end

def euclidean(val1, val2)
  if val1.values.length != val2.values.length
    return "Euclidean Distance can't be calculated as objects have a different number of values!"
  else
    result = 0
    i = 0
    val1.values.each do |value|
      result = result + value*value
      i = i + 1
    end
    result = Math.sqrt(result)
  end
  
  puts "Euclidean distance is #{result}!"
end

def smc(val1, val2)
  result = "Not yet implemented"
  puts "SMC is #{result}!"
end

def jaccard(val1, val2)
  result = "Not yet implemented"
  puts "Jaccard similarity is #{result}!"
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
  
  a = ComparisonObject.new([1, 2, 3, 4])
  b = ComparisonObject.new([1, 2, 3, 4])
  y = {a, b}
  functions = [:euclidean, :smc, :jaccard, :pearson, :cosine]
  functions.each do |func|
    m = x.method(func)
    m.call(a, b)
  end
  
end
