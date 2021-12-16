def get_remote_url
  exec('git config --get remote.origin.url')
end