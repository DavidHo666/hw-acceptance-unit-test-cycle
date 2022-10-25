require 'rails_helper'

RSpec.describe MoviesController, type: :controller do

  context "GET: Show" do
    before :each do
      @new_movie = {title: 'Top Gun', rating: 'PG', director: 'Joseph Kosinski', release_date: Date.new(2022, 5, 27)}
      Movie.create(@new_movie)
      @after_created_movie = Movie.find_by_title(@new_movie[:title])
    end

    it "show a movie" do
      get :show, id: @after_created_movie.id
      expect(assigns(:movie)).to eq(@after_created_movie)
    end
  end

  context "GET: Index" do
    before :each do
      @new_movie = {title: 'Top Gun', rating: 'PG', director: 'Joseph Kosinski', release_date: Date.new(2022, 5,27)}
      Movie.create(@new_movie)
      @new_movie = {title: 'Avatar', rating: 'PG', director: 'James Cameron', release_date: Date.new(2009, 12, 18)}
      Movie.create(@new_movie)
      @movies = Movie.all
    end
    it 'show all movies' do
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:movies)).to eq(@movies)
    end
  end

  context "GET: new" do
    it 'render new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  context "POST: Creat" do
    before :each do
      @new_movie = {title: 'Top Gun', rating: 'PG', director: 'Joseph Kosinski', release_date: Date.new(2022, 5, 27)}
      @before_created = Movie.find_by_title(@new_movie[:title])
    end

    it "create a movie" do
      expect(@before_created).to eq(nil)
      post :create, movie: @new_movie
      after_created = Movie.find_by_title(@new_movie[:title])
      expect(assigns(:movie)).to eq(after_created)
      expect(flash[:notice]).to eq("#{@new_movie[:title]} was successfully created.")
      expect(response).to redirect_to(movies_path)
    end
  end

  context "GET: edit" do
    before :each do
      @new_movie = {title: 'Top Gun', rating: 'PG', director: 'Joseph Kosinski', release_date: Date.new(2022, 5, 27)}
      Movie.create(@new_movie)
      @after_created_movie = Movie.find_by_title(@new_movie[:title])
    end

    it "edit a movie" do
      get :edit, id: @after_created_movie.id
      expect(assigns(:movie)).to eq(@after_created_movie)
      expect(response).to render_template(:edit)
    end
  end


  context "PUT: update" do
    before :each do
      @new_movie = {title: 'Avatar', rating: 'PG', director: 'James Cameron', release_date: Date.new(2009, 12, 18)}
      @after_created_movie = Movie.create(@new_movie)
    end

    it "update a movie" do
      new_params = {title: 'Avatar 2', release_date: Date.new(2022, 12, 6)}
      put :update, id: @after_created_movie.id, movie: new_params
      after_updated_movie = Movie.find_by(@after_created_movie.id)
      expect(assigns(:movie)).to eq(after_updated_movie)
      expect(flash[:notice]).to eq("#{new_params[:title]} was successfully updated.")
      expect(response).to redirect_to(movie_path(after_updated_movie))
    end
  end


  context "DELETE: destroy" do
    before :each do
      @new_movie = {title: 'Avatar', rating: 'PG', director: 'James Cameron', release_date: Date.new(2009, 12, 18)}
      @after_created_movie = Movie.create(@new_movie)
    end

    it "Should be destroy a movie" do
      delete :destroy, id: @after_created_movie.id
      expect(flash[:notice]).to eq("Movie '#{@after_created_movie.title}' deleted.")
      expect(response).to redirect_to(movies_path)
      after_destroy = Movie.find_by_title('Top Gun')
      expect(after_destroy).to eq(nil)
    end
  end


  context "Similar Movies" do
    before :each do
      Movie.create(title: 'Top Gun', rating: 'PG', director: 'Joseph Kosinski', release_date: Date.new(2022, 5, 27))
      Movie.create(title: 'Avatar', rating: 'PG', director: 'James Cameron', release_date: Date.new(2009, 12, 18))
      Movie.create(title: 'Avatar 2', rating: 'PG', director: 'James Cameron', release_date: Date.new(2022, 12, 6))
      Movie.create(title: 'unknow movie', rating: 'PG', director: nil, release_date: Date.new(2022, 12, 6))
    end

    it "show similar movies" do
      the_movie = Movie.find_by_title('Avatar 2')
      get :similar, id: the_movie.id
      expect(response).to render_template(:similar)
      assigns(:similar_movies).each do |movie|
        expect(movie.director).to eq('James Cameron')
      end
      expect(response).to render_template(:similar)
    end

    it "redirect to movie path" do
      movie = Movie.find_by_title('unknow movie')
      get :similar, id: movie.id
      expect(response).to redirect_to(movies_path)
      expect(flash[:notice]).to eq("'#{movie.title}' has no director info")
    end
  end



end