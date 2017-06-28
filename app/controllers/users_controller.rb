class UsersController < ApplicationController
  before_action :load_user

  def show
    @images = @user.images.order id: :desc
    if @images.any?
      image_size = Settings.load_more_image_size
      image_offset = params[:image_offset] || @images.first.id
      @images = @images.load_less_image_offset(image_offset)
        .limit image_size
      @last = @images.size < image_size ? true : false
    end
  end

  def update
    errors = @user.update_profile user_params: user_params,
      profile_params: profile_params
    if errors
      respond_to do |format|
        format.html do
          @images = @user.images.order(id: :desc).limit 5
          flash[:danger] = t "user.update.fail"
          render :show
        end
        format.js
      end
    else
      flash[:success] = t "user.update.success"
      redirect_to user_path(@user)
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :sex, :avatar
  end

  def profile_params
    params.require(:profile).permit :phone_number, :birthday, :place_birth
  end

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "error.user_not_found"
      redirect_to root_path
    end
  end
end
