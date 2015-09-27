class User < ActiveRecord::Base
  has_many :items, dependent: :destroy
  belongs_to :role
  # has_secure_password

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


  scope :Admin, -> { where(type: 'Admin') }
  scope :Owner, -> { where(race: 'Owner') }
  scope :Guest, -> { where(race: 'Guest') }






  def who?
   self.type == "Owner"
  end



  def to_s
    "#{first_name} #{last_name}"
  end
end
