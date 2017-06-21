module ApplicationHelper
  def avatar_profile user
    @avatar = user.avatar
    if @avatar
      @avatar.url
    else
      "#{user.sex}.png"
    end
  end
end
