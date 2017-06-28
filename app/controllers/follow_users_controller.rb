class FollowUsersController < ApplicationController
  include LoadUser
  before_action :load_data_static, :load_support_user

  def index
  end
end
