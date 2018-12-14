# encoding: utf-8

# Inspec test for recipe barito-market::app

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe user('root') do
    it { should exist }
  end

  describe user('barito_market') do
    it { should exist }
  end

  describe directory('/home/barito_market/.ssh') do
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'barito_market' }
    its('group') { should eq 'barito_market' }
  end

  describe directory('/opt/barito_market') do
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'barito_market' }
    its('group') { should eq 'barito_market' }
  end

  describe directory('/opt/barito_market/shared') do
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'barito_market' }
    its('group') { should eq 'barito_market' }
  end

  describe directory('/opt/barito_market/shared/log') do
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'barito_market' }
    its('group') { should eq 'barito_market' }
  end

  describe directory('/opt/chef-repo') do
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'barito_market' }
    its('group') { should eq 'barito_market' }
  end

  describe directory('/opt/chef-repo/chef-repo') do
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'barito_market' }
    its('group') { should eq 'barito_market' }
  end

  describe directory('/opt/chef-repo/shared') do
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'barito_market' }
    its('group') { should eq 'barito_market' }
  end

  describe file('/home/barito_market/.ssh/known_hosts') do
    its('mode') { should cmp '0644' }
  end

  describe file('/opt/barito_market/BaritoMarket/config/application.yml') do
    its('mode') { should cmp '0644' }
  end

  describe file('/opt/barito_market/BaritoMarket/config/tps_config.yml') do
    its('mode') { should cmp '0644' }
  end

  describe file('/opt/barito_market/BaritoMarket/config/database.yml') do
    its('mode') { should cmp '0644' }
  end

  describe file('/opt/barito_market/BaritoMarket/log') do
    its('link_path') { should eq '/opt/barito_market/shared/log' }
  end

  describe systemd_service('sidekiq') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

describe package('ruby2.5 ruby2.5-dev') do
  it { should be_installed }
end

describe port(80) do
  it { should_not be_listening }
end

describe port(8080) do
  it { should be_listening }
end
