class BuyProduct
  attr_accessor :user, :item, :error

  def initialize(current_user, item)
    @user = current_user
    @item = item
  end

  def call
    if user.can_buy(@item)
      self.error = user.can_buy(@item)
    else
      purchase
    end
  end

  def purchase
    if check_url
      send_user_mail(check_url)
      send_alladmin_mail(post_admin_json)
      self.error = 'good purchase'
    else
      send_user_mail 'bad purchase'
      send_alladmin_mail 'this user have problem #{user.email}'
      self.error = 'bad purchase'
    end
  end

  def post_admin_json
    source = Net::HTTP.post_form(URI.parse('http://jsonplaceholder.typicode.com/todos'), {})
    JSON.parse(source.body)
  end

  def check_url
    source = Net::HTTP.get_response(URI.parse("http://jsonplaceholder.typicode.com/photos/#{rand(5000)}"))
    json = JSON.parse(source.body)
    url = json['url']
    thumbnail_url = json['thumbnailUrl']
    return url if url.last(6) > thumbnail_url.last(6)
  end

  def send_user_mail(message)
    sender.send_message(user, body: message, topic: 'your purchase')
  end

  def send_alladmin_mail(message)
    admins.each do |admin|
      sender.send_message(admin, body: message, topic: 'from system')
    end
  end

  def sender
    @sender = User.find_by_email('system@localhost.ru')
  end

  def admins
    @admins_all = User.where(role: 'admin')
  end
end
