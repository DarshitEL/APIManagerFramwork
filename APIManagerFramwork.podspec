
Pod::Spec.new do |spec|
    spec.name         = "APIManagerFramwork"
    spec.version      = "4.0.0"
    spec.summary      = "This pod allow to call api direct with alamofire and get response."
    spec.description  = <<-DESC
                     This framwork allow to call any api direct with ALAMOFIRE and get response in JSON.
                     DESC
    spec.homepage     = "https://github.com/DarshitEL"
    spec.platform     = :ios, "12.0"
    spec.license      = { :type => "MIT", :file => "LICENSE" }
    spec.author       = { "Darshit Patel" => "darshit.p@elaunchinfotech.in" }
    spec.swift_version = "4.0"
    spec.source       = { :git => "https://github.com/DarshitEL/APIManagerFramwork.git", :tag => "#{spec.version}" }
    #spec.source_files = "APIManagerFramwork","APIManagerFramwork/**/*.{h,m,swift,json}","APIManagerFramwork/Source/**/*.{h,m,swift,json}"
    spec.source_files = "APIManagerFramwork/*.{h,m,swift,json}"
    spec.dependency 'lottie-ios'
    spec.dependency 'Toast-Swift'
    spec.dependency 'Alamofire'
end
