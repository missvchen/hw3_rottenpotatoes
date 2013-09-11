# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!({ :title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"], :director => movie["director"] })
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
    rating = rating.gsub(/\s/, '')
    if uncheck == nil || uncheck.empty?	# uncheck returns "un" if uncheck
      check("ratings_#{rating}")
    else
      uncheck("ratings_#{rating}")
    end
  end
end

When /I (un)?check all of the ratings/ do |uncheck|
  "G,PG,PG-13,R".split(',').each do |rating|
    if uncheck == nil || uncheck.empty?
      check("ratings_#{rating}")
    else
      uncheck("ratings_#{rating}")
    end
  end
end

Then /I should see movies with the following ratings: (.*)/ do |rating_list|
  rating_list.split(",").each do |rating|
    rating = rating.gsub(/\s/, '')
    if page.respond_to? :should
      page.should have_selector("td", :text => /^#{rating}$/, :count => Movie.where("rating = ?", rating).count)
    else
      assert page.has_selector("td", :text => /^#{rating}$/, :count => Movie.where("rating = ?", rating).count)
    end
  end
end

Then /I should not see movies with the following ratings: (.*)/ do |rating_list|
  rating_list.split(",").each do |rating|
    rating = rating.gsub(/\s/, '')
    if page.respond_to? :should
      page.should_not have_selector("td", :text => /^#{rating}$/)
    else
      assert page.has_no_selector("td", :text => /^#{rating}$/)
    end
  end
end

Then /I should see no movies/ do
  if page.respond_to? :should_not
    page.should_not have_css("tbody tr")
  else
    assert page.has_no_css("tbody tr")
  end
end

Then /I should see all of the movies/ do
  if page.respond_to? :should
    page.should have_css("tbody tr", :count => Movie.count)
  else
    assert page.has_css("tbody tr", :count => Movie.count)
  end
end

Then /I should see '(.*)' before '(.*)'/ do |first_title, second_title|
  titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
  assert titles.index(first_title) < titles.index(second_title)
end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  movie = Movie.find_by_title(title)
  movie.director.should eq director
end

