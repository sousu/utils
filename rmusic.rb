#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*- 
# music.rb commandline music player by ruby

require 'optparse'
require 'find'

require 'mp3info'
require 'optimist'
require 'rainbow/ext/string'


opts = Optimist::options do
  opt :dir, "Base dir",         :type => :string,  :required => true
  opt :mcode, "char code",      :type => :string,  :required => true
  opt :player, "player cmd",    :type => :string,  :required => true
  opt :key, "KEYWORD",          :type => :string
  opt :folder, "FOLDERNAME",    :type => :string 
  opt :new, "play newest",      :default => false
  opt :random, "play random",   :default => false
end

class Music

  # module Config
  #   Default = {
  #     :path        => ".",
  #     :player      => 'afplay -v .50 -q 1',  # for_mac
  #     :mcode       => "UTF-8",
  #   }
  # end
  
  def initialize(opts)
    @playlist = []
    @pid = nil
    #@opts = Music::Config::Default
    @opts = opts
    Signal.trap(:INT) { puts "\n" }                 # Ctrl+c
    #Signal.trap(:QUIT){ finish }                   # Ctrl+\
  end

  def play

    make_plist

    if @playlist.empty?
      puts "No Files Matched!".color(:red).encode(@opts[:mcode])
      return 
    end
    @playlist.sort!{rand(3)-1} if @opts[:random]
    @playlist.sort_by!{|p| p[:mtime]}.reverse! if @opts[:newest]

    puts "Start Music".color(:yellow).encode(@opts[:mcode])
    
    @playlist.each_with_index do |program,cnt|
      title,artist,album,sec,bitrate,artworkpath = ""
      puts "#{"-------- "*6}--- #{cnt+1}/#{@playlist.size} ---".color("#6699aa").encode(@opts[:mcode])
      puts "#{program[:path]}".color("#aaaaaa").encode(@opts[:mcode])
      begin
        Mp3Info.open(program[:path]) do |mp3|
          title,artist,album = mp3.tag["title"].wash.encode(@opts[:mcode]),
                               mp3.tag["artist"].wash.encode(@opts[:mcode]),
                               mp3.tag["album"].wash.encode(@opts[:mcode])
          sec,bitrate        = mp3.length.to_i.divmod(60).join('min'),
                               mp3.bitrate
        end
      rescue => exc
        printf "Mp3Info error..\n".color(:black).encode(@opts[:mcode])
      ensure
        title = File.basename(program[:path], ".*")+"\n" unless title
        artworkpath = Dir.glob(File.dirname(quote_by_backslash(program[:path]))+"/{cover,folder}*",File::FNM_CASEFOLD)[0] || "" #!issue NOIMAGE
        printf "Title:\t#{title}\t".color(:green)
        printf "Artist:\t#{artist}\n".color(:green) if artist
        printf "Album:\t#{album}\n".color(:green)   if album
        printf "#{sec}sec / #{bitrate}Kbps / ".color(:blue)
        printf "#{program[:mtime]}\n".color(:blue)

        `#{@opts[:player]} #{quote_by_backslash(program[:path])} 2>&1 >/dev/null`

      end
    end
  end

  private

  def make_plist
    Find.find(@opts[:dir].to_s) do |path|
      next unless check_mp3(path)
      next unless match(path)
      mtime = File.mtime(path).strftime("%Y-%m-%d %H:%M:%S")
      @playlist << {:path=>path,:mtime=>mtime}
    end
  end

  def check_mp3(path)
    File.basename(path).wash.encode("UTF-8") =~ /^[^.].+\.mp3$/
  end

  def match(path)
    return true if not @opts[:folder] and not @opts[:key]
    return true if @opts[:folder] and File.dirname(path) =~ Regexp.new(@opts[:folder])
    return true if @opts[:key] and File.basename(path) =~ Regexp.new(@opts[:key])
    return false
  end

  def quote_by_backslash(str)
    str.gsub(/[()'"\\ &\[\]]/){|char| '\\' + char}
  end

  def finish
    puts "\n#{"-------- "*7}".color("#6699aa").encode(@opts[:mcode])
    puts "music.rb End!".color(:yellow).encode(@opts[:mcode])
    sleep 1
    exit 0
  end

end

class String
  def wash
    # 例外を投げないようゴミの排除
    self.encode("UTF-8","UTF-8",invalid: :replace, undef: :replace,replace: '.')
  end
end

if __FILE__ == $0
  m = Music.new(opts)
  m.play
end


