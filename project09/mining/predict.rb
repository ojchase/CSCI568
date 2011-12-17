#!/usr/local/bin/ruby

require 'rubygems'
require 'active_record'

#
# Configuration
#
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :host => 'localhost',
  :database => 'kddTrack1.db'
)

class Artist < ActiveRecord::Base
  has_many :albums
  has_many :tracks
end

class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :tracks
  has_many :album_genres
  has_many :genres, :through => :album_genres
end

class Track < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  
  has_many :genre_tracks
  has_many :genres, :through => :genre_tracks
end

class Genre < ActiveRecord::Base
  has_many :album_genres
  has_many :albums, :through => :album_genres
  
  has_many :genre_tracks
  has_many :tracks, :through => :genre_tracks
end

class AlbumGenre < ActiveRecord::Base
  belongs_to :album
  belongs_to :genre
end

class GenreTrack < ActiveRecord::Base
  belongs_to :genre
  belongs_to :track
end

class User
  @id  
  @ratings
  @trackRatings
  @genreRatings
  @albumRatings
  @artistRatings
  
  def id()
    return @id
  end
  
  def initialize(id)
    @id = id
    @trackRatings = {}
    @albumRatings = {}
    @genreRatings = {}
    @artistRatings = {}
  end
  
  def addRating(itemID, rating)
    type = convertItemToType(itemID)
    if type == "Album"
      @albumRatings[itemID] = rating
    elsif type == "Artist"
      @artistRatings[itemID] = rating
    elsif type == "Genre"
      @genreRatings[itemID] = rating
    elsif type == "Track"
      @trackRatings[itemID] = rating
    end
  end
  
  def predict(itemID)
    type = convertItemToType(itemID)
    if type == "Album"
      return predictAlbum(itemID)
      #return 50
    elsif type == "Artist"
      return predictArtist(itemID)
    elsif type == "Genre"
      return predictGenre(itemID)
    elsif type == "Track"
      return predictTrack(itemID)
      #return 50
    end
  end

  def predictArtist(artistID)
    guess1 = predictArtistFromAlbums(artistID)
    guess2 = predictArtistFromTracks(artistID)
    if(guess1 == -1 && guess2 == -1)
      return 50
    else
      if(guess1 != -1 && guess2 != -1)
        return (guess1 + guess2) / 2
      end
      return [guess1, guess2].max #the one with a value
    end
  end
  
  def predictGenre(genreID)
    guess1 = predictGenreFromAlbums(genreID)
    guess2 = predictGenreFromTracks(genreID)
    if(guess1 == -1 && guess2 == -1)
      return 50
    else
      if(guess1 != -1 && guess2 != -1)
        return (guess1 + guess2) / 2
      end
      return [guess1, guess2].max #the one with a value
    end
  end
  
  # The next four methods are almost the same, except for which list they reference
  # and how the variables are named.  You probably want to glaze over them
  def predictArtistFromAlbums(artistID)
    ratedAlbumsFromThisArtist = []
    @albumRatings.each do |album|
      albumID = album[0]
      albumArtist = Album.find(albumID).artist
      if albumArtist != nil && albumArtist.id.to_s == artistID.to_s
        ratedAlbumsFromThisArtist.push(albumID)
      end
    end
    
    numOfRatings = ratedAlbumsFromThisArtist.length
    if(numOfRatings == 0)
      return -1 #if no other guess
    end
    ratingSum = 0
    ratedAlbumsFromThisArtist.each do |albumID|
      ratingSum += @albumRatings[albumID].to_f
    end
    result = ratingSum / numOfRatings.to_f
    #puts "album result: #{result}"
    return result
  end
  
  def predictArtistFromTracks(artistID)
    ratedTracksFromThisArtist = []
    @trackRatings.each do |track|
      trackID = track[0]
      trackArtist = Track.find(trackID).artist
      if trackArtist != nil && trackArtist.id.to_s == artistID.to_s
        ratedTracksFromThisArtist.push(trackID)
      end
    end
    
    numOfRatings = ratedTracksFromThisArtist.length
    if(numOfRatings == 0)
      return -1 #if no other guess
    end
    ratingSum = 0
    ratedTracksFromThisArtist.each do |trackID|
      ratingSum += @trackRatings[trackID].to_f
    end
    result = ratingSum / numOfRatings.to_f
    #puts "track result: #{result}"
    return result
  end
  
  def predictGenreFromAlbums(genreID)
    ratedAlbumsFromThisGenre = []
    @albumRatings.each do |album|
      albumID = album[0]
      albumGenres = Album.find(albumID).genres
      albumGenres.each do |genre|
        if genre != nil && genre.id.to_s == genreID.to_s
          ratedAlbumsFromThisGenre.push(albumID)
        end
      end
    end
    
    numOfRatings = ratedAlbumsFromThisGenre.length
    #puts numOfRatings
    if(numOfRatings == 0)
      return -1 #if no other guess
    end
    ratingSum = 0
    ratedAlbumsFromThisGenre.each do |albumID|
      ratingSum += @albumRatings[albumID].to_f
    end
    result = ratingSum / numOfRatings.to_f
    #puts "album result: #{result}"
    return result
  end
  
  def predictGenreFromTracks(genreID)
    #return 50 #this doesn't work since the activerecord problems aren't connecting genres to tracks
    ratedTracksFromThisGenre = []
    @trackRatings.each do |track|
      trackID = track[0]
      trackGenres = Track.find(trackID).genres
      trackGenres.each do |genre|
        if trackGenre != nil && genre.id.to_s == genreID.to_s
          ratedTracksFromThisGenre.push(trackID)
        end
      end
    end
    #this isn't working so we'll just save the processing time and return an error now
    return -1 
