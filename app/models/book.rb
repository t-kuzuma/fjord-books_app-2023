# frozen_string_literal: true

class Book < ApplicationRecord
  paginates_per 4
  mount_uploader :picture, PictureUploader
end
