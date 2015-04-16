module S3AssetSync
  class Railtie < Rails::Railtie
    config.s3_asset_sync = ActiveSupport::OrderedOptions.new
    
    config.s3_asset_sync.run_after_precompile = true
    config.s3_asset_sync.s3_bucket = "YOUR_BUCKET_NAME"
    config.s3_asset_sync.endpoint = "YOUR_END_POINT"
    config.s3_asset_sync.s3_access_key = "YOUR_ACCESS_KEY"
    config.s3_asset_sync.s3_secret_access_key = "YOUR_SECRET_ACCESS_KEY"

    rake_tasks do
      load "tasks/s3_asset_sync.rake"
      namespace :s3_asset_sync do
        desc "Initialize S3AssetSync configuration."
        task :setup do
          abort("Already found config file. Have you already run this task?.") if File.exist?("config/initializers/s3_asset_sync.rb")

          cp(
            File.expand_path("../../../templates/s3_asset_sync.rb", __FILE__), "config/initializers/s3_asset_sync.rb"
          )
        end
      end
    end
  end
end