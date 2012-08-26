CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => ENV['S3_ACCESS_KEY_ID'],
    :aws_secret_access_key => ENV['S3_SECRET_ACCESS_KEY']
  }

  config.fog_directory = 'best-latte'
  config.fog_public = true
  config.fog_attributes = { 'Cache-Control' => 'max-age=60000' }
end
