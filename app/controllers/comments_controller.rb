class CommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    comment = current_user.comments.new(comment_params)
    comment.book_id = @book.id
    comment.save
  end

  def destroy
    Comment.find_by(book_id: params[:book_id], id: params[:id]).destroy
    @book = Book.find(params[:book_id])
  end

    private

    def comment_params
      params.require(:comment).permit(:comment)
    end

end
