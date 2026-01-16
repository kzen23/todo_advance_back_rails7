class GenresController < ApplicationController
  before_action :select_genre, only: [:destroy]
  skip_before_action :verify_authenticity_token

  def index
    genres_all
  end

  def create
    Genre.create(genre_params)
    genres_all
  end

  def destroy
    @genre.destroy
    genres_all
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

  def select_genre
    @genre = Genre.find(params[:id])
  end

  def genres_all
    genres = Genre.all
    render json: genres
  end
end
