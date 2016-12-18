require 'socket'
server = TCPSocket.open(ENV.fetch('APAS_TCP_SERVER', 'localhost'),
                   ENV.fetch('APAS_TCP_PORT', '4040'))
ready = server.gets(5)
puts ready

loop do
  msg = rand > 0.1 ? "AT_pour_amb=#{100 + rand(200).to_i};" : 'AT_bottle_changed=1;'
  server.print(msg)
  puts msg
  sleep rand(10)
end

server.close
