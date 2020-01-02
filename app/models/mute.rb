class Mute < ApplicationRecord
  belongs_to :muting, class_name: "User"
  belongs_to :muted, class_name: "User"
end
