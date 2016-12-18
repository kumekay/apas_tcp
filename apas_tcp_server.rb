require 'socket'
require 'excon'
require 'logger'

class ApasTCPServer
  attr_reader :server, :port, :api_root_url, :logger

  def initialize(opts)
    @port = opts[:port] || '4040'
    @logger = opts[:logger] || Logger.new(STDOUT)
    @debug = opts[:debug]
    @server = TCPServer.new(port)
    @api_root_url = opts[:api_root_url] || 'http://localhost:4000/'
  end

  def run
    loop do
      Thread.start(server.accept) do |client|

        client.print 'ready'
        logger.info('ready')

        while msg = client.gets(';') do

          command, value = msg.chomp(';').split('=')
          command = command.gsub(/^AT_/, '')

          request_body = URI.encode_www_form(command: command, value: value)
          logger.info(request_body) if debug

          begin
            Excon.post(api_root_url,
                       path: '/api/event',
                       body: request_body)
          rescue
            logger.error("API Server is not available, request is not sent: #{request_body}")
          end

        end

        client.close
      end
    end
  end
end
