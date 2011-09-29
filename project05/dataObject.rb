class DataObject<ComparisonObject
  @centroid
  def getCentroid()
    if(@centroid.nil?)
      return "NONE"
    end
    return @centroid
  end
  def setCentroid(center)
    @centroid = center
  end
end

class Centroid
  @centroidID
  @coordinates
  
  def initialize(id, coordinates)
    @centroidID = id
    @coordinates = coordinates
  end

  def getID()
    return @centroidID
  end

  def getCoordinates()
    return @coordinates
  end

  def setCoordinates(newCoordinates)
    @coordinates = newCoordinates
  end

  def getDataPoint()
    return ComparisonObject.new(@coordinates)
  end
  
  def to_s
    return "Centroid ##{@centroidID} at #{@coordinates}"
  end
end