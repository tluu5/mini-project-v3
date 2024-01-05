class CreateTvshows < ActiveRecord::Migration[7.0]
  def change
    create_table :tv_shows do |t|
      t.string :title
      t.string :network
      t.string :release_date
      t.text :description

      t.timestamps
    end
  end
end
