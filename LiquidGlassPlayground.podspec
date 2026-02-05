Pod::Spec.new do |s|
  s.name             = 'LiquidGlassPlayground'
  s.version          = '1.0.0'
  s.summary          = 'Interactive playground for iOS 26 Liquid Glass effects'
  s.description      = 'Interactive playground for iOS 26 Liquid Glass effects. Built with modern Swift.'
  s.homepage         = 'https://github.com/muhittincamdali/LiquidGlass-Playground'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/LiquidGlass-Playground.git', :tag => s.version.to_s }
  s.ios.deployment_target = '26.0'
  s.swift_versions = ['6.0']
  s.source_files = 'Sources/**/*.swift'
end
