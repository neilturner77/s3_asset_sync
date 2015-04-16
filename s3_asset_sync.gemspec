$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "s3_asset_sync/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "s3_asset_sync"
  s.version     = S3AssetSync::VERSION
  s.authors     = ["Neil Turner"]
  s.email       = ["neil@neilturner.me"]
  s.homepage    = "https://github.com/neilturner77/s3_asset_sync"
  s.summary     = "Simple way to syncronise your Rails 4 assets with an AWS S3 Bucket."
  s.description = "Simple way to syncronise your Rails 4 assets with an AWS S3 Bucket."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '~> 4.0.0'
  s.add_dependency 'colorize'
  s.add_dependency 'aws-sdk', '~> 2'
end
