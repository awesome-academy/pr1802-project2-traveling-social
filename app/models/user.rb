class User < ApplicationRecord
  rolify
  ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth auth
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  has_many :locations
  has_many :cities
  has_many :reviews, dependent: :destroy
  has_many :micro_posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :images, dependent: :destroy

  enum gender: {male: 1, female: 0, other: 2}
  mount_uploader :thumbnail, ImageUploader
  mount_uploader :cover, ImageUploader

  acts_as_followable
  acts_as_follower
  acts_as_voter
  acts_as_paranoid

  def User.list_following user
    user.all_following.take 5
  end
end
