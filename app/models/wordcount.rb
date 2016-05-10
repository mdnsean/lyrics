class Wordcount < ActiveRecord::Base
    belongs_to :artist
    validates :word, presence: true
    validates :count, presence: true
    validates :artist_id, presence: true
end
