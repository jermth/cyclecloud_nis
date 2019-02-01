server_ipaddress = nil
cluster_id = node['cyclecloud']['cluster']['id']

# if this is the server node, or if the client has specifed a ipaddress, use it
if node["recipes"].include? "nis::server"
    server_ipaddress = node["ipaddress"]
elsif node["recipes"].include? "nis::client" 
    if not node["nis"]["client"]["server_ipaddress"].nil? 
        server_ipaddress = node["nis"]["client"]["server_ipaddress"]          
    end
end

# Search for manager ipaddress otherwise:
if server_ipaddress.nil?
    nodes = NIS::Helpers.search_for_server(1, 30) do
        nodes = cluster.search(:clusterUID => cluster_id).select { |n|
            if not n['nis'].nil?
                if n['nis']['is_server'] == true
                    Chef::Log.info("Found #{n['ipaddress']} as NIS server")
                end
            end
        }
    end
    if nodes.length > 1
        raise("Found more than one NIS server node. Cookook does not yet support multiple NIS servers")
    end
    server_ipaddress = nodes[0]['ipaddress'] 
end

node.override["nis"]["server_ipaddress"] = server_ipaddress
