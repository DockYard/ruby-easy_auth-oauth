require 'active_record'

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
        :adapter => defined?(JRUBY_VERSION) ? 'jdbcsqlite3' : 'sqlite3',
        :database => ':memory:'
    )
    users_table      = %{CREATE TABLE users (id INTEGER PRIMARY KEY, email VARCHAR(255));}
    ActiveRecord::Base.connection.execute(users_table)

    identities_table = %{CREATE TABLE identities (id INTEGER PRIMARY KEY, uid VARCHAR(255), token VARCHAT(255), account_type VARCHAR(255), account_id INTEGER, type VARCHAR(255));}
    ActiveRecord::Base.connection.execute(identities_table)

    class ::User < ActiveRecord::Base
      include EasyAuth::Models::Account
    end
  end
end
