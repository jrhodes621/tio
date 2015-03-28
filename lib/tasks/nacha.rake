namespace :nacha do
  desc "create batch file"
  task :batch => :environment do
    Resque.enqueue(NachaFileWorker)
  end
end
