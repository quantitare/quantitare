# frozen_string_literal: true

##
# A user.
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :services, dependent: :destroy
  has_many :scrobblers, dependent: :destroy
  has_many :scrobbles, dependent: :destroy
  has_many :location_imports, dependent: :destroy
  has_many :location_scrobbles, dependent: :destroy
  has_many :places, dependent: :destroy

  has_many :available_services, ->(user) { available_to_user(user) },
    class_name: 'Service', inverse_of: :user
end
