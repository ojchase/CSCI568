require 'similarity_metrics.rb'
require 'dataObject.rb'

class KMeans
  #returns the cumulative SSE from adding each of them together
  def run(objects, k)
    centroids = initCentroids(objects, k)
    #print(centroids)
    nochanges = false

    while(!nochanges)
      nochanges = true
      objects.each do |obj|
        moved = pickNearestCentroid(obj, centroids)
        if(moved)
          nochanges = false
        end
      end

      recalculateCentroids(objects, centroids)

    end

    cumulativeSSE = showResults(objects, centroids)
    return cumulativeSSE
  end

  #returns the from all the clusters sse
  def showResults(objects, centroids)
    sse = 0
    centroids.each do |centroid|
      puts centroid
      puts "Includes the following points:"
      objects.each do |obj|
        if(obj.getCentroid == centroid)
          puts "    #{obj}"
        end
      end
      puts("SSE: #{sse(objects, centroid)}")
      puts
      sse = sse + sse(objects, centroid)
    end
    return sse
  end

  def sse(objects, centroid)
    sse = 0
    objects.each do |obj|
      if(obj.getCentroid == centroid)
        sse = sse + (euclideanNotNormalized(obj, centroid.getDataPoint))**2
      end
    end
    return sse
  end

  def recalculateCentroids(objects, centroids)
    len = objects[0].values.length
    centroids.each do |centroid|
      dimensionSums = Array.new(len)
      dimensionSums.fill(0)
      usingCentroid = 0
      #puts "Centroid #{centroid.getID} started at #{centroid.getCoordinates}"
      objects.each do |obj|
        if(obj.getCentroid == centroid)
          #puts "   #{obj} is on this centroid!"
          for i in (0..len-1)
            dimensionSums[i] = dimensionSums[i] + obj.values[i]
          end
          usingCentroid = usingCentroid + 1
        end
      end
      #print dimensionSums
      for i in (0..dimensionSums.length - 1)
        #puts dimensionSums[i]
        #puts usingCentroid
        dimensionSums[i] = dimensionSums[i] / usingCentroid.to_f
      end
      if(usingCentroid == 0) #we'll just move the centroid to the first point - better than having an empty cluster!
        dimensionSums = objects[0].values
      end
      centroid.setCoordinates(dimensionSums)
      #puts "Centroid #{centroid.getID} moved to #{centroid.getCoordinates}"
    end
  end

  #moves object to the closest centroid and returns true if it moved
  def pickNearestCentroid(object, centroids)
    #puts "#{object} is currently on centroid #{object.getCentroid}"
    currentCentroid = object.getCentroid()

    len = centroids.length
    distanceToCentroids = Array.new(len)

    for i in (0..len-1)
      #puts "    #{object} is #{1 - euclidean(object, centroids[i].getDataPoint)} from #{centroids[i]}"
      distanceToCentroids[i] = 1 - euclidean(object, centroids[i].getDataPoint)
    end
    closestCentroid = centroids[distanceToCentroids.index(distanceToCentroids.min)]
    object.setCentroid(closestCentroid)
    #puts "#{object} is now on centroid #{object.getCentroid}"
    return currentCentroid.nil? || currentCentroid != closestCentroid
  end

  def initCentroids(objects, k)
    len = objects[0].values.length
    objects.each do |obj|
      if(len != obj.values.length)
        return "Clustering can't continue as objects have a different number of attributes!"
      end
    end
    minBounds = Array.new(len)
    maxBounds = Array.new(len)

    #Calculate the minimum and maximum allowable value for each attribute
    objects.each do |obj|
      i = 0
      obj.values.each do |value|
        if(minBounds[i].nil? || minBounds[i] > value)
          minBounds[i] = value
        end
        if(maxBounds[i].nil? || maxBounds[i] < value)
          maxBounds[i] = value
        end
        i = i + 1
      end
    end

    #Randomly pick centroids in that range!
    centroids = Array.new(k)
    r = Random.new
    for i in (0..k-1)
      center = Array.new(len)
      for j in (0..len-1)
        center[j] = rand(maxBounds[j] - minBounds[j]) + minBounds[j]
      end
      centroids[i] = Centroid.new(i, center)
    end
    return centroids
  end

end

if(__FILE__ == $0)

  objects = [DataObject.new([1, 2, 3]),
    DataObject.new([1, 3, 5]),
    DataObject.new([1, 3, 4]),
    DataObject.new([4, 5, 10]),
    DataObject.new([7, 8, 9])]

  objects = [DataObject.new([1, 1]),
    DataObject.new([1, 2]),
    DataObject.new([2, 1]),
    DataObject.new([2, 2]),
    DataObject.new([7, 7]),
    DataObject.new([7, 8]),
    DataObject.new([8, 7]),
    DataObject.new([8, 8])]

  lowestSSE = 100000000
  for i in (2..10)
    for j in (1..5) #run five times for each k
      kMeans = KMeans.new()
      tempSSE = kMeans.run(objects, i)
      if(tempSSE < lowestSSE)
        k = j
        lowestSSE = tempSSE
      end
    end
  end

  puts "Ideal K is #{k}!"

end