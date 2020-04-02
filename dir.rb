#!/usr/bin/env ruby
# -*- encoding: Windows-31j -*-
# 特定配下のファイルに任意処理

require 'fileutils'

$:.unshift File.expand_path("./", File.dirname(__FILE__))
require 'lib/file_picker'

root = 'c:/'
fp = FilePicker.new('t:/tmp',2)

fp.set_proc do |file|
  if FileTest::directory?(file)
    p = "#{root}#{file[/\w:(.+)/,1]}"
    puts p
    #FileUtils::mkdir_p(p)
  end
end.done

