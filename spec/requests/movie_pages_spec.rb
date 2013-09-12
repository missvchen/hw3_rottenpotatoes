require 'spec_helper'

describe "Movie pages" do
  subject { page }

  describe "details page" do
    let(:movie) { FactoryGirl.create(:movie) }
    before { visit movie_path(movie) }

    it { should have_content(movie.title) }
    it { should have_content(movie.rating) }
    it { should have_content(movie.release_date.strftime("%B %d, %Y")) }
    it { should have_content(movie.director) }
    it { should have_link("Edit", :href => edit_movie_path(movie)) }
    it { should have_link("Back to movie list", :href => movies_path) }
    it { should have_link("Find Movies With Same Director", :href => same_director_path(movie)) }

    describe "find movies with same director" do
      describe "when movie director is nil" do
        before do
          movie.director = nil
          movie.save!

	  click_link "Find Movies With Same Director"
	end

        it { should have_content("All Movies") }
	it { should have_content("'#{movie.title}' has no director info") }
      end

      describe "when movie director is empty" do
        before do
          movie.director = ""
          movie.save!

	  click_link "Find Movies With Same Director"
	end

        it { should have_content("All Movies") }
	it { should have_content("'#{movie.title}' has no director info") }
      end

      describe "when movie director is non-empty" do
	let(:second_movie) { FactoryGirl.create(:movie, :title => "Second movie") }
	before do
	  second_movie.save!

	  click_link "Find Movies With Same Director"
	end

        it { should have_content("Movies by #{movie.director}") }
	it { should have_content(second_movie.title) }
      end
    end
  end

  describe "edit page" do
    let(:movie) { FactoryGirl.create(:movie) }
    before { visit edit_movie_path(movie) }

    specify { find_field("movie[title]").value.should eq movie.title }
    specify { find_field("movie[rating]").value.should eq movie.rating }
    specify { find_field("movie[release_date(1i)]").value.should eq movie.release_date.year.to_s }
    specify { find_field("movie[release_date(2i)]").value.should eq movie.release_date.month.to_s }
    specify { find_field("movie[release_date(3i)]").value.should eq movie.release_date.day.to_s }
    specify { find_field("movie[director]").value.should eq movie.director }

    describe "update movie" do
      describe "with valid information" do
        let(:new_title) { "New Title" }
        let(:new_rating) { "R" }
	let(:new_release_year) { 1.year.ago }
	let(:new_release_month) { 1.month.ago }
	let(:new_release_day) { 1.day.ago }
	let(:new_director) { "New Director" }

        before do
          fill_in "Title", :with => new_title
          select new_rating, :from => "Rating"
          select new_release_year.strftime("%Y"), :from => "movie[release_date(1i)]"
          select new_release_month.strftime("%B"), :from => "movie[release_date(2i)]"
          select new_release_day.strftime("%-d"), :from => "movie[release_date(3i)]"
          fill_in "Director", :with => new_director
          click_button "Update Movie Info"
        end

        specify { expect(movie.reload.title).to eq new_title }
        specify { expect(movie.reload.rating).to eq new_rating }
        specify { expect(movie.reload.release_date).to eq Date.new(new_release_year.strftime("%Y").to_i, new_release_month.strftime("%m").to_i, new_release_day.strftime("%d").to_i) }
        specify { expect(movie.reload.director).to eq new_director }
      end
    end
  end
end
