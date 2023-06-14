# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioned_relations, class_name: 'Mention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :mentioned_relations, source: :mentioning_report
  has_many :mentioning_relations, class_name: 'Mention', foreign_key: 'mentioning_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :mentioning_relations, source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_mentions
    mentioning_relations.destroy_all
    mentioning_ids = content.to_s.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i).uniq
    mentioning_ids.each do |mentioning_id|
      mentioning_relations.create!(mentioning_report_id: id, mentioned_report_id: mentioning_id)
    end
  end
end
