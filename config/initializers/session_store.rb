# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_accounts_session',
  :secret      => 'f3a4a10992e56073770f27d53f0ea198b537866386ececa9b6ba8c38e3c0f2f228540bbeac4c9f25b09b6c326284b3016540b0f70aad3d62bcbb42e5495dde3a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
