require 'migraine'

migration = Migraine::Migration.new(
  from: 'mysql://root:root@localhost/migraine_from',
  to: 'mysql://root:root@localhost/migraine_to'
)

migration.prefix 'spree_'
migration.generate 'generated.rb'
