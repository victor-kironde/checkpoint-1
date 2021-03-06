class Song < BaseModel
  extend Concerns::Findable
  attr_accessor :name
  attr_reader :artist, :genre
  @all = []

  def initialize(name, artist = nil, genre = nil)
    super(name)
    self.artist = artist if artist
    self.genre = genre if genre
  end

  def artist=(value)
    @artist = value
    @artist.add_song(self)
  end

  def genre=(value)
    @genre = value
    @genre.songs.push(self) unless @genre.songs.include? self
  end

  def self.new_from_filename(filename)
    song_instance = filename.gsub(".mp3", "").split(' - ')
    if song_instance.size == 3
      new(
        song_instance[1],
        Artist.find_or_create_by_name(song_instance[0]),
        Genre.find_or_create_by_name(song_instance[2])
         )
    else
      new(song_instance[0])
    end
  end

  def self.create_from_filename(filename)
    new_from_filename(filename).save
  end
end
