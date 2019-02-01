#
# Cookbook:: nis
# Recipe:: default
#

if not %w(ubuntu centos rhel).include?(node['platform'])
    Chef::Log.fatal("Only RHEL, CentOS and Ubuntu OS are supported")
    raise
end

domain_name = `domainname`
execute "Set domainname" do
    command "domainname #{node['domain']}"
    not_if "#{domain_name} != #{node['domain']}"
end

# NetworkManager interferes with ypbind and ypserv
# got to figure it out and start
service "NetworkManager" do
    action :stop
end

if node["nis"]["password_authentication"]
    service "sshd" do
        action :nothing
    end
    ruby_block "Allow password SSH access" do
      block do
        rc = Chef::Util::FileEdit.new("/etc/ssh/sshd_config")
        rc.search_file_replace_line(/^PasswordAuthentication no/, "PasswordAuthentication yes")
        rc.write_file
      end
      not_if 'grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config'
      notifies :restart, 'service[sshd]', :immediately 
    end
end
