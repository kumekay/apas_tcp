require 'socket'
require 'logger'

logger = Logger.new('apas.log', 'daily')


server = TCPServer.new 4040
loop do
  Thread.start(server.accept) do |client|
    client.print 'ready'
    logger.info('ready')
    while msg = client.gets(';') do
      logger.info(msg)
    end
    client.close
  end
end
