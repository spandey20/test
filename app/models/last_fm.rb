 class LastFm < ActiveResource
 	BASE_URL = YAML.load_file(Rails.root.join('config/last_fm.yml'))[Rails.env]['base_url']
 	API_KEY = YAML.load_file(Rails.root.join('config/last_fm.yml'))[Rails.env]['api_key']
 	def initialize(url = BASE_URL)
 		@url = url
 		filter(api_key: API_KEY, format: 'json')
 	end

 	def self.prepare_artist_search(query)
 		res = self.new
 		res.filter(method: 'artist.search', artist: query)
 		res
 	end

 	def get_basic_artists
 		res = []
 		response['results']['artistmatches']['artist'].each do |art|
 			next if art['mbid'].blank?
 			a = Artist.new
 			LastFm.assign_basic_artist art, a
 			a.listeners = art['listeners']
 			res.push a
 		end
 		res 		
 	end

 	def self.fetch_similar_artist(mbid)
 		res = self.new
 		res.filter(method: 'artist.getSimilar', mbid: mbid)
 		similar = []
 		res.response['similarartists']['artist'].each do|art|
	 		a = Artist.new
	 		similar.push assign_basic_artist art, a
 		end	
 		similar
 	end

 	def self.get_artist(mbid)
 		res = self.new
 		res.filter(method: 'artist.getInfo', mbid: mbid)
 		a = Artist.new
 		assign_basic_artist res.response['artist'], a
 		a.listeners = res.response['artist']['stats']['listeners']
 		a
 	end

 	def self.fetch_top_albums(mbid)
 		res = self.new
 		res.filter(method: 'artist.getTopAlbums', mbid: mbid)
 		albums = []
 		res.response['topalbums']['album'].each do |album|
 			a = Album.new
 			a.name = album['name']
 			a.playcount = album['playcount']
 			albums.push a
 		end
 		albums
 	end

 	 def self.fetch_top_tracks(mbid)
 		res = self.new
 		res.filter(method: 'artist.getTopTracks', mbid: mbid)
 		tracks = []
 		res.response['toptracks']['track'].each do |track|
 			a = Track.new
 			a.name = track['name']
 			a.playcount = track['playcount']
 			tracks.push a
 		end
 		tracks
 	end

 	def limit(val)
 		filter(limit: val)
 	end

 	private

 	def self.assign_basic_artist data, artist
 		artist.name = data['name']
 		artist.mbid = data['mbid']
 		artist.image = data['image'].select{|img| img['size'] == 'large'}.first['#text'] rescue res.response['artist']['image'].first['#text']
 		artist
 	end
 end