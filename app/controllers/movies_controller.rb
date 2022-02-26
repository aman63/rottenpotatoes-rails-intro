class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      @all_ratings = Movie.ratings
      #Get all the possible atings from the database
      @sort_type = params[:sort]
      @sort_type=@sort_type || session[:sort]
      #it decides what is the sorting criteria
    
      @ratings =  params[:ratings] 
      @ratings = @ratings || session[:ratings] 
      @ratings = @ratings || Hash[@all_ratings.map {|rating| [rating, rating]}]
      #Checkbox
      @all_rated_movies=Movie.where(rating:@ratings.keys)
      @selectedmovies = @all_rated_movies.order(@sort_type)
      #Order the movies based on sorting type
      @new_or_previous=params[:sort]!=session[:sort] 
      @new_or_previous=@new_or_previous or params[:ratings]!=session[:ratings]
      if @new_or_previous
        session[:ratings] = @ratings
        session[:sort] = @sort_type
        flash.keep
        
        #Keeps the entire flash
        redirect_to movies_path(sort: session[:sort],ratings:session[:ratings])
        #It redirects to index.html
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
