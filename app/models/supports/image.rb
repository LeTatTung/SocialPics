class Supports::Image
  attr_reader :images

  def initialize arg
    @images = arg[:images]
    @params = arg[:params]
  end

  def images
    @images
  end

  def last
    image_size = Settings.load_more_image_size
    last = @images.size < image_size ? true : false
  end

  def categories
    categories = Category.all
  end
end
