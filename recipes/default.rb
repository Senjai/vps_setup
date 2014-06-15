package "git-core"
package "zsh"

group "admin"
[node[:user], node[:deploy_user]].each do |user|
  user user[:name] do
    password user[:password]
    gid "admin" unless user == node[:deploy_user]
    home "/home/#{user[:name]}"
    supports manage_home: true
    shell "/bin/zsh"
  end

  template "/home/#{user[:name]}/.zshrc" do
    source "zshrc.erb"
    owner user[:name]
  end
end

node.default['authorization']['sudo']['groups'] = ['admin']
node.default['authorization']['sudo']['sudoers_defaults'] = [
  'env_reset',
  'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
]
include_recipe "sudo"

include_recipe "build-essential"
include_recipe "chruby"
include_recipe "chruby::system"
