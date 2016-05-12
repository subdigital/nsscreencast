require 'sinatra'
require 'redis'
require 'json'

TIMEOUT = 300

get '/' do
  "hi"
end

post '/easy_auth' do
  require_client_id
  token = SecureRandom.hex(24)
  client_id = params['client_id']

  key = "auth_req:#{token}"
  code = (rand() * 90000).to_i + 10000
  data = {
    client_id: client_id,
    token: token,
    code: code,
    status: 'pending'
  }
  redis.setex(key, TIMEOUT, data.to_json)
  redis.setex("auth_lookup:#{code}", TIMEOUT, key)

  data.to_json
end

get '/easy_auth/:token' do |token|
  key = "auth_req:#{token}"
  if data = redis.get(key)
    json = JSON.parse(data)

    return json.to_json
  else
    halt 404, 'token not valid or expired'
  end
end

get '/activate' do
  if params['error']
    @error = params['error']
  end
  erb :activate
end

post '/activate' do
  code = params['code']
  if key = redis.get("auth_lookup:#{code}")
      data = redis.get(key)
      json = JSON.parse(data)

      auth_token = SecureRandom.hex(24)
      json['auth_token'] = auth_token
      json['status'] = 'authenticated'

      redis.setex(key, TIMEOUT, json.to_json)

      redirect '/success'
  else
    redirect '/activate?error=invalid-code'
  end
end

get '/success' do
  "Success! Your device will log in automatically."
end

def require_client_id
  halt 400, "client_id is required" if params['client_id'].nil?
end

def redis
  Redis.current
end
