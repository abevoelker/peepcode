require 'mechanize'
require 'celluloid'
require 'uri'

module PeepCode

  class Session
    include Celluloid

    def initialize(args={})
      args[:auth] ||= ENV['AUTH']
      @agent = Mechanize.new do |a|
        a.request_headers = { 'Cookie' => "auth=#{args[:auth]}; auth_count=0" }
      end
    end

    def get(*args, &block)
      @agent.get(*args, &block)
    end

    def screencasts
      @screencasts ||= Screencast.all(self)
    end

    def dump_screencast(save_dir, screencast)
      screencast.dump(save_dir, self)
    end
  end

  class Screencast
    attr_reader :id, :description

    def initialize(dom_node)
      @id = dom_node.at('small a').attr('href').match(/\/products\/(?<id>\S*)/)[:id]
      @description = dom_node.at('small a').text.strip
      @thumbnail = URI(dom_node.at('img').attr('src'))
    end

    def dump(save_dir=Dir.getwd, session)
      puts "Dumping '#{@description}'..."
      dir = File.join(save_dir, @description)
      thumb_file = File.join(dir, "thumbnail#{File.extname(@thumbnail.path)}")

      Dir.mkdir(dir) unless File.exists?(dir)
      unless File.exists?(thumb_file)
        session.get("https://peepcode.com#{@thumbnail}").save(thumb_file)
      end
      assets(session).map do |k,v|
        file_name = File.basename(v.path)
        full_path = File.join(dir, file_name)
        unless File.exists?(full_path)
          puts " saving #{full_path}..."
          session.get(v).save(full_path)
        end
      end
      puts "'#{@description}' dumped"
    end

    def self.all(session)
      session.get('https://peepcode.com/screencasts').search('.covers').map{|node| Screencast.new(node)}
    end

    private

    def assets(session)
      return @assets if @assets
      page = session.get("https://peepcode.com/products/#{@id}")
      @assets = page.search('tr.asset').reduce({}) do |h, tr|
        h[tr.at('.description').text.strip] = URI(tr.at('td:nth-child(2) a:nth-child(2)').attr('href'))
        h
      end
    end
  end

end
