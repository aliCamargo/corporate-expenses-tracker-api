class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_many :trips, dependent: :destroy

  enum role: { admin: 0, employee: 1 }
  enum gender: { male: 0, female: 1 }

  validates :access_token, uniqueness: true, unless: Proc.new {|u| u.access_token.blank? }
  validates :role, :first_name, :last_name, presence: true

  def generate_access_token!
    begin
      self.access_token = Devise.friendly_token
    end while self.class.exists?( access_token: access_token )
  end

  def short_name
    "#{self.first_name.first.upcase}. #{self.last_name.downcase.titleize}"
  end
end
