require 'similarity_metrics.rb'
require 'dataObject.rb'

class KMeans
  #returns the cumulative SSE from adding each of them together
  def run(objects, k, print)
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

    cumulativeSSE = showResults(objects, centroids, print)
    return cumulativeSSE
  end

  #returns the from all the clusters sse
  def showResults(objects, centroids, print)
    sse = 0
    if (print)
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
    else
      centroids.each do |centroid|
        sse = sse + sse(objects, centroid)
      end
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
      if(usingCentroid == 0) #we'll just move the centroid to a random point - better than having an empty cluster!
        dimensionSums = objects[rand(objects.length)].values
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

    objects = [DataObject.new([5.1,3.5,1.4,0.2]),
DataObject.new([4.9,3.0,1.4,0.2]),
DataObject.new([4.7,3.2,1.3,0.2]),
DataObject.new([4.6,3.1,1.5,0.2]),
DataObject.new([5.0,3.6,1.4,0.2]),
DataObject.new([5.4,3.9,1.7,0.4]),
DataObject.new([4.6,3.4,1.4,0.3]),
DataObject.new([5.0,3.4,1.5,0.2]),
DataObject.new([4.4,2.9,1.4,0.2]),
DataObject.new([4.9,3.1,1.5,0.1]),
DataObject.new([5.4,3.7,1.5,0.2]),
DataObject.new([4.8,3.4,1.6,0.2]),
DataObject.new([4.8,3.0,1.4,0.1]),
DataObject.new([4.3,3.0,1.1,0.1]),
DataObject.new([5.8,4.0,1.2,0.2]),
DataObject.new([5.7,4.4,1.5,0.4]),
DataObject.new([5.4,3.9,1.3,0.4]),
DataObject.new([5.1,3.5,1.4,0.3]),
DataObject.new([5.7,3.8,1.7,0.3]),
DataObject.new([5.1,3.8,1.5,0.3]),
DataObject.new([5.4,3.4,1.7,0.2]),
DataObject.new([5.1,3.7,1.5,0.4]),
DataObject.new([4.6,3.6,1.0,0.2]),
DataObject.new([5.1,3.3,1.7,0.5]),
DataObject.new([4.8,3.4,1.9,0.2]),
DataObject.new([5.0,3.0,1.6,0.2]),
DataObject.new([5.0,3.4,1.6,0.4]),
DataObject.new([5.2,3.5,1.5,0.2]),
DataObject.new([5.2,3.4,1.4,0.2]),
DataObject.new([4.7,3.2,1.6,0.2]),
DataObject.new([4.8,3.1,1.6,0.2]),
DataObject.new([5.4,3.4,1.5,0.4]),
DataObject.new([5.2,4.1,1.5,0.1]),
DataObject.new([5.5,4.2,1.4,0.2]),
DataObject.new([4.9,3.1,1.5,0.1]),
DataObject.new([5.0,3.2,1.2,0.2]),
DataObject.new([5.5,3.5,1.3,0.2]),
DataObject.new([4.9,3.1,1.5,0.1]),
DataObject.new([4.4,3.0,1.3,0.2]),
DataObject.new([5.1,3.4,1.5,0.2]),
DataObject.new([5.0,3.5,1.3,0.3]),
DataObject.new([4.5,2.3,1.3,0.3]),
DataObject.new([4.4,3.2,1.3,0.2]),
DataObject.new([5.0,3.5,1.6,0.6]),
DataObject.new([5.1,3.8,1.9,0.4]),
DataObject.new([4.8,3.0,1.4,0.3]),
DataObject.new([5.1,3.8,1.6,0.2]),
DataObject.new([4.6,3.2,1.4,0.2]),
DataObject.new([5.3,3.7,1.5,0.2]),
DataObject.new([5.0,3.3,1.4,0.2]),
DataObject.new([7.0,3.2,4.7,1.4]),
DataObject.new([6.4,3.2,4.5,1.5]),
DataObject.new([6.9,3.1,4.9,1.5]),
DataObject.new([5.5,2.3,4.0,1.3]),
DataObject.new([6.5,2.8,4.6,1.5]),
DataObject.new([5.7,2.8,4.5,1.3]),
DataObject.new([6.3,3.3,4.7,1.6]),
DataObject.new([4.9,2.4,3.3,1.0]),
DataObject.new([6.6,2.9,4.6,1.3]),
DataObject.new([5.2,2.7,3.9,1.4]),
DataObject.new([5.0,2.0,3.5,1.0]),
DataObject.new([5.9,3.0,4.2,1.5]),
DataObject.new([6.0,2.2,4.0,1.0]),
DataObject.new([6.1,2.9,4.7,1.4]),
DataObject.new([5.6,2.9,3.6,1.3]),
DataObject.new([6.7,3.1,4.4,1.4]),
DataObject.new([5.6,3.0,4.5,1.5]),
DataObject.new([5.8,2.7,4.1,1.0]),
DataObject.new([6.2,2.2,4.5,1.5]),
DataObject.new([5.6,2.5,3.9,1.1]),
DataObject.new([5.9,3.2,4.8,1.8]),
DataObject.new([6.1,2.8,4.0,1.3]),
DataObject.new([6.3,2.5,4.9,1.5]),
DataObject.new([6.1,2.8,4.7,1.2]),
DataObject.new([6.4,2.9,4.3,1.3]),
DataObject.new([6.6,3.0,4.4,1.4]),
DataObject.new([6.8,2.8,4.8,1.4]),
DataObject.new([6.7,3.0,5.0,1.7]),
DataObject.new([6.0,2.9,4.5,1.5]),
DataObject.new([5.7,2.6,3.5,1.0]),
DataObject.new([5.5,2.4,3.8,1.1]),
DataObject.new([5.5,2.4,3.7,1.0]),
DataObject.new([5.8,2.7,3.9,1.2]),
DataObject.new([6.0,2.7,5.1,1.6]),
DataObject.new([5.4,3.0,4.5,1.5]),
DataObject.new([6.0,3.4,4.5,1.6]),
DataObject.new([6.7,3.1,4.7,1.5]),
DataObject.new([6.3,2.3,4.4,1.3]),
DataObject.new([5.6,3.0,4.1,1.3]),
DataObject.new([5.5,2.5,4.0,1.3]),
DataObject.new([5.5,2.6,4.4,1.2]),
DataObject.new([6.1,3.0,4.6,1.4]),
DataObject.new([5.8,2.6,4.0,1.2]),
DataObject.new([5.0,2.3,3.3,1.0]),
DataObject.new([5.6,2.7,4.2,1.3]),
DataObject.new([5.7,3.0,4.2,1.2]),
DataObject.new([5.7,2.9,4.2,1.3]),
DataObject.new([6.2,2.9,4.3,1.3]),
DataObject.new([5.1,2.5,3.0,1.1]),
DataObject.new([5.7,2.8,4.1,1.3]),
DataObject.new([6.3,3.3,6.0,2.5]),
DataObject.new([5.8,2.7,5.1,1.9]),
DataObject.new([7.1,3.0,5.9,2.1]),
DataObject.new([6.3,2.9,5.6,1.8]),
DataObject.new([6.5,3.0,5.8,2.2]),
DataObject.new([7.6,3.0,6.6,2.1]),
DataObject.new([4.9,2.5,4.5,1.7]),
DataObject.new([7.3,2.9,6.3,1.8]),
DataObject.new([6.7,2.5,5.8,1.8]),
DataObject.new([7.2,3.6,6.1,2.5]),
DataObject.new([6.5,3.2,5.1,2.0]),
DataObject.new([6.4,2.7,5.3,1.9]),
DataObject.new([6.8,3.0,5.5,2.1]),
DataObject.new([5.7,2.5,5.0,2.0]),
DataObject.new([5.8,2.8,5.1,2.4]),
DataObject.new([6.4,3.2,5.3,2.3]),
DataObject.new([6.5,3.0,5.5,1.8]),
DataObject.new([7.7,3.8,6.7,2.2]),
DataObject.new([7.7,2.6,6.9,2.3]),
DataObject.new([6.0,2.2,5.0,1.5]),
DataObject.new([6.9,3.2,5.7,2.3]),
DataObject.new([5.6,2.8,4.9,2.0]),
DataObject.new([7.7,2.8,6.7,2.0]),
DataObject.new([6.3,2.7,4.9,1.8]),
DataObject.new([6.7,3.3,5.7,2.1]),
DataObject.new([7.2,3.2,6.0,1.8]),
DataObject.new([6.2,2.8,4.8,1.8]),
DataObject.new([6.1,3.0,4.9,1.8]),
DataObject.new([6.4,2.8,5.6,2.1]),
DataObject.new([7.2,3.0,5.8,1.6]),
DataObject.new([7.4,2.8,6.1,1.9]),
DataObject.new([7.9,3.8,6.4,2.0]),
DataObject.new([6.4,2.8,5.6,2.2]),
DataObject.new([6.3,2.8,5.1,1.5]),
DataObject.new([6.1,2.6,5.6,1.4]),
DataObject.new([7.7,3.0,6.1,2.3]),
DataObject.new([6.3,3.4,5.6,2.4]),
DataObject.new([6.4,3.1,5.5,1.8]),
DataObject.new([6.0,3.0,4.8,1.8]),
DataObject.new([6.9,3.1,5.4,2.1]),
DataObject.new([6.7,3.1,5.6,2.4]),
DataObject.new([6.9,3.1,5.1,2.3]),
DataObject.new([5.8,2.7,5.1,1.9]),
DataObject.new([6.8,3.2,5.9,2.3]),
DataObject.new([6.7,3.3,5.7,2.5]),
DataObject.new([6.7,3.0,5.2,2.3]),
DataObject.new([6.3,2.5,5.0,1.9]),
DataObject.new([6.5,3.0,5.2,2.0]),
DataObject.new([6.2,3.4,5.4,2.3]),
DataObject.new([5.9,3.0,5.1,1.8])]

  lowestSSE = 10000000
  for i in (2..Math.log(objects.length)) #experimentally found to reasonably well at providing a reasonable max k
    cumulativeSSE = 0
    for j in (1..10) #run 10 times for each k
      kMeans = KMeans.new()
      cumulativeSSE = cumulativeSSE + kMeans.run(objects, i, false)
      if(cumulativeSSE/10.to_f() < lowestSSE)
        k = i
      end
    end
  end

  puts "Ideal K is #{k}!"
  kMeans.run(objects, k, true)

end