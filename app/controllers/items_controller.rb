class ItemsController < ApplicationController
  before_action :authorize, only: [:show, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  def index
    if !current_user.respond_to?(:role_id)
     @items = Item.where(visible: false) 
    else
    @items = Item.all  
  end


  def show
  end


  def new
    @item = Item.new
  end

  def edit
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
  end

  def pro 
    @item = Item.find(params[:id])
    @item.update_attribute(:visible,true)
    redirect_to @item, notice: "Item PRO"
  end

  def buy
    @item = Item.find(params[:id])
    flash[:error] = current_user.can_buy?(@item)
    return render 'items/show' if flash[:error]
    
    if !check_url.nil?
    flash[:error] = check_url
    else
    flash[:error] = 'bad'
    end
    render 'items/show'

  end 

  def get_photo_json
        
        JSON.parse(source.body)
  end

  def post_admin_json
        source = Net::HTTP.post_form(URI.parse('http://jsonplaceholder.typicode.com/todos'), {})
        JSON.parse(source.body)
  end

  def check_url
    source = Net::HTTP.get_response(URI.parse("http://jsonplaceholder.typicode.com/photos/#{rand(5000)}"))
    json = JSON.parse(source.body)
    url = json['url']
    thumbnailUrl = json['thumbnailUrl']
    return url if url.last(6) > thumbnailUrl.last(6)
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
