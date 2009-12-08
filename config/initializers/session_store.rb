# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_iNeedExercise_session',
  :secret      => '1782351e6486933bb958c3c45b849cd117f19c1d1202b5181437e5e3ae35816518ce49366160030b2815b169b0f8268e976780d2fe3fb3a430af45dfdc3073e5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
