class Artist < ActiveRecord::Base
    has_many :wordcounts
    validates :name, presence: true
end
