class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    @books = Book.all.sort { |a, b| b.favorite_users.count <=> a.favorite_users.count }
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    @books = Book.all.sort { |a, b| b.favorite_users.count <=> a.favorite_users.count }
  end

end
