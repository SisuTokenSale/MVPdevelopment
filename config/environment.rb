require_relative 'application'
ActiveRecord::SchemaDumper.ignore_tables = ['spatial_ref_sys']
Rails.application.initialize!
