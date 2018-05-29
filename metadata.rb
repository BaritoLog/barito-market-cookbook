name 'barito_market'
maintainer 'GO-JEK Engineering'
maintainer_email 'baritolog@go-jek.com'
license 'Apache-2.0'
description 'Installs/Configures barito market'
long_description 'Installs/Configures barito market'
version '0.1.0'
chef_version '>= 14.1.1' if respond_to?(:chef_version)

issues_url 'https://github.com/BaritoLog/barito-market-cookbook/issues'
source_url 'https://github.com/BaritoLog/barito-market-cookbook'

depends 'foundation'
depends 'zipfile'
depends 'tar'
