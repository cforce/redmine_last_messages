require 'redmine'
require 'last_messages_hooks'

Redmine::Plugin.register :redmine_last_messages do
  name 'Redmine last forum messages plugin'
  author 'Pavel Vinokurov, Sergei Vasiliev'
  description 'Show latest forum messages on Home and project Overview in a box similar to Latest News'
  version '0.0.2'
end
