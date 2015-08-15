json.array!(@db_grants) do |db_grant|
  json.extract! db_grant, :id, :user_id, :db, :type
  json.url db_grant_url(db_grant, format: :json)
end
