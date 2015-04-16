require 'colorize'
require 'aws-sdk-core'
require 's3_asset_sync/railtie' if defined?(Rails)

module S3AssetSync

  ##
  # Loops through /public/assets directory and sync's each
  # file with the specified S3 Bucket.
  #
  def self.sync
    puts "Syncing assets to S3...".yellow

    Aws.config.update({
      credentials: Aws::Credentials.new(
        Rails.application.config.s3_asset_sync.s3_access_key,
        Rails.application.config.s3_asset_sync.s3_secret_access_key
      ),
      region: Rails.application.config.s3_asset_sync.s3_region
    })

    s3 = Aws::S3::Client.new

    Dir.foreach(Rails.root.join('public','assets')) do |file|
      next if file == '.' || file == '..'
      puts "SYNC: #{file}"
      self.s3_upload_object(s3, file) unless self.s3_object_exists?(s3, file)
    end

    puts "Asset sync successfully completed...".green
  end

  ##
  # Loops through specified S3 Bucket and checks to see if the object
  # exists in our /public/assets folder. Deletes it from the
  # bucket if it doesn't exist.
  #
  def self.purge
    puts "Cleaning assets in S3...".yellow

    Aws.config.update({
      credentials: Aws::Credentials.new(
        Rails.application.config.s3_asset_sync.s3_access_key,
        Rails.application.config.s3_asset_sync.s3_secret_access_key
      ),
      region: Rails.application.config.s3_asset_sync.s3_region
    })

    s3 = Aws::S3::Client.new

    keys = []

    s3.list_objects(bucket:Rails.application.config.s3_asset_sync.s3_bucket).each do |response|
      keys += response.contents.map(&:key)
    end

    keys.each do |key|
      if !File.exists?(Rails.root.join('public', 'assets', key))
        self.s3_delete_object(s3, key) 
        puts "DELETED: #{key}"
      end
    end

    puts "Asset clean successfully completed...".green
  end

  ##
  # Check if a key exists in the specified S3 Bucket.
  #
  def self.s3_object_exists?(client, key)
    begin
      client.head_object(
        bucket: Rails.application.config.s3_asset_sync.s3_bucket,
        key: key
      )
      return true
    rescue
      return false
    end
  end

  ##
  # Uploads an object to the specified S3 Bucket.
  #
  def self.s3_upload_object(client, key)
    resp = client.put_object(
      acl: "public-read",
      bucket: Rails.application.config.s3_asset_sync.s3_bucket,
      body: File.open(Rails.root.join('public','assets', key)),
      key: key
    )
  end

  ##
  # Deletes an object from the specified S3 Bucket.
  #
  def self.s3_delete_object(client, key)
    resp = client.delete_object(
      bucket: Rails.application.config.s3_asset_sync.s3_bucket,
      key: key
    )
  end

end
