require 'similarity_metrics.rb'
require 'dataObject.rb'

class KMeans
  def run(objects, k)
    puts objects
    puts "#{k} centroids"

    centroids = initCentroids(objects, k)
    puts(centroids)

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
    bounds = Array.new(len)

    objects.each do |obj|
      j = 0
      obj.values.each do |val|
        value = val
        if(bounds[j].nil? || bounds[j] < value)
          bounds[j] = value
        end
        j = j + 1
      end
    end
    puts bounds
  end
end

if(__FILE__ == $0)

  objects = [DataObject.new([1, 2, 3]),
    DataObject.new([1, 3, 5]),
    DataObject.new([1, 3, 4]),
    DataObject.new([4, 5, 10]),
    DataObject.new([7, 8, 9])]

  kMeans = KMeans.new()
  kMeans.run(objects, 3)

end