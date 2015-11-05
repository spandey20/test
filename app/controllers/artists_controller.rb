class ArtistsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @recent = LocalCache.get(current_user.id) || []
  end

  def show
    @artist = Artist.find(params[:id])
    @recent = LocalCache.get(current_user.id) || []    
    @recent.push(@artist.get_basic_artist)
    @recent = @recent.reverse.uniq.reverse
    @recent.shift 1 if @recent.size > 6
    LocalCache.set(current_user.id, @recent)
    @recent = @recent.select{|v| v.mbid != @artist.mbid}
  end

  def search
    artists = Artist.search(params[:term])
    render :json => artists.select{|v| !v.mbid.blank? }.as_json
  end
end
