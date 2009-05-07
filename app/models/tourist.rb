class Tourist < ActiveRecord::Base
  belongs_to :user

  def self.per_page
    20
  end

end
