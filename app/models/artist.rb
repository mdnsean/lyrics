class Artist < ActiveRecord::Base
    has_many :wordcounts
    validates :name, presence: true

    before_create :normalize_name

    def normalize_name
        self.name = self.name.downcase.gsub(/\s/, ' ')
    end
end
