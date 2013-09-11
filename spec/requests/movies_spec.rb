require 'spec_helper'

describe "Movies" do
  describe "edit movie page" do
    let(:movie) { FactoryGirl.create(:movie) }
    before { visit edit_movie_path(movie) }

    it "should have the title" do
      page.find_field("movie[title]").value.should eq movie.title
    end

    it "should have the rating" do
      page.find_field("movie[rating]").value.should eq movie.rating
    end

    it "should have the release date year" do
      page.find_field("movie[release_date(1i)]").value.should eq movie.release_date.year.to_s
    end

    it "should have the release date month" do
      page.find_field("movie[release_date(2i)]").value.should eq movie.release_date.month.to_s
    end

    it "should have the release date day" do
      page.find_field("movie[release_date(3i)]").value.should eq movie.release_date.day.to_s
    end

    it "should have the director" do
      page.find_field("movie[director]").value.should eq movie.director
    end

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
