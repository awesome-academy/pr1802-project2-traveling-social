class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find_by(id: params[:id]).decorate
    @micro_post = MicroPost.new
    @pagy, @micro_posts = pagy_array @user.micro_posts.includes(:user, :location)
      .order_created_desc.decorate, items: Settings.micro_posts.per_page
    @list_following = User.list_following @user
    if params[:id_status]
      @micro_post = MicroPost.find_by id: params[:id_status]
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".user_updated"
      redirect_to user_path
    else
      flash[:danger] = t ".user_updated_error"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :thumbnail, :first_name, :last_name, :phone,
      :birtday, :gender, :about, :cover
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def current_user? user
    user == current_user
  end  
end
