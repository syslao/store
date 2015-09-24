class ItemsController < ApplicationController
  before_action :authorize
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  
   def create
    @item = current_user.items.build(item_params)
      if @item.save
    redirect_to @item, notice: 'Item was successfully created.'
  else
    render :new
  end
end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    
      if @item.update(item_params)
        redirect_to @item, notice: 'Item was successfully updated.'
        
      else
        render :edit 
        
      
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pro 
    @item = Item.find(params[:id])
    @item.update_attribute(:visible,true)
    redirect_to @item, notice: "Item PRO"
  end

  def authorize
    if current_user.nil?
      redirect_to login_url, alert: "Not authorized! Please log in."
    else
      if @item && @item.user != current_user
        redirect_to root_path, alert: "Not authorized! Only #{@item.user} has access to this item."
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :content, :avatar)
    end
end
