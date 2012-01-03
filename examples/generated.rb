require 'migraine'

migration = Migraine::Migration.new(
  from: 'mysql://root:root@localhost/migraine_from',
  to: 'mysql://root:root@localhost/migraine_to'
)

migration.map 'addresses' => 'spree_addresses'
  map 'id'
  map 'firstname'
  map 'lastname'
  map 'address1'
  map 'address2'
  map 'city'
  map 'state_id'
  map 'zipcode'
  map 'country_id'
  map 'phone'
  map 'created_at'
  map 'updated_at'
  map 'state_name'
  map 'alternative_phone'
end

migration.map 'adjustments' => 'spree_adjustments'
  map 'id'
  map 'order_id' => ''
  map 'type' => ''
  map 'amount'
  map 'description' => ''
  map 'position' => ''
  map 'created_at'
  map 'updated_at'
  map 'adjustment_source_id' => ''
  map 'adjustment_source_type' => ''
end

migration.map 'assets' => 'spree_assets'
  map 'id'
  map 'viewable_id'
  map 'viewable_type'
  map 'attachment_content_type'
  map 'attachment_file_name'
  map 'attachment_size'
  map 'position'
  map 'type'
  map 'attachment_updated_at'
  map 'attachment_width'
  map 'attachment_height'
  map 'alt'
end

migration.map 'calculators' => 'spree_calculators'
  map 'id'
  map 'type'
  map 'calculable_id'
  map 'calculable_type'
  map 'created_at'
  map 'updated_at'
end

migration.map 'checkouts' => ''
  map 'id' => ''
  map 'order_id' => ''
  map 'email' => ''
  map 'ip_address' => ''
  map 'special_instructions' => ''
  map 'bill_address_id' => ''
  map 'created_at' => ''
  map 'updated_at' => ''
  map 'state' => ''
  map 'ship_address_id' => ''
  map 'shipping_method_id' => ''
end

migration.map 'configurations' => 'spree_configurations'
  map 'id'
  map 'name'
  map 'created_at'
  map 'updated_at'
  map 'type'
end

migration.map 'countries' => 'spree_countries'
  map 'id'
  map 'iso_name'
  map 'iso'
  map 'name'
  map 'iso3'
  map 'numcode'
end

migration.map 'coupons' => ''
  map 'id' => ''
  map 'code' => ''
  map 'description' => ''
  map 'usage_limit' => ''
  map 'combine' => ''
  map 'expires_at' => ''
  map 'created_at' => ''
  map 'updated_at' => ''
  map 'starts_at' => ''
end

migration.map 'creditcards' => 'spree_creditcards'
  map 'id'
  map 'number' => ''
  map 'month'
  map 'year'
  map 'verification_value' => ''
  map 'cc_type'
  map 'last_digits'
  map 'first_name'
  map 'last_name'
  map 'created_at'
  map 'updated_at'
  map 'start_month'
  map 'start_year'
  map 'issue_number'
  map 'address_id'
  map 'gateway_customer_profile_id'
  map 'gateway_payment_profile_id'
end

migration.map 'gateways' => 'spree_gateways'
  map 'id'
  map 'type'
  map 'name'
  map 'description'
  map 'active'
  map 'environment'
  map 'server'
  map 'test_mode'
  map 'created_at'
  map 'updated_at'
end

migration.map 'inventory_units' => 'spree_inventory_units'
  map 'id'
  map 'variant_id'
  map 'order_id'
  map 'state'
  map 'lock_version'
  map 'created_at'
  map 'updated_at'
  map 'shipment_id'
  map 'return_authorization_id'
end

migration.map 'line_items' => 'spree_line_items'
  map 'id'
  map 'order_id'
  map 'variant_id'
  map 'quantity'
  map 'price'
  map 'created_at'
  map 'updated_at'
end

migration.map 'open_id_authentication_associations' => ''
  map 'id' => ''
  map 'issued' => ''
  map 'lifetime' => ''
  map 'handle' => ''
  map 'assoc_type' => ''
  map 'server_url' => ''
  map 'secret' => ''
end

migration.map 'open_id_authentication_nonces' => ''
  map 'id' => ''
  map 'timestamp' => ''
  map 'server_url' => ''
  map 'salt' => ''
end

migration.map 'option_types' => 'spree_option_types'
  map 'id'
  map 'name'
  map 'presentation'
  map 'created_at'
  map 'updated_at'
end

