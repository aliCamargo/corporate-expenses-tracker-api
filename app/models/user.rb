class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { admin: 0, employee: 1 }
  enum gender: { male: 0, female: 1 }

  validates :access_token, uniqueness: true, unless: Proc.new {|u| u.access_token.blank? }

  def generate_access_token!
    begin
      self.access_token = Devise.friendly_token
    end while self.class.exists?( access_token: access_token )
  end
end
