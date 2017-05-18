class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :body

      t.timestamps
    end

    add_reference :answers, :question, foreign_key: true
  end
end
