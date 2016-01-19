namespace :house do

  # desc "Rebuild system"
  # task :rebuild => ["db:drop", "db:setup", :fake]

  task :daily_work => :environment do
    puts "Start to record house."
    Recorder.new.start_record()
    HouseInfoChange.check_change(Time.now.to_date, 1)
  end
end
