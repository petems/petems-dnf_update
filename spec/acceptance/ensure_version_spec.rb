require 'spec_helper_acceptance'

describe 'dnf_update' do

  before(:all) do
    # Make sure package already removed
    shell("dnf remove -y cockpit*", :acceptable_exit_codes => [0,1,2])
  end

  context 'initial install' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      install_pp = <<-EOS
      package{ 'cockpit':
        ensure   => '0.55-1.fc22',
        provider => dnf_update,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(install_pp, :debug => true, :catch_failures => true)
    end

    describe command('rpm -qa | grep cockpit') do
      its(:stdout) { should match /cockpit-0.55-1/ }
    end

  end

end
