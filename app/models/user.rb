class User < ActiveRecord::Base
  has_many :items, dependent: :destroy
  belongs_to :role
  has_secure_password

  validates :first_name, presence: true, if: lambda {|user| user.role_id == 1 }
  validates :last_name, presence: true, if: lambda {|user| user.role_id == 1 }
  validates_attachment :user_photo, if: lambda {|user| user.role_id == 1 }
  validates_attachment :user_pasport, if: lambda {|user| user.role_id == 1 }
  validates :birthday, presence: true, numericality: { only_integer: true }, if: lambda {|user| user.role_id == 1 }
  validates :password, presence: true, length: { minimum: 10 }, if: lambda {|user| user.role_id == 1 }

  validates :store_name, presence: true, if: lambda {|user| user.role_id == 2 }
  validates :password, presence: true, length: { minimum: 8 }, if: lambda {|user| user.role_id == 2 }

  validates :password, presence: true, length: { minimum: 6 }, if: lambda {|user| user.role_id == 3 }



  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }



has_attached_file :user_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
validates_attachment_content_type :user_photo, content_type: /\Aimage\/.*\Z/  
has_attached_file :user_pasport, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
validates_attachment_content_type :user_pasport, content_type: /\Aimage\/.*\Z/  


  def to_s
    "#{first_name} #{last_name}"
  end
end
