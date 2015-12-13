class User < ActiveRecord::Base
  has_many :items, dependent: :destroy
  has_secure_password

  acts_as_messageable table_name: 'messages',

                      dependent: :destroy,
                      group_messages: true

  has_attached_file :user_photo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :user_photo, content_type: /\Aimage\/.*\Z/
  has_attached_file :user_pasport, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :user_pasport, content_type: /\Aimage\/.*\Z/

  validates :first_name, presence: true, if: :admin?
  validates :last_name, presence: true, if: :admin?
  validates_attachment_presence :user_photo, if: :admin?
  validates_attachment_presence :user_pasport, if: :admin?
  validates :birthday, presence: true, numericality: { only_integer: true }, if: :admin?
  validates :password, presence: true, length: { minimum: 10 }, if: :admin?

  validates :store_name, presence: true, if: :owner?
  validates :password, presence: true, length: { minimum: 8 }, if: :owner?

  validates :password, presence: true, length: { minimum: 6 }, if: :user?

  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }
  enum role: [:admin, :owner, :guest]

  def admin?
    role == 'admin'
  end

  def owner?
    role == 'owner'
  end

  def user?
    role == 'guest'
  end

  def can_buy(item)
    if email.last(4) == '.com'
      'domain in .com zone forbiden'
    elsif !item.visible
      'item is not PRO'
    elsif !item.user.store_name
      'item without store'
    end
  end
end
