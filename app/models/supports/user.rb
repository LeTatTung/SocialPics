class Supports::User
  attr_reader :users

  def initialize arg
    @users = arg
  end

  def load_users
    @users
  end
end
