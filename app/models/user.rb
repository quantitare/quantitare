# frozen_string_literal: true

##
# A user.
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :services, dependent: :destroy
  has_many :available_services, ->(user) { available_to_user(user) }, class_name: 'Service'
end
