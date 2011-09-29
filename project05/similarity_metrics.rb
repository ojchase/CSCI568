class ComparisonObject
  @values
  
  def values()
    return @values
  end
  
  def initialize(args)
    @values = args
  end
  
  def to_s
    x = "["
    values.each do |val|
      x = x + val.to_s + ","
    end
    x = x.chop
    x = x + "]"
    return x
  end
end

class PairOfObjects
  @obj1
  @obj2
  
  def obj1()
    return @obj1
  end
  
  def obj2()
    return @obj2
  end

  def initialize(obj1, obj2)
    @obj1 = obj1
    @obj2 = obj2
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
  
  #normalizing!
  result = 1 / (1 + result.to_f)

  return result
end

def euclideanNotNormalized(object1, object2)
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
  #puts result

  return result
end