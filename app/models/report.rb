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

  def create_with_mentions
    result = false
    ActiveRecord::Base.transaction do
      if save && save_mentions
        result = true
      else
        raise ActiveRecord::Rollback
      end
    end
    result
  end

  def update_with_mentions(params)
    result = false
    ActiveRecord::Base.transaction do
      if update(params) && save_mentions
        result = true
      else
        raise ActiveRecord::Rollback
      end
    end
    result
  end

  def save_mentions
    mentioning_relations.destroy_all
    mentioned_ids = content.to_s.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i).uniq
    mentioned_ids.each do |mentioned_id|
      if Report.find_by(id: mentioned_id)
        mentioning_relation = mentioning_relations.build(mentioning_report_id: id, mentioned_report_id: mentioned_id)
        return false unless mentioning_relation.save
      end
    end
  end
end
