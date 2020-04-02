#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*-

require 'fileutils'
require 'optimist'

$:.unshift File.expand_path("./", File.dirname(__FILE__))
require 'lib/file_picker'

def numer(dir,ext,exe)
  puts "== #{(exe)? "Execute" : "Test" } =="
  fp = FilePicker.new(dir,1)
  fp.set_proc do |file|
    if FileTest::file?(file) && ext == File::extname(file)
      md = File::basename(file).match(/^[^\d]*(?<n>\d+)\.(?<e>.+$)/)
      if md
        num = "%03d" % md[:n].to_i
        rename = File::dirname(file)+"\\"+"#{num}.#{md[:e]}"
        puts "Rename\t#{file}\t#{rename}"
        File::rename(file,rename) if exe
      else 
        puts "Not target \t#{file}"
      end
    end
  end.done
end

# --- main ---
opts = Optimist::options do
  banner <<-EOS
  #{File::basename(__FILE__)}:
    ファイル名うまく付け直しユーティリティ
     - 単純番号付けのファイルを任意桁を0でパディングする事でWindowsのファイル並び対策
EOS
  opt :x, "execute", :default=> false
  opt :dir, "target dir", :type=> String
  opt :ext, "target extname", :type=> String
end
Trollop::die "set -d and -e" unless opts[:dir] && opts[:ext]

numer(opts[:dir],opts[:ext],opts[:x])


