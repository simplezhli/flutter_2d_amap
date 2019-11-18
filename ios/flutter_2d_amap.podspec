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
  s.dependency 'AMapSearch'
  s.dependency 'AMapLocation'

  s.ios.deployment_target = '8.0'
end

