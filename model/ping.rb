class Ping < Ohm::Model
  attribute :owner
  attribute :datetime
  attribute :status

  index :owner

  class << self
    def find_or_create_by_owner(owner)
      owned(owner) || Ping.new(:owner => owner)
    end

    def owned(owner)
      find(:owner => owner).first
    end
  end
end
