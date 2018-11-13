class ReviewsController < ApplicationController
  before_action :set_location, except: [:show, :update, :destroy]
  before_action :set_review, except: [:create, :new, :index]
  def new
    @review = @location.reviews.build
  end

  def create
    @review = current_user.reviews.new review_params
    @review.location = @location
    if @review.save
      flash[:info] = t ".review_created"
      redirect_to review_path(@review)
    else
      flash[:alert] = t ".review_created_error"
      render :new
    end
  end

  def index
    if params[:location_id].present?
      @location = Location.friendly.find params[:location_id]
      @pagy, @reviews = pagy_array @location.reviews, 
        items: Settings.reviews.per_page
    else
      @user = User.find_by id: params[:user_id]
      @pagy, @reviews = pagy_array @user.reviews, 
        items: Settings.reviews.per_page
    end
  end

  def show
    @location = @review.location
    @review.punch request
    @pagy, @comments = pagy_array @review.comments.order_created_desc, 
      items: Settings.comments.per_page
  end

  def edit
  end
  
  def update
    if @review.update_attributes review_params
      redirect_to review_path(@review),
        notice: t(".review_updated")
    else
      render :edit
    end
  end
  
  def destroy
    @review.destroy
    redirect_to location_reviews_path, notice: t(".review_deleted")
  end
  
  private
  def set_review
    @review = Review.friendly.find params[:id]
  end

  def set_location
    @location = Location.friendly.find params[:location_id]
  end

  def review_params
    params.require(:review).permit :name, :content, :thumbnail, :rating,
      images_attributes: [:id, :image, :image_cache, :_destroy, :user_id]
  end
end
