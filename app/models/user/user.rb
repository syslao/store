class User < ActiveRecord::Base
  has_many :items, dependent: :destroy
  belongs_to :role
  has_secure_password

  validates :first_name,
             presence: true, :unless => :who?
  validates :last_name,
            presence: true, :unless => :who?
  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }, :unless => :who?



has_attached_file :user_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
validates_attachment_content_type :user_photo, content_type: /\Aimage\/.*\Z/  
has_attached_file :user_pasport, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
validates_attachment_content_type :user_pasport, content_type: /\Aimage\/.*\Z/  



  def who?
   self.role_id = 2
  end



  def to_s
    "#{first_name} #{last_name}"
  end
end
