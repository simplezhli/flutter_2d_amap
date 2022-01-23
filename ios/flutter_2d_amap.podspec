#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_2d_amap'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/simplezhli'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'weilu' => 'a05111993@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AMap2DMap'
  s.dependency 'AMapSearch', "~> 8.1.0"
  s.dependency 'AMapLocation', "~> 2.8.0"
  s.static_framework = true
  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

