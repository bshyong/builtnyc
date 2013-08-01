class PlacesController < ApplicationController

	def show
		@place = Place.find(params[:id]) rescue nil
		redirect_to root_url if @place.nil? and return

		respond_to do |format|
			format.html
			format.json{render :json => @place.to_json(:include => {:categories => {:only => :name}})}
		end

	end

	def new
		@place = Place.new
	end

	def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render action: 'show', status: :created, location: @place }
      else
        format.html { render action: 'new' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
	end

	def index
		places_list = []

		Place.where('latitude IS NOT NULL').where('longitude IS NOT NULL').each do | p |
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:summary, :year_built, :image_url, :arch_style, :gov_body, :nrhp_ref, :name, :address, :zipcode, :city, :state)
    end
end
