# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_manage_session',
  :secret      => '4974d8ffa5d0fb4abaa6a32d8134f35cf2a464a3aafe4285ca890aef15d4c52a21dc78b46e11142e3c71cb8b69dca021b7634d9e8173a890625b95c65275ec21'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
