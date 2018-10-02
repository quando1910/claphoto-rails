class ArticlesController < ApplicationController
  require 'net/http'
  
  def index
    
  end

  def index_article
    @articles = Article.all.where(kind: params[:kind]).includes(:images)
    render json: @articles, include: [:images]
  end

  def show
    @article = Article.find(params[:id])
    render json: @article, include: [:images]
  end

  def show_related
    @articles_rand = Article.where(kind: params[:kind]).order("RAND()").limit(3)
    render json: @articles_rand, include: [:images]
  end

  def show_rand
    @articles_rand = Article.where("kind < 5").order("RAND()").limit(8)
    render json: @articles_rand, include: [:images]
  end

  def show_rand_except
    @articles_rand = Article.where.not(kind: 0).order("RAND()").limit(8)
    render json: @articles_rand, include: [:images]
  end

  def show_product
    @product = Photo.where(kind: params[:kind])
    render json: @product
  end

  def show_main_article
    @article = Article.find(32)
    render json: @article, include: [:images]
  end
  
  def hot_costume
    @articles = Article.joins(:images).where(kind: 0).includes(:images)
    render json: @articles, include: [:images]
  end
end
