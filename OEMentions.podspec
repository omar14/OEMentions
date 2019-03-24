Pod::Spec.new do |spec|

  spec.name         = "OEMentions"
  spec.version      = "0.1.0"
  spec.summary      = "An easy way to add mentions to UITextView like Facebook and Instagram"

  spec.description  = <<-DESC
An easy way to add mentions to UITextView like Facebook and Instagram. It also include a tableview to show the users list to choose from. The component is written in Swift.
                   DESC

  spec.homepage     = "https://github.com/omar14/OEMentions"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author           = { 'omar14' => 'omaressa10@gmail.com' }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source           = { :git => 'https://github.com/omar14/OEMentions.git', :tag => "#{spec.version}" }
  spec.source_files  = "OEMentions/**/*.{h,m,swift}"

end