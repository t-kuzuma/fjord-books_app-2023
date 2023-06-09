class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mentioned_report, foreign_key: { to_table: :reports }
      t.references :mentioning_report, foreign_key: { to_table: :reports }

      t.timestamps

      t.index [:mentioned_report_id, :mentioning_report_id], unique: true
    end
  end
end
