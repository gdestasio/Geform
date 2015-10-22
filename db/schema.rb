# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150908160448) do

  create_table "add_invited_to_users", force: :cascade do |t|
    t.boolean  "invited",    limit: 1, default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "add_piva_to_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "authentication_token",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   limit: 4
    t.string   "name",                   limit: 255
  end

  add_index "admins", ["authentication_token"], name: "index_admins_on_authentication_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "certificates", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "certificates", ["event_id"], name: "index_certificates_on_event_id", using: :btree
  add_index "certificates", ["user_id"], name: "index_certificates_on_user_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string "cod_state",    limit: 255
    t.string "cod_province", limit: 255
    t.string "cod_city",     limit: 255
    t.string "cod_istat",    limit: 255
    t.string "name",         limit: 255
    t.string "belfiore",     limit: 255
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "criteria", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.float    "importance", limit: 24,    default: 0.0
    t.integer  "operator",   limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "event_sessions", force: :cascade do |t|
    t.integer  "event_id",   limit: 4
    t.float    "duration",   limit: 24, default: 0.0
    t.integer  "credits",    limit: 4,  default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "event_sessions", ["event_id"], name: "index_event_sessions_on_event_id", using: :btree

  create_table "event_user_titles", force: :cascade do |t|
    t.integer "event_id",   limit: 4
    t.integer "user_title", limit: 4
  end

  add_index "event_user_titles", ["event_id"], name: "index_event_user_titles_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.text     "description",             limit: 65535
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "credits",                 limit: 4,     default: 0
    t.integer  "min_presence_percentage", limit: 4,     default: 80
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "token",                   limit: 255
    t.integer  "proponent_id",            limit: 4
    t.integer  "validator_id",            limit: 4
    t.integer  "status",                  limit: 4,     default: 0
    t.integer  "seats",                   limit: 4,     default: 0
    t.string   "city",                    limit: 255
    t.string   "address",                 limit: 255
    t.string   "location",                limit: 255
    t.datetime "closing_at"
    t.integer  "category",                limit: 4
  end

  create_table "options", force: :cascade do |t|
    t.integer  "criteria_id", limit: 4
    t.string   "name",        limit: 255
    t.float    "importance",  limit: 24,  default: 0.0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "provinces", force: :cascade do |t|
    t.string "cod_state",    limit: 255
    t.string "cod_province", limit: 255
    t.string "name",         limit: 255
    t.string "initials",     limit: 255
  end

  create_table "speakers", force: :cascade do |t|
    t.integer  "event_id",   limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "speakers", ["event_id"], name: "index_speakers_on_event_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string "cod_state", limit: 255
    t.string "name",      limit: 255
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "event_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "credits",    limit: 4, default: 0
  end

  add_index "subscriptions", ["event_id", "user_id"], name: "index_subscriptions_on_event_id_and_user_id", unique: true, using: :btree

  create_table "training_plans", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "description", limit: 65535
  end

  create_table "transits", force: :cascade do |t|
    t.integer  "event_id",     limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "transited_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "operation",    limit: 4
    t.string   "uuid",         limit: 255
  end

  add_index "transits", ["event_id"], name: "fk_rails_8c78d6dcc3", using: :btree
  add_index "transits", ["user_id"], name: "fk_rails_8a0ae985ff", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                         limit: 255, default: "", null: false
    t.string   "encrypted_password",            limit: 255, default: "", null: false
    t.string   "reset_password_token",          limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",            limit: 255
    t.string   "last_sign_in_ip",               limit: 255
    t.string   "first_name",                    limit: 255
    t.string   "last_name",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "taxcode",                       limit: 255
    t.integer  "category",                      limit: 4
    t.string   "sex",                           limit: 255
    t.integer  "title",                         limit: 4
    t.date     "birthdate"
    t.string   "pec",                           limit: 255
    t.string   "phone",                         limit: 255
    t.string   "birthplace",                    limit: 255
    t.string   "address",                       limit: 255
    t.string   "zip",                           limit: 255
    t.integer  "status",                        limit: 4,   default: 0
    t.integer  "country_id",                    limit: 4
    t.string   "card_number",                   limit: 255
    t.integer  "city_id",                       limit: 4
    t.integer  "state_id",                      limit: 4
    t.integer  "province_id",                   limit: 4
    t.date     "graduated_at"
    t.string   "piva",                          limit: 255
    t.string   "delivery_1_address",            limit: 255
    t.string   "delivery_1_zip",                limit: 255
    t.integer  "delivery_1_city",               limit: 4
    t.string   "delivery_1_province",           limit: 255
    t.integer  "delivery_1_country_id",         limit: 4
    t.string   "delivery_1_phone",              limit: 255
    t.string   "delivery_1_fax",                limit: 255
    t.integer  "credits",                       limit: 4,   default: 0
    t.string   "authentication_token",          limit: 255
    t.datetime "confirmed_at"
    t.date     "albo_subscription_at"
    t.date     "cassazionista_subscription_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["card_number"], name: "index_users_on_card_number", unique: true, using: :btree
  add_index "users", ["city_id"], name: "fk_rails_9c7442481a", using: :btree
  add_index "users", ["country_id"], name: "fk_rails_7325e2cdfa", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["province_id"], name: "fk_rails_560da4bd54", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["state_id"], name: "fk_rails_606ec65343", using: :btree

  create_table "waiting_lists", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "waiting_lists", ["event_id"], name: "fk_rails_4ca44e9854", using: :btree
  add_index "waiting_lists", ["user_id"], name: "fk_rails_02f9584803", using: :btree

  create_table "zips", force: :cascade do |t|
    t.string "cod_istat", limit: 255
    t.string "city",      limit: 255
    t.string "prefix",    limit: 255
    t.string "zip",       limit: 255
  end

  add_foreign_key "certificates", "events"
  add_foreign_key "certificates", "users"
  add_foreign_key "event_sessions", "events"
  add_foreign_key "event_user_titles", "events"
  add_foreign_key "speakers", "events"
  add_foreign_key "transits", "events"
  add_foreign_key "transits", "users"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "countries"
  add_foreign_key "users", "provinces"
  add_foreign_key "users", "states"
  add_foreign_key "waiting_lists", "events"
  add_foreign_key "waiting_lists", "users"
end
