function gproxyprod --wraps='/run/current-system/sw/bin/cloud-sql-proxy -g withpara-api:us-central1:paraworks' --description 'alias gproxyprod=/run/current-system/sw/bin/cloud-sql-proxy -g withpara-api:us-central1:paraworks'
    /run/current-system/sw/bin/cloud-sql-proxy -g withpara-api:us-central1:paraworks $argv
end
