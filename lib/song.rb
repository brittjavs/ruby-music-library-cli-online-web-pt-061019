require 'pry'
class Song
  attr_accessor :name, :artist, :genre
  @@all = []
  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.genre = genre if genre != nil
    self.artist=(artist) if artist != nil
  end
  
  def self.all
    @@all.uniq
  end
  
  def self.destroy_all
    @@all.clear
  end
  
  def save
    @@all << self
  end
  
  def self.create(name)
    new_song = Song.new(name)
    new_song.save
    new_song
  end

  def artist= (artist)
    @artist = artist
    artist.add_song(self)
  end
  
  def genre= (genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)
  end
  
  def self.find_by_name(name)
    @@all.find{|song| song.name == name}
  end
  
  def self.find_or_create_by_name(name)
    self.find_by_name(name) || self.create(name)
  end
  
  def self.new_from_filename(file)
    name = file.split(" - ")[1]
    artist = file.split(" - ")[0]
    genre = file.split(" - ")[2].chomp(".mp3")
    new_song_file = self.find_or_create_by_name(name)
    new_song_file.artist = Artist.find_or_create_by_name(artist)
    new_song_file.genre = Genre.find_or_create_by_name(genre)
    new_song_file 
  end
  
  def self.create_from_filename(file)
    @@all << Song.new_from_filename(file)
  end
    
end