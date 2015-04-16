namespace :assets do

  desc 'Synchronize all compiled assets to Amazon S3'
  task :sync_to_s3 => :environment do
    S3AssetSync.sync
  end

  desc 'Remove any expired assets stored on Amazon S3'
  task :purge_s3 => :environment do
    S3AssetSync.purge
  end

end

if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    Rake::Task["assets:sync_to_s3"].invoke if defined?(Rails) && Rails.application.config.s3_asset_sync.run_after_precompile
  end
end