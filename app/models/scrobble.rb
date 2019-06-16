# frozen_string_literal: true

##
# A data point for a given scrobbler.
#
class Scrobble < ApplicationRecord
  include HasGuid
  include Periodable
  include Categorizable

  CATEGORY_KLASS = Quantitare::Category

  belongs_to :user
  belongs_to :source, polymorphic: true, counter_cache: true

  validates :category, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :data_must_adhere_to_category_specification

  before_validation :derive_type, if: :base_klass?, on: :create

  def category_info
    super.new(data)
  end

  def timestamp
    @timestamp ||= init_timestamp
  end

  def timestamp=(value)
    @timestamp = value
    set_timestamps
  end

  def timestamp_changed?
    changes.include?('timestamp')
  end

  private

  def base_klass?
    self.class == Scrobble
  end

  def derive_type
    becomes!(PointScrobble) if start_time.present? && start_time == end_time
  end

  def data_must_adhere_to_category_specification
    errors[:data] << "is not in the correct format for category '#{category}'" unless data_valid_for_category?
  end

  def data_valid_for_category?
    category_info.valid?
  end

  def set_timestamps
    self.start_time = self.end_time = timestamp
  end

  def init_timestamp
    start_time
  end
end
