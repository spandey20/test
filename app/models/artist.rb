class Artist
	attr_accessor :name, :image, :mbid, :similar_artists, :listeners, :tracks, :albums


 	def similar_artists
 		@similar_artists || @similar_artists = LastFm.fetch_similar_artist(self.mbid)
 	end

 	def self.search(query)
 		LastFm.prepare_artist_search(query.gsub(' ', '+')).get_basic_artists
 	end

 	def self.find(id)
 		LastFm.get_artist id
 	end

 	def albums
 		@albums || @albums = LastFm.fetch_top_albums(mbid)
 	end
	
	def tracks
 		@tracks || @tracks = LastFm.fetch_top_tracks(mbid)
 	end

 	def get_basic_artist
 		a = Artist.new
 		a.name  = self.name
 		a.mbid = self.mbid
 		a.image = self.image
 		a
 	end

 	def eql?(art)
 		art.mbid.eql? self.mbid
 	end

 	def hash
 		mbid.hash
 	end
end