# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioned_relations, class_name: 'Mention',
                                  foreign_key: 'mentioned_report_id',
                                  dependent: :destroy
  has_many :mentioned_reports, through: :mentioned_relations,
                                source: :mentioning_report
  has_many :mentioning_relations, class_name: 'Mention',
                                  foreign_key: 'mentioning_report_id',
                                  dependent: :destroy
  has_many :mentioning_reports, through: :mentioning_relations,
                                source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_mentions
    self.mentioning_relations.destroy_all
    mentioning_ids = self.content.to_s.scan(/http:\/\/localhost:3000\/reports\/(\d+)/).flatten.map(&:to_i).uniq
    mentioning_ids.each do |mentioning_id|
      self.mentioning_relations.create!(mentioning_report_id: self.id, mentioned_report_id: mentioning_id)
    end
  end
end
