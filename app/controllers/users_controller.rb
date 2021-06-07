class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_posts = @user.books.where("created_at >= ?", Date.today)
    @yesterday_posts = @user.books.where(created_at: 1.day.ago.all_day)
    @day_ratio = average(@today_posts, @yesterday_posts)

    current_week_from = 6.days.ago.beginning_of_day
    current_week_to = Time.current.end_of_day
    @current_week_posts = @user.books.where(created_at: current_week_from..current_week_to)
    
    prev_week_from = 13.days.ago.beginning_of_day
    prev_week_to =  7.days.ago.end_of_day
    @prev_week_posts = @user.books.where(created_at: prev_week_from..prev_week_to)
    
    @week_ratio = average(@current_week_posts, @prev_week_posts)
    
  end
  
  def book_count_search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def following #フォローした人の一覧ページ(following)
    @title = "Follows"
    @user = User.find(params[:id])
    @users = @user.following
    render '_show_follow'
  end

  def followers
    @title = "Follower"
    @user = User.find(params[:id])
    @users = @user.followers
    render '_show_follow'
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  def average(current, previous)
    if previous.count == 0
      return current.count * 100
    else
      current.count / previous.count * 100
    end
  end
  
end
