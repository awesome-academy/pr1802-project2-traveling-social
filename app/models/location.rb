class Location < ApplicationRecord
  ratyrate_rateable "overall"
  belongs_to :user
  belongs_to :city, optional: true, inverse_of: :locations
  has_many :reviews, dependent: :destroy
  has_many :micro_posts
  has_many :images, as: :lr_image, dependent: :destroy, inverse_of: :lr_image
  rails_admin do
    configure :lr_image do
      hide
    end
  end
  
  searchkick word_start: [:name], highlight: [:name], suggest: [:name]

  acts_as_punchable

  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  validates :name, :thumbnail, :city, presence: true

  mount_uploader :thumbnail, ImageUploader

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end

  serialize :address, JSON
  scope :search_location, -> (search_content) {where("name like ?","%#{search_content}%")}
  
end
