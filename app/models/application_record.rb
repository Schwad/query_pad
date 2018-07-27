class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def time_ago_if_edited
    ", edited #{ApplicationController.helpers.distance_of_time_in_words_to_now(updated_at)} ago" if created_at != updated_at
  end
end
