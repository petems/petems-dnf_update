require 'spec_helper_acceptance'

describe 'dnf_update' do

  before(:all) do
    # Make sure package already removed
    shell("dnf remove -y cockpit*", :acceptable_exit_codes => [0,1,2])
  end

  context 'update no package' do
    # Using puppet_apply as a helper
    it 'should update the package' do
      update_pp = <<-EOS
      package{ 'cockpit':
        ensure   => latest,
        provider => dnf_update,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(update_pp, :trace => true, :debug => true, :catch_failures => true)
    end

    describe command('rpm -qa | grep cockpit') do
      its(:stdout) { should_not match /0.55-1/ }
    end

  end

end
