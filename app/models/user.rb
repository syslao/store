class User < ActiveRecord::Base
  has_many :items, dependent: :destroy
  enum role: [:admin, :owner, :guest]
  has_secure_password

  acts_as_messageable table_name: 'messages',

                      dependent: :destroy,
                      group_messages: true

  has_attached_file :user_photo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :user_photo, content_type: /\Aimage\/.*\Z/
  has_attached_file :user_pasport, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :user_pasport, content_type: /\Aimage\/.*\Z/

  validates :first_name, presence: true, if: :is_admin
  validates :last_name, presence: true, if: :is_admin
  validates_attachment_presence :user_photo, if: :is_admin
  validates_attachment_presence :user_pasport, if: :is_admin
  validates :birthday, presence: true, numericality: { only_integer: true }, if: :is_admin
  validates :password, presence: true, length: { minimum: 10 }, if: :is_admin

  validates :store_name, presence: true, if: :is_owner
  validates :password, presence: true, length: { minimum: 8 }, if: :is_owner

  validates :password, presence: true, length: { minimum: 6 }, if: :is_user

  def is_admin
    role == 'admin'
  end

  def is_owner
    role == 'owner'
  end

  def is_user
    role == 'guest'
  end

  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }

  def can_buy(item)
    if email.last(4) == '.com'
      'domain in .com zone forbiden'
    elsif !item.visible
      'item is not PRO'
    elsif item.user.store_name.nil?
      'item without store'
    end
  end
end
