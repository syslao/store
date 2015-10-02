class User < ActiveRecord::Base
  has_many :items, dependent: :destroy
  belongs_to :role
  has_secure_password

acts_as_messageable   :table_name => "messages", # default 'messages'

                      :dependent  => :destroy,              # default :nullify
                      :group_messages => true               # default false


has_attached_file :user_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
validates_attachment_content_type :user_photo, content_type: /\Aimage\/.*\Z/  
has_attached_file :user_pasport, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
validates_attachment_content_type :user_pasport, content_type: /\Aimage\/.*\Z/  



  validates :first_name, presence: true, if: :is_admin?
  validates :last_name, presence: true, if: :is_admin?
  validates_attachment_presence :user_photo, if: :is_admin?
  validates_attachment_presence :user_pasport, if: :is_admin?
  validates :birthday, presence: true, numericality: { only_integer: true }, if: :is_admin?
  validates :password, presence: true, length: { minimum: 10 }, if: :is_admin?

  validates :store_name, presence: true, if: :is_owner?
  validates :password, presence: true, length: { minimum: 8 }, if: :is_owner?

  validates :password, presence: true, length: { minimum: 6 }, if: :is_user?


def is_admin?
  role_id == 1
end

def is_owner?
  role_id == 2
end

def is_user?
  role_id == 3
end



  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }

def can_buy?(item)
  if email.last(4) == ".com"
  "с доменом взоне .com к нам нельзя"
  elsif !item.visible
  "товар не PRO"
  elsif item.user.store_name.nil?
  "товар без магазина"
 end
end


  def to_s
    "#{first_name} #{last_name}"
  end
end
