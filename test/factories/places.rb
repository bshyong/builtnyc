# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do
    summary "MyText"
    year_built "MyString"
    image_url "MyString"
    arch_style "MyString"
    gov_body "MyString"
    nhrp_ref "MyString"
  end
end
