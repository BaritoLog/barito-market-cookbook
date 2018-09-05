# encoding: utf-8

# Inspec test for recipe barito_market::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
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

  describe file('/home/barito_market/.ssh/known_hosts') do
    its('mode') { should cmp '0644' }
  end

end

# This is an example test, replace it with your own test.
describe port(80) do
  it { should_not be_listening }
end
describe port(8080) do
  it { should be_listening }
end
describe port(6379) do
  it { should be_listening }
end