migration.map 'option_types_prototypes' => 'spree_option_types_prototypes'
  map 'prototype_id'
  map 'option_type_id'
end

migration.map 'option_values' => 'spree_option_values'
  map 'id'
  map 'option_type_id'
  map 'name'
  map 'position'
  map 'presentation'
  map 'created_at'
  map 'updated_at'
end

migration.map 'option_values_variants' => 'spree_option_values_variants'
  map 'variant_id'
  map 'option_value_id'
end

migration.map 'orders' => 'spree_orders'
  map 'id'
  map 'user_id'
  map 'number'
  map 'item_total'
  map 'total'
  map 'created_at'
  map 'updated_at'
  map 'state'
  map 'token' => ''
  map 'adjustment_total'
  map 'credit_total'
  map 'completed_at'
end

migration.map 'pages' => ''
  map 'id' => ''
  map 'title' => ''
  map 'body' => ''
  map 'slug' => ''
  map 'created_at' => ''
  map 'updated_at' => ''
  map 'show_in_header' => ''
  map 'show_in_footer' => ''
  map 'foreign_link' => ''
  map 'position' => ''
  map 'visible' => ''
  map 'meta_keywords' => ''
  map 'meta_description' => ''
  map 'layout' => ''
  map 'show_in_sidebar' => ''
end

migration.map 'payment_methods' => 'spree_payment_methods'
  map 'id'
  map 'type'
  map 'name'
  map 'description'
  map 'active'
  map 'environment'
  map 'created_at'
  map 'updated_at'
  map 'deleted_at'
  map 'display' => ''
end

migration.map 'payments' => 'spree_payments'
  map 'id'
  map 'payable_id' => ''
  map 'created_at'
  map 'updated_at'
  map 'amount'
  map 'payable_type' => ''
  map 'source_id'
  map 'source_type'
  map 'payment_method_id'
end

migration.map 'preferences' => 'spree_preferences'
  map 'id'
  map 'attribute' => ''
  map 'owner_id' => ''
  map 'owner_type' => ''
  map 'group_id' => ''
  map 'group_type' => ''
  map 'value'
  map 'created_at'
  map 'updated_at'
end

migration.map 'product_groups' => 'spree_product_groups'
  map 'id'
  map 'name'
  map 'permalink'
  map 'order'
end

migration.map 'product_groups_products' => 'spree_product_groups_products'
  map 'product_id'
  map 'product_group_id'
end

migration.map 'product_option_types' => 'spree_product_option_types'
  map 'id'
  map 'product_id'
  map 'option_type_id'
  map 'position'
  map 'created_at'
  map 'updated_at'
end

migration.map 'product_properties' => 'spree_product_properties'
  map 'id'
  map 'product_id'
  map 'property_id'
  map 'value'
  map 'created_at'
  map 'updated_at'
end

migration.map 'product_scopes' => 'spree_product_scopes'
  map 'id'
  map 'product_group_id'
  map 'name'
  map 'arguments'
end

migration.map 'products' => 'spree_products'
  map 'id'
  map 'name'
  map 'description'
  map 'created_at'
  map 'updated_at'
  map 'permalink'
  map 'available_on'
  map 'tax_category_id'
  map 'shipping_category_id'
  map 'deleted_at'
  map 'meta_description'
  map 'meta_keywords'
  map 'count_on_hand'
end

migration.map 'products_taxons' => 'spree_products_taxons'
  map 'product_id'
  map 'taxon_id'
end

migration.map 'properties' => 'spree_properties'
  map 'id'
  map 'name'
  map 'presentation'
  map 'created_at'
  map 'updated_at'
end

migration.map 'properties_prototypes' => 'spree_properties_prototypes'
  map 'prototype_id'
  map 'property_id'
end

migration.map 'prototypes' => 'spree_prototypes'
  map 'id'
  map 'name'
  map 'created_at'
  map 'updated_at'
end

migration.map 'queued_mails' => ''
  map 'id' => ''
  map 'object' => ''
  map 'mailer' => ''
end

migration.map 'return_authorizations' => 'spree_return_authorizations'
  map 'id'
  map 'number'
  map 'amount'
  map 'order_id'
  map 'reason'
  map 'state'
  map 'created_at'
  map 'updated_at'
end

migration.map 'roles' => 'spree_roles'
  map 'id'
  map 'name'
end

migration.map 'roles_users' => 'spree_roles_users'
  map 'role_id'
  map 'user_id'
end

