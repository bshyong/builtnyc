class PlacesController < ApplicationController

	def show
		@place = Place.find(params[:id]) rescue nil 
		redirect_to root_url if @place.nil?
	end

end
