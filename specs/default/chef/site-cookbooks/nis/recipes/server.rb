#
# Cookbook:: nis
# Recipe:: server
#

include_recipe "::default"

# Make the server node searchable by the nis.is_server tag
node.override["nis"]["is_server"] = true
cluster.store_discoverable()

# default recipe already filters for ubuntu, rhel or centos
if node['platform'] == "ubuntu"
    package "nis"
else
    package "ypserv"
    package "ypbind"
end


service "ypserv" do
    action :start
end

# this make will also refresh the yp tables every maintenance converge
bash 'make yp' do
    code <<-EOF
    cd /var/yp
    make
    EOF
  
end

include_recipe "::client"
