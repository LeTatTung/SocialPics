class Supports::Image
  attr_reader :images

  def initialize arg
    @images = arg
  end

  def images
    @images[:images]
  end

  def last
    image_size = Settings.load_more_image_size
    @last = @images.size < image_size ? true : false
  end
end
