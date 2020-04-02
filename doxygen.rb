#!/usr/bin/env ruby
# -*- encoding: Windows-31j -*-

require 'fileutils'
require 'pathname'
require 'find'
require 'pp'
require 'optimist'

opts = Optimist::options do
  opt :src, "source path",      :type => :string,  :required => true
  opt :dst, "destination path", :type => :string,  :required => true
  opt :c,   "char code",        :type => :string 
end

Dir::chdir(opts[:src]) do
  Dir.glob("*").each do |p|
    puts "make_dir #{opts[:dst]}/#{p}"
    FileUtils.mkdir_p("#{opts[:dst]}/#{p}")
  end
  Dir.glob("./**/*").each do |name|
    next unless FileTest.file?(name)

    if name =~ /\.c$/
      puts "convert\t#{name}"
      code = File.read(name)

      # headerコメントの変換
      code = code.gsub(/^(\/|\*)\*?(?<co>.+?)\*?\/?$/,"\/\/! "+'\k<co>')
      # doxgen形式の個別コメントは削除
      #  gsubの後方参照時はシングルクォーテーション
      code = code.gsub(/^(\s*?)\/{3,}/,'\1//')

      File.write("#{opts[:dst]}/#{name}",code)
    else
      puts "copy\t#{name}"
      File.write("#{opts[:dst]}/#{name}",File.read(name))
    end
  end
end

# ファイル毎処理のサンプル

# 複数行正規表現からキャプチャした
# 部位を入れ替え
#
#  .*?     最短マッチ
#  {5,}    5回以上
#re = /
#  (?<comment>
#    \n\/+\*{5,}[^\n]+?\n
#     (?:\/\*[^\n]*?\n)+
#    \/+\*{5,}[^\n]+?\n
#  )
#  (?<func>
#     [^\n]+?\(.+?\).+?\{
#  )
#  /xm
#  
#code.scan(re) do |comment,func|
#  puts func+comment+"\n"
#end
#
#conv = code.gsub(re,"\n"+'\k<func>'+'\k<comment>')

