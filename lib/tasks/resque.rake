# this is a config file to get resque to work https://gist.github.com/snatchev/131647

task "resque:setup" => :environment do
  ENV['QUEUE'] ||= '*'
end
