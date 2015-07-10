Pod::Spec.new do |spec|
  spec.name = 'GradientView'
  spec.version = '2.0.3'
  spec.authors = {'Sam Soffes' => 'sam@soff.es'}
  spec.homepage = 'https://github.com/soffes/GradientView'
  spec.summary = 'Easily use gradients in UIKit.'
  spec.description = 'Gradient View is a simple UIView wrapper around CGGradient.'
  spec.source = {:git => 'https://github.com/soffes/GradientView.git', :tag => "v#{spec.version}"}
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.platform = :ios, '8.0'
  spec.frameworks = 'UIKit'
  spec.source_files = 'GradientView/**/*.{h,m,swift}'
end
