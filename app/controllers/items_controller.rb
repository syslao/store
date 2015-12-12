class ItemsController < ApplicationController
  before_action :authorize, except: :index
  before_action :set_item, only: [:show, :edit, :update, :destroy, :buy, :pro]
  load_and_authorize_resource

  def index
    if !current_user.respond_to?(:role)
      @items = Item.where(visible: false)
    else
      @items = Item.all
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit

    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Item was successfully destroyed.'
  end

  def pro
    @item.update_attribute(:visible, true)
    redirect_to @item, notice: 'Item PRO'
  end

  def buy
    @buy = BuyProduct.new(current_user, @item)
    @buy.call
    if @buy.error
      flash[:alert] = @buy.error
      render 'show'
    else
      flash[:notice] = @buy.error
      render 'show'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:title, :content, :avatar)
  end
end
