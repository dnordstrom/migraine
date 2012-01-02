require 'migraine'

migration = Migraine::Migration.new(
  to: 'mysql://root:root@localhost/migraine_to',
  from: 'mysql://root:root@localhost/migraine_from'
)

migration.map 'products' => 'spree_products' do
  map 'name' => 'name'
end

migration.run
