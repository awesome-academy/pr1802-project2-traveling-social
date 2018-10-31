class ReviewsController < ApplicationController
  before_action :set_location, only: [:create, :new]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  def new
    @review = @location.reviews.build
  end

  def create
    byebug
    @review = current_user.reviews.new review_params
    @review.location = @location
    if @review.save
      flash[:info] = t ".review_created"
      redirect_to location_review_path(@location, @review)
    else
      flash[:alert] = t ".review_created_error"
      render :new
    end
  end

  def index
    @user = current_user
    if params[:location_id].present?
      @location = Location.friendly.find params[:location_id]
      @reviews = @location.reviews
    else
      @reviews = @user.reviews
    end
  end

  def show
    @user = current_user
  end

  def edit
  end
  
  def update
    if @review.update_attributes review_params
      redirect_to location_review_path(@review.location, @review),
        notice: t(".review_updated")
    else
      render :edit
    end
  end
  
  def destroy
    @review.destroy
    redirect_to root_path, notice: t(".review_deleted")
  end
  
  private
  def set_review
    @review = Review.friendly.find params[:id]
  end

  def set_location
    @location = Location.friendly.find params[:location_id]
  end

  def review_params
    params.require(:review).permit :name, :content, :thumbnail,
      images_attributes: [:id, :image, :image_cache, :_destroy]
  end
end
