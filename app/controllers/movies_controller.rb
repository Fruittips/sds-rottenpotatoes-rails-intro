class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
    @ratings_to_show_hash = @all_ratings

    hash_ratings = params[:ratings]
    if (!hash_ratings.nil?)
      @ratings_to_show_hash = []
      params[:ratings].each_key {|key|
      @ratings_to_show_hash.append(key)}
      session[:ratings] = @ratings_to_show_hash
    end

    #retrieve only selected movies based on ratings
    @movies = Movie.with_ratings(@ratings_to_show_hash)
    
    if (!params[:sort].blank?) || (!params[:sort].nil?)
      @movies = Movie.with_ratings(@ratings_to_show_hash).order(params[:sort])
      if params[:sort] == "title"
        @title_header = 'hilite bg-warning'
      elsif params[:sort] == "release_date"
        @release_date_header = 'hilite bg-warning' 
      end
      session[:sort] = params[:sort]
    end

    if !session[:ratings].blank? || !session[:sort].blank?
      @ratings_to_show_hash = session[:ratings]
      sort_param = session[:sort]
      @movies = Movie.with_ratings(@ratings_to_show_hash).order(sort_param)
      if sort_param == "title"
        @title_header = 'hilite bg-warning'
      elsif sort_param == "release_date"
        @release_date_header = 'hilite bg-warning' 
      end

    end 

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
