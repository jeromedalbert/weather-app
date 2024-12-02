class Location
  include ActiveModel::Model
  include Turbo::Broadcastable

  attr_accessor :zip_code
  attr_accessor :country_code
  attr_accessor :forecast

  validates :zip_code, presence: true
  validates :country_code, presence: true
  validates :country_code, inclusion: { in: ISO3166::Country.codes }

  def self.build_from_id(id)
    zip_code, country_code = id&.split('-')

    new(zip_code: zip_code, country_code: country_code)
  end

  def id
    [zip_code, country_code].compact.join('-').presence
  end

  # This method is needed for ActiveModel #to_param to work correctly
  def persisted?
    id.present?
  end
end
