class Place < ActiveRecord::Base

  has_and_belongs_to_many :categories

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
