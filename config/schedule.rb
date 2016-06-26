# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/home/victor/cron_log.log"
#
 every 1.days do
   #command "/usr/bin/some_great_command"
   runner "Registro.delete_all('created_at > ?', 60.days.ago)"
   #rake "some:great:rake:task"
 end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
