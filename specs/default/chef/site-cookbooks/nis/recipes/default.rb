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
