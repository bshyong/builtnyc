# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :firm do
    name "MyString"
    url "MyString"
    principals "MyText"
    address "MyString"
    zipcode "MyString"
    city "MyString"
    state "MyString"
  end
end
