class Item < ActiveRecord::Base
  belongs_to :user
  validates :title,
            presence: true
  validates :content,
            presence: true
  validates :user,
            presence: true
  validates :avatar,
            presence: true
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def get_photo_json
    JSON.parse(source.body)
  end

  def post_admin_json
    source = Net::HTTP.post_form(URI.parse('http://jsonplaceholder.typicode.com/todos'), {})
    JSON.parse(source.body)
  end
  
end
