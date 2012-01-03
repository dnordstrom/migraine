require 'migraine'

migration = Migraine::Migration.new(
  to: 'mysql://root:root@localhost/spree_old',
  from: 'mysql://root:root@localhost/spree_new'
)

migration.map 'users' => 'spree_users' do
  map 'email'
  # ...
  map 'crypted_password' => 'encrypted_password'
  # ...
end

migration.run
