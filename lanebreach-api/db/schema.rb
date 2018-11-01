# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_29_014619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

# Could not dump table "bikeway_networks" because of following StandardError
#   Unknown type 'geometry(MultiLineString,4326)' for column 'geom'

  create_table "mobile_metadata", force: :cascade do |t|
    t.string "environment"
    t.string "category"
    t.string "token"
    t.string "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
