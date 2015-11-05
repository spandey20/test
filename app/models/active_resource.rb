require 'open-uri'
class ActiveResource
	attr_accessor :url, :response, :params
	def execute
		final_url = url + (url.include?('?') ? '&' : '?') + stringify_params
		# final_url = 'http://ws.audioscrobbler.com/2.0/?api_key=1ca2cf614eeaa185c2b61753b434b599&method=artist.getinfo&mbid=614e3804-7d34-41ba-857f-811bad7c2b7a&format=json'
		puts 'Url resource: ', final_url
		@response = JSON.load(open(final_url))
	end

	def filter filters
		@params ||= {}
		@params.merge! filters
	end

	def response
		@response || execute
	end

	def url
		@url || @url = ''
	end

	private

	def stringify_params
		params.map{|k, v| "#{k}=#{v}"}.join('&')
	end
end