=begin 
    numOfRatings = ratedTracksFromThisGenre.length
    puts numOfRatings
    if(numOfRatings == 0)
      return -1 #if no other guess
    end
    ratingSum = 0
    ratedTracksFromThisGenre.each do |trackID|
      ratingSum += @trackRatings[trackID].to_f
    end
    result = ratingSum / numOfRatings.to_f
    #puts "track result: #{result}"
    return result
=end
  end
  
  def predictAlbum(albumID)
    if @albumRatings.length == 0
      return 50 #eh, it's a decent pure guess
    end
    
    albumToPredict = Album.find(albumID)
    albumSimilarities = {}
    @albumRatings.each do |album|
      albumID = album[0]
      similarityScore = jaccardAlbums(Album.find(albumID), albumToPredict)
      albumSimilarities[albumID] = similarityScore
    end
    
    albumSimilarities.sort_by {|albumID, similarityScore| similarityScore}
    #puts albumSimilarities.inspect
      
    #KNN most similar albums:
    numAlbumsToUse = [0.1*albumSimilarities.size, 5].min #we want 5 nearest neighbors, and we'll also limit to the closest 10%
    ratingSum = 0
    for similarAlbum in 0...numAlbumsToUse-1
      albumID = albumSimilarities.keys[similarAlbum]
      rating = @albumRatings[albumID]
      ratingSum += rating.to_i
    end
    return ratingSum / numAlbumsToUse.to_f
  end
  
  def predictTrack(trackID)
    if @trackRatings.length == 0
      return 50 #eh, it's a decent pure guess
    end
    
    trackToPredict = Track.find(trackID)
    trackSimilarities = {}
    @trackRatings.each do |track|
      trackID = track[0]
      similarityScore = jaccardTracks(Track.find(trackID), trackToPredict)
      trackSimilarities[trackID] = similarityScore
    end
    
    trackSimilarities.sort_by {|trackID, similarityScore| similarityScore}
    #puts trackSimilarities.inspect
      
    #KNN most similar tracks:
    numTracksToUse = [0.1*trackSimilarities.size, 5].min #we want 5 nearest neighbors, and we'll also limit to the closest 10%
    ratingSum = 0
    for similarTrack in 0...numTracksToUse-1
      trackID = trackSimilarities.keys[similarTrack]
      rating = @trackRatings[trackID]
      ratingSum += rating.to_i
    end
    return ratingSum / numTracksToUse.to_f
  end
  
  def to_s()
    result = @id + ":\n"
    result += @ratings.to_s + "\n"
    return @ratings
  end
end

def convertItemToType(id)
  if(Track.exists? id)
    return "Track"
  elsif(Artist.exists? id)
    return "Artist"
  elsif(Album.exists? id)
    return "Album"
  elsif(Genre.exists? id)
    return "Genre"
  end
end

