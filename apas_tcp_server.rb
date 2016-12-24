require 'socket'
require 'excon'
require 'logger'

class ApasTCPServer
  attr_reader :server, :port, :api_root_url, :logger

  def initialize(opts)
    @port = opts[:port] || '4040'
    @logger = opts[:logger] || Logger.new('apas.log')
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

          logger.info(msg) if @debug

          begin
            case command
              when 'pour_amb'
                request_body = URI.encode_www_form(volume: value)
                Excon.post(api_root_url,
                           path: '/api/pourings',
                           body: request_body,
                           headers: {'Content-Type' => 'application/x-www-form-urlencoded'})
              when 'bottle_changed'
                Excon.post(api_root_url,
                           path: '/api/bottle_changes')
            end

          rescue
            logger.error("API Server is not available, request is not sent: #{request_body}")
          end

        end

        client.close
      end
    end
  end
end
