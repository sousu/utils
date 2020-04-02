#!/usr/bin/env ruby
# -*- encoding: Windows-31j -*-

require 'fileutils'
require 'optparse'

$:.unshift File.expand_path("./", File.dirname(__FILE__))
require 'lib/file_picker'

def dirrename(dir_path,ext,exe)
  depth = 1
  fp = FilePicker.new("#{dir_path}",depth)
  fp.set_proc do |file|
    if FileTest::file?(file)
      name = "#{dir_path}/#{File::basename(file,'.*')}.#{ext}"
      puts "Rename  #{file} -> #{name}"
      File::rename(file,name) if exe
    end
  end.done
end


# --- main ---
ext = ""
exe = false
parser = OptionParser.new do |parser|
   parser.banner = "MangaRenamer Usage: extensioner.rb [options] dir_path"
   parser.separator "options:"
   parser.on('-f', '--format FORMAT', String, "extension format"){|f| ext = f }
   parser.on('-e', '--execute', "execute rename"){|e| exe = true }
   parser.on('-h', '--help', "show this message"){ puts parser ; exit 0 }
end

begin 
  parser.parse!
rescue OptionParser::ParseError => err
  $stderr.puts err.message
  $stderr.puts parser.help
  exit 1
end

if ARGV.size == 1
  dirrename(ARGV[0],ext,exe)
  exit 0
else
  $stderr.puts parser.help
  exit 1
end