migration.map 'schema_migrations' do
  map 'version'
end

migration.map 'shipments' => 'spree_shipments'
  map 'id'
  map 'order_id'
  map 'shipping_method_id'
  map 'tracking'
  map 'created_at'
  map 'updated_at'
  map 'number'
  map 'cost'
  map 'shipped_at'
  map 'address_id'
  map 'state'
end

migration.map 'shipping_categories' => 'spree_shipping_categories'
  map 'id'
  map 'name'
  map 'created_at'
  map 'updated_at'
end

migration.map 'shipping_methods' => 'spree_shipping_methods'
  map 'id'
  map 'zone_id'
  map 'name'
  map 'created_at'
  map 'updated_at'
end

migration.map 'shipping_rates' => ''
  map 'id' => ''
  map 'shipping_category_id' => ''
  map 'shipping_method_id' => ''
end

migration.map 'snippets' => ''
  map 'id' => ''
  map 'slug' => ''
  map 'content' => ''
  map 'created_by' => ''
  map 'modified_by' => ''
  map 'created_at' => ''
  map 'updated_at' => ''
end

migration.map 'state_events' => 'spree_state_events'
  map 'id'
  map 'stateful_id'
  map 'user_id'
  map 'name'
  map 'created_at'
  map 'updated_at'
  map 'previous_state'
  map 'stateful_type'
end

migration.map 'states' => 'spree_states'
  map 'id'
  map 'name'
  map 'abbr'
  map 'country_id'
end

migration.map 'tax_categories' => 'spree_tax_categories'
  map 'id'
  map 'name'
  map 'description'
  map 'created_at'
  map 'updated_at'
  map 'is_default'
end

migration.map 'tax_rates' => 'spree_tax_rates'
  map 'id'
  map 'zone_id'
  map 'amount'
  map 'created_at'
  map 'updated_at'
  map 'tax_category_id'
end

migration.map 'taxonomies' => 'spree_taxonomies'
  map 'id'
  map 'name'
  map 'created_at'
  map 'updated_at'
end

migration.map 'taxons' => 'spree_taxons'
  map 'id'
  map 'taxonomy_id'
  map 'parent_id'
  map 'position'
  map 'name'
  map 'created_at'
  map 'updated_at'
  map 'permalink'
  map 'lft'
  map 'rgt'
  map 'icon_file_name'
  map 'icon_content_type'
  map 'icon_file_size'
  map 'icon_updated_at'
  map 'description'
end

migration.map 'trackers' => 'spree_trackers'
  map 'id'
  map 'environment'
  map 'analytics_id'
  map 'active'
  map 'created_at'
  map 'updated_at'
end

migration.map 'transactions' => ''
  map 'id' => ''
  map 'amount' => ''
  map 'txn_type' => ''
  map 'response_code' => ''
  map 'avs_response' => ''
  map 'cvv_response' => ''
  map 'created_at' => ''
  map 'updated_at' => ''
  map 'original_creditcard_txn_id' => ''
  map 'payment_id' => ''
  map 'type' => ''
end

migration.map 'users' => 'spree_users'
  map 'id'
  map 'email'
  map 'crypted_password' => ''
  map 'salt' => ''
  map 'remember_token'
  map 'remember_token_expires_at' => ''
  map 'created_at'
  map 'updated_at'
  map 'persistence_token'
  map 'single_access_token' => ''
  map 'perishable_token'
  map 'login_count' => ''
  map 'failed_login_count' => ''
  map 'last_request_at'
  map 'current_login_at' => ''
  map 'last_login_at' => ''
  map 'current_login_ip' => ''
  map 'last_login_ip' => ''
  map 'login'
  map 'ship_address_id'
  map 'bill_address_id'
  map 'openid_identifier' => ''
  map 'api_key'
end

migration.map 'variants' => 'spree_variants'
  map 'id'
  map 'product_id'
  map 'sku'
  map 'price'
  map 'weight'
  map 'height'
  map 'width'
  map 'depth'
  map 'deleted_at'
  map 'is_master'
  map 'count_on_hand'
  map 'cost_price'
end

migration.map 'zone_members' => 'spree_zone_members'
  map 'id'
  map 'zone_id'
  map 'zoneable_id'
  map 'zoneable_type'
  map 'created_at'
  map 'updated_at'
end

migration.map 'zones' => 'spree_zones'
  map 'id'
  map 'name'
  map 'description'
  map 'created_at'
  map 'updated_at'
end

migration.run
