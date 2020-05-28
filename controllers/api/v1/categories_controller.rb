class Api::V1::CategoriesController < ApplicationController
  include Language
  before_action :authenticate_with_token!
  def index
    categories = Category.order_by(:count.desc).limit(20)
    puts categories.length
    render :json => categories
  end

  def search
    params[:name] = set_language(params[:name])
    params[:name].present? ? categories = Category.where(:name => /.*#{params[:name]}.*/i).order_by(:count.desc).limit(20) : categories = Category.all.limit(20)
    render :json => categories
  end
end
