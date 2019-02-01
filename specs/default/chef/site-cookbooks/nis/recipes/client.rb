#
# Cookbook:: nis
# Recipe:: client
#
# default recipe already filters for ubuntu, rhel or centos
include_recipe "::default"
include_recipe "::_search_server"

if node['platform'] == "ubuntu"
    package "nis"
else
    package "ypbind"
end


yp_conf_file = "/etc/yp.conf"
server_conf_line = "domain #{node['domain']} server #{node['nis']['server_ipaddress']}"
ruby_block "Update #{yp_conf_file}" do
    block do
        file = Chef::Util::FileEdit.new(yp_conf_file)
        file.insert_line_if_no_match(server_conf_line, server_conf_line)
        file.write_file
    end
end

nsswitch_conf_file = "/etc/nsswitch.conf"
ruby_block "Update #{nsswitch_conf_file}" do
    block do
        file = Chef::Util::FileEdit.new(nsswitch_conf_file)
        # this uses the look-ahead operator to check that nis does not already exist
        file.search_file_replace(/(^hosts:.*$(?<!nis\b))/, '\1 nis')
        file.search_file_replace(/(^group:.*$(?<!nis\b))/, '\1 nis')
        file.search_file_replace(/(^passwd:.*$(?<!nis\b))/, '\1 nis')
        file.write_file
    end
end


service "ypbind" do
    action :restart
end
