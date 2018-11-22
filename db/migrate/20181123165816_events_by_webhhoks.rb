class EventsByWebhhoks < ActiveRecord::Migration[5.2]
  def change
    create_table 'events', force: :cascade do |t|
      t.string 'topic', null: false
      t.string 'resource_id', null: false
      t.string 'object_class', null: false
      t.string 'status', null: false
      t.string 'uid', null: false
      t.string 'link'
      t.timestamps null: true
      t.index %i[uid], unique: true
    end

    create_table 'webhooks', force: :cascade do |t|
      t.string 'type'
      t.string 'link'
      t.string 'uid'
      t.string 'url', null: false
      t.string 'secret', null: false
      t.timestamps null: true
    end

    change_column :funding_sources, :status, :string, default: 'unverified', null: false
  end
end
