class PlacesController < ApplicationController

	def show
		@place = Place.find(params[:id]) rescue nil
		redirect_to root_url if @place.nil? and return

		respond_to do |format|
			format.html
			format.json{render :json => @place.to_json(:include => {:categories => {:only => :name}})}
		end

	end

	def index
		places_list = []

		Place.all.each do | p |
			places_list<<
			{
			  type: 'Feature',
			  geometry: {
				  type: 'Point',
				  coordinates: [p.longitude, p.latitude]
			  },
			  properties: {
				  title: p.name,
				  description: p.name,
				  'marker-size' => 'small',
				  'marker-color' => '#f0a',
				  id: p.id
			  }
			}
		end


		places = {
			type: "FeatureCollection",
			id:'ghholt.map-7po6ov6d',
			"features" => places_list
		}

		respond_to do |format|
			format.json{render :json => places}
		end
	end
end
