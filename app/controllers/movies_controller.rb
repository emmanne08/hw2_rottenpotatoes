class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = case params[:sort]
              when 'title'
                @title_hilite = 'hilite'
                Movie.order('title')
              when 'release_date'
                @release_date_hilite = 'hilite'
                Movie.order('release_date')
              else
                Movie
              end

    @all_ratings, temp_hash = Movie.all_ratings, {:commit => 'Refresh'}
    @movies = if params[:commit] == 'Refresh'
                if params[:ratings]
                  @checked_ratings = params[:ratings].keys
                  @checked_ratings.each {|x| temp_hash["ratings[#{x}]".to_sym] = 1}
                  @title_href, @release_date_href = {:sort => 'title'}, {:sort => 'release_date'}
                  @title_href.merge! temp_hash
                  @release_date_href.merge! temp_hash
                  @movies.find_all_by_rating(@checked_ratings)
                else
                  @checked_ratings = []
                  []
                end
              else # case where /movies is the requested URI
                @all_ratings.each {|x| temp_hash["ratings[#{x}]".to_sym] = 1}
                redirect_to movies_path(temp_hash)
              end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
