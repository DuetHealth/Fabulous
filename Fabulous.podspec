Pod::Spec.new do |s|
  s.name          = 'Fabulous'
  s.version       = '1.0.2'
  s.summary       = 'A material-inspired floating action button.'
  s.description   = <<-DESC
                    A material-inspired floating action button with a little Human Interface flair.
                    Supports singular, primary actions or a collection of speed-dial actions.
                    DESC
  s.homepage      = 'https://github.com/DuetHealth/Fabulous.git'
  s.license       = 'MIT'
  # TODO (before open sourcing)
  # s.license     = { type: 'MIT', license: 'LICENSE' }
  s.authors       = 'Duet Health'
  s.platform      = :ios, '9.0'
  s.source        = { git: 'https://github.com/DuetHealth/Fabulous.git', tag: "#{s.version}" }
  s.source_files  = "Fabulous/Sources/**/*.{h,m,swift}"
  s.resources     = "Fabulous/Resources/**"
  s.swift_version = '4.1'
end
