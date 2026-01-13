if status is-interactive
    # Commands to run in interactive sessions can go here
end

fnm env --use-on-cd --shell fish --log-level quiet | source
alias gproxysand="~/cloud-sql-proxy -g withpara-staging-sandbox-api:us-central1:paraworks-sandbox"
alias gproxyprod="~/cloud-sql-proxy -g withpara-api:us-central1:paraworks"
alias psqlsand="psql -h 127.0.0.1 -p 5432 -U postgres -d paraworks-sandbox"
alias psqlprod="psql -h 127.0.0.1 -p 5432 -U postgres -d paraworks"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/home/int03e/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
