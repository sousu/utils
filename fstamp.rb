#!/usr/bin/env ruby
# -*- encoding: Windows-31j -*-
# 引数指定ディレクトリ配下ファイルのタイムスタンプをランダムに変更
#

$:.unshift File.expand_path("./", File.dirname(__FILE__))
require 'lib/file_picker'

def edit_stamp(dir_path)
  fp = FilePicker.new("#{dir_path}",99)
  fp.set_proc do |file|
    puts "edit #{file} ..."
    # ---
    d = [*17..19].sample
    h = [*10..16].sample
    m = [*1..59].sample
    s = [*1..59].sample
    # ---
    `/bin/touch "#{file}" -d "2014/3/#{d} #{h}:#{m}:#{s}"`
  end.done
end


# --- main ---
edit_stamp(ARGV[0])


