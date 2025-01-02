class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create do
    if self.has_attribute?(:uuid)
      self.uuid = SecureRandom.uuid
    end
  end
end
