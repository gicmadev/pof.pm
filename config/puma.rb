threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

port 3000

environment ENV.fetch("RAILS_ENV") { "development" }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
worker_timeout 30

preload_app!

plugin :tmp_restart

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

def safe_try(operation = nil)
  begin
    yield
  rescue Exception => e
    $stderr.puts "Exception raised #{"(#{operation})" if operation.present?}"
    $stderr.puts e.message
    $stderr.puts e.backtrace.join("\n")
  end
end

before_fork do |server, worker|
  safe_try "closing ActiveRecord connections" do
    defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  end
end

on_worker_boot do |server, worker|
  safe_try "relaunching ActiveRecord connection" do
    defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  end
end
