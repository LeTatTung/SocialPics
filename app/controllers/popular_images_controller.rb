class PopularImagesController < ApplicationController
  before_action :load_data_static

  def index
    image_size = Settings.load_more_image_size
    image_offset = params[:image_offset] || 0
    images = Image.popular_images.load_more_image_offset(image_offset)
      .limit image_size
    @image_support = Supports::Image.new images: images, params: params
  end
end
