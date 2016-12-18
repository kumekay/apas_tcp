require './apas_tcp_server.rb'
require 'logger'

server = ApasTCPServer.new(api_root_url: ENV.fetch('API_SERVER', 'http://localhost:4000'),
                           debug: ENV.fetch('DEBUG', false))
server.run
