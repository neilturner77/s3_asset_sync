# Automatically sync assets with S3 after precompilation.
Rails.application.config.s3_asset_sync.run_after_precompile = true

# Configure connection to S3.
Rails.application.config.s3_asset_sync.s3_bucket = "YOUR_BUCKET_NAME"
Rails.application.config.s3_asset_sync.s3_region = "YOUR_REGION"
Rails.application.config.s3_asset_sync.s3_access_key = "YOUR_ACCESS_KEY"
Rails.application.config.s3_asset_sync.s3_secret_access_key = "YOUR_SECRET_ACCESS_KEY"