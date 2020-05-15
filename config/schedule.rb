require File.expand_path(File.dirname(__FILE__) + "/environment")

rails_env = ENV['RAILS_ENV'] || :development

set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every 1.minutes do  # タスクを処理するペースを記載する。（例は毎朝7時に実行）
  rake 'push_line:push_line_message_amazon'
end
