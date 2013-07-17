class PagesController < ApplicationController


def index
  @place = Place.first
end

end
