function gproxysand --wraps='/run/current-system/sw/bin/cloud-sql-proxy -g withpara-staging-sandbox-api:us-central1:paraworks-sandbox' --description 'alias gproxysand=/run/current-system/sw/bin/cloud-sql-proxy -g withpara-staging-sandbox-api:us-central1:paraworks-sandbox'
    /run/current-system/sw/bin/cloud-sql-proxy -g withpara-staging-sandbox-api:us-central1:paraworks-sandbox $argv
end
