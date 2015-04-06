ENV["REDISTOGO_URL"] ||= "redis://username:password@host:1234/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

#uri = URI.parse(REDISTO_GO_URL)
#REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#Resque.redis = REDIS
