FactoryGirl.define do
  factory :movie do
    title "Movie Title"
    rating "G"
    release_date Date.today
    director "Movie Director" 
  end
end
