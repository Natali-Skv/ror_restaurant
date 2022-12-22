# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_221_222_155_635) do
  create_table 'categories', force: :cascade do |t|
    t.string 'name', limit: 80, null: false
    t.string 'slug', limit: 80, null: false
  end

  create_table 'dishes', force: :cascade do |t|
    t.string 'name', limit: 80
    t.text 'description'
    t.string 'image_path'
    t.integer 'calories'
    t.integer 'weight'
    t.integer 'price'
    t.integer 'categories_id', null: false
    t.index ['categories_id'], name: 'index_dishes_on_categories_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.integer 'users_id', null: false
    t.binary 'cart', null: false
    t.string 'comment', limit: 256
    t.string 'address', limit: 256
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['users_id'], name: 'index_orders_on_users_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', limit: 30
    t.integer 'phone'
    t.binary 'cart', default: "x'7b7d'"
  end

  add_foreign_key 'dishes', 'categories', column: 'categories_id'
  add_foreign_key 'orders', 'users', column: 'users_id'
end
