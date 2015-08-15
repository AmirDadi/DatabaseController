json.array!(@table_grants) do |table_grant|
  json.extract! table_grant, :id, :user_id, :db_id, :table, :access_type
  json.url table_grant_url(table_grant, format: :json)
end
