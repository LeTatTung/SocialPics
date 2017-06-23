class PopularImagesController < ApplicationController
  before_action :load_data_static

  def index
    image_offset = params[:image_offset] || 0
    images = Image.popular_images.load_image_offset image_offset
      .limit image_size
    @image_support =  Supports::Image.new image: images, params: params 
  end
end
