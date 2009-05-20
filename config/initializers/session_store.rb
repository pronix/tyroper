# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tyroper_session',
  :secret      => 'f5f232a602595aa4c9f44bea6c098d46322d701600eb78f31f0916ba4dc55ffd0117c1408535eeb12b1f7edca016ede7b93cc60a90878f1799fd8db55afb6f97'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
