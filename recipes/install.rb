apt_repository 'brightbox-ruby' do
  uri 'ppa:brightbox/ruby-ng'
end

apt_update

package %w[
  software-properties-common ruby2.5 ruby2.5-dev nodejs build-essential patch
  ruby-dev zlib1g-dev liblzma-dev ruby-switch libffi-dev libcurl4-openssl-dev
]

gem_package 'bundler'
