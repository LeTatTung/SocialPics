module LoadUser
  def load_support_user
    @user_support = Supports::User.new type: load_type,
      users: load_users, last: load_last
  end

  def load_type
    params[:type] || "following"
  end

  def load_users
    users = current_user.send(load_type).order id: :desc
    if users.any?
      follow_users_offset = params[:follow_users_offset] || (users.first.id + 1)
      users.load_follow_user(follow_users_offset)
        .limit Settings.length_more_user
    end
  end

  def load_last
    if load_users
      load_users.size < Settings.length_more_user ? true : false
    end
  end
end