#Takes in two lists of genres and finds how many matches and distinct genres are in it
#Used for Jaccard calculations, as similarity is roughly matches/unique
def genreMatchCount(genreList1, genreList2)
  matches = 0
  unique = genreList1.length
  genreList2.each do |genre|
      if(genreList1.exists? genre)
        matches += 1
      else
        unique += 1
      end
  end
  return matches, unique
end

def jaccardTracks(track1, track2)
  compareableFields = 0 # just a count of the total number of attributes being compared
                        # possibly an artist, possibly album, 0+ genres
  matchingFields = 0
  if !(track1.artist == nil && track2.artist == nil)
    compareableFields += 1
    if(track1.artist == track2.artist)
      matchingFields += 1
    end
  end
  if !(track1.album == nil && track2.album == nil)
    compareableFields += 1
    if(track1.album == track2.album)
      matchingFields += 1
    end
  end
  
=begin
  #I couldn't get tracks to genres to work correctly, so we have to go through the album
  #Or not, this doesn't actually do what I expected
  if(track1.album != nil)
    if(track2.album != nil)
      genreMatching = genreMatchCount(track1.album.genres, track2.album.genres)
      matchingFields += genreMatching[0]
      compareableFields += genreMatching[1]
    else 
      compareableFields += track1.album.genres.length
    end
  else
    if(track2.album != nil)
      compareableFields += track2.album.genres.length
    #else no genres for either, no changes
    end
  end
=end
  
  genreMatching = genreMatchCount(track1.genres, track2.genres)
  matchingFields += genreMatching[0]
  compareableFields += genreMatching[1] 

  if compareableFields == 0 #this is possible, if neither track had any info
    return 0.5 #arbitrary
  else
    return matchingFields.to_f / compareableFields
  end
end

def jaccardAlbums(album1, album2)
  compareableFields = 0 # just a count of the total number of attributes being compared
                        # possibly an artist, 0+ genres
  matchingFields = 0
  if !(album1.artist == nil && album2.artist == nil)
    compareableFields += 1
    if(album1.artist == album2.artist)
      matchingFields += 1
    end
  end
  
  genreMatching = genreMatchCount(album1.genres, album2.genres)
  matchingFields += genreMatching[0]
  compareableFields += genreMatching[1] 
  
  if compareableFields == 0 #this is possible, if neither album had any info
    return 0.5 #arbitrary
  else
    return matchingFields.to_f / compareableFields
  end
end

=begin
puts "All right! Here's the requested info:"
puts jaccardTracks(Track.find(18), Track.find(28460))

tracks = Track.all
tracks.each do |track|
  puts "#{track.id} has these genres:"
  track.genres.each do |genre|
    puts genre.id
  end
end
=end
  
users = {}
  
trainingDataFile = File.new("trainingData.txt", "r")
while (line = trainingDataFile.gets)
  info = line.split("\t")
  userID = info[0]
  itemID = info[1]
  rating = info[2]
  if users.has_key?  userID
    users[userID].addRating(itemID, rating)
  else
    newUser = User.new(userID)
    newUser.addRating(itemID, rating)
    users[userID] = newUser
  end
end

trainingDataFile = File.new("validationData.txt", "r")
while (line = trainingDataFile.gets)
  info = line.chomp!.split("\t")
  userID = info[0]
  itemID = info[1]
  rating = info[2]
  if users.has_key?  userID
    users[userID].addRating(itemID, rating)
  else
    newUser = User.new(userID)
    newUser.addRating(itemID, rating)
    users[userID] = newUser
  end
end

#puts users.first[1].predictTrack(554898)

puts "Let's try to confirm existing ratings."
validationtrainingDataFile = File.new("validationData.txt", "r")
while (line = validationtrainingDataFile.gets)
  info = line.chomp!.split("\t")
  userID = info[0]
  itemID = info[1]
  rating = info[2]
  puts "User #{userID}, #{convertItemToType(itemID)} #{itemID}, Predicted: " + users[userID].predict(itemID).to_s + ", should be #{rating}"
end

puts "Time to make some predictions!!!"
testingDataFile = File.new("testData.txt", "r")
while (line = testingDataFile.gets)
  info = line.chomp!.split("\t")
  userID = info[0]
  itemID = info[1]
  puts "User #{userID}, #{convertItemToType(itemID)} #{itemID}, Predicted: " + users[userID].predict(itemID).to_s
end