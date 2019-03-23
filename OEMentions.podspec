Pod::Spec.new do |spec|

  spec.name         = "OEMentions"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
This CocoaPods library helps you perform mentions.
                   DESC

  spec.homepage     = "https://github.com/omar14/OEMentions"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author           = { 'omar14' => 'omaressa10@gmail.com' }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source           = { :git => 'https://github.com/omar14/OEMentions.git', :tag => "#{spec.version}" }
  spec.source_files  = "OEMentions/**/*.{h,m,swift}"

end