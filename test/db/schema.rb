ActiveRecord::Schema.define(:version => 1) do

  create_table :addresses, :force => true do |t|
    t.column :name, :string
    t.column :addressable_id, :integer
    t.column :addressable_type, :string
  end

  create_table :users, :force => true do |t|
    t.column :login, :string
    t.column :first_name, :string
    t.column :last_name, :string
    t.column :cell, :string
  end

  create_table :roles_users, :force => true, :id => false do |t|
    t.column :user_id, :integer
    t.column :role_id, :integer
  end

  create_table :services, :force => true do |t|
    t.column :name, :string
  end

  create_table :subscriptions, :force => true do |t|
    t.column :name, :string
    t.column :service_id, :integer
    t.column :user_id, :integer
  end

  create_table :roles, :force => true do |t|
    t.column :name, :string
  end
end