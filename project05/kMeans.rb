require 'similarity_metrics.rb'
require 'dataObject.rb'

class KMeans
  def run(objects, k)
    puts objects
    puts "#{k} centroids"

    centroids = initCentroids(objects, k)
    print(centroids)

    i = 0
=begin
    objects.each do |obj|
      obj.setCentroid(i)
      i = i + 1
    end

    objects.each do |obj|
      puts(obj.getCentroid())
    end
=end
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
    puts minBounds
    puts maxBounds
    centroids = Array.new(k)
    r = Random.new
    for i in (0..k-1)
      center = Array.new(len)
      for j in (0..len-1)
        center[j] = rand(maxBounds[j] - minBounds[j]) + minBounds[j]
      end
      centroids[i] = center
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

  objects = [DataObject.new([1, 2]),
    DataObject.new([1, 3]),
    DataObject.new([1, 3]),
    DataObject.new([4, 5]),
    DataObject.new([7, 8])]

  kMeans = KMeans.new()
  kMeans.run(objects, 3)

end