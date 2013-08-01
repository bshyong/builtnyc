class Place < ActiveRecord::Base

  has_and_belongs_to_many :categories
  belongs_to :firm
  validates :name, :address, :summary, :presence => {:message => "This field cannot be blank!"}

  def summary
    begin
      "Summary: <br />" + super
    rescue
      "Summary: <br /> No Summary"
    end
  end

  def image_url
    super.blank? ? "http://placehold.it/250x355&text=No+image+:(" : super
  end

end
