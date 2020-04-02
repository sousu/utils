#!/usr/bin/env ruby
# --- ---
# DropBox任意dirに転送
# --- ---
$:.unshift File.expand_path("./", File.dirname(__FILE__))

require 'fileutils'
require 'find'
require 'lib/log'


logger = Log.new(STDERR,Log::DEBUG)
logger = Log.new(STDERR,Log::INFO)
#logger = Log.new('v:\tmp\rsync_test\log.txt',Log::INFO)

Conf = {
  :SourceDir => "/home/XXXXX/music/rock_pop",
  :DropBox => "/home/YYYYY/Dropbox/music",
  :Lim => 1000, 
  :Logger => logger
}
d_list = []
cnt = 0

# --- main ---
Find.find(Conf[:SourceDir]) do |file|
    if FileTest::directory?(file) and file != Conf[:SourceDir] 
      d_list << file
    end
end

s_list = d_list.sort do |a,b|
  File::stat(a).mtime <=> File::stat(b).mtime
end.reverse

s_list.each do |dir|
  logger.info "cur size: #{cnt}M  dir: #{dir}"
  cnt += `/usr/bin/du -m "#{dir}"`[/^([1-9]+)/,1].to_i
  break if cnt >= Conf[:Lim] 
  FileUtils.cp_r(dir,Conf[:DropBox],{:verbose => true})
end


