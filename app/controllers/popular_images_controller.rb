class PopularImagesController < ApplicationController
  before_action :load_data_static

  def index
    @categories = Category.all
    @images = Image.popular_images.load_image_offset
      .limit Settings.load_more_image_size
  end
end
