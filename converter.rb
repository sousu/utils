#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*-
#
# eplapを使ってのExcelファイル処理
#

require 'nkf'
require 'pp'

$:.unshift File.expand_path("./", File.dirname(__FILE__))
require 'lib/log'
require 'lib/exlap'

#if ARGV.size != 2 or ARGV[0] =~ /-[^wsu]/
#  puts 'use : talk -wsu(platform encode) (textpath)'
#  exit 1
#end

#logger = Log.new(STDOUT,Log::INFO)
logger = Log.new(STDOUT,Log::DEBUG)

#
# - 項目の基準となる結合セル最下部までの行を調べる
# - その行までを一つのブロックと捉え各列で左上から配列化
# - 「ふるい」などを利用して意味ある値を取り出す
#

fpath = "res/data.xlsx"
exlap = Exlap.new 
workbook = exlap.book_open(fpath)

def mode(name)
  case name
  when "VD-T" #,"VD-O"
    return "VORDME"
  end
end

def joint_ranges(sheet,column)
  # 基準列における結合セルrange配列を返す
  ranges = []
  row,start = 1,1
  until sheet[row,column] == nil
    # 1つ先が境界ならばそこまでをRagne化
    row += 1
    if sheet[row,column]  == sheet.Cells.Item(row,column).Value
      ranges.push start..(row-1)
      start = row 
    end
  end
  return ranges
end

# --- main ---
workbook.each do |sheet| 
  row = 0
  if mode(sheet.Name) == "VORDME" 
    pp joint_ranges(sheet,1)

    #ary = sheet.to_a 
    #ary.each do |row| 
    #  puts row.join("\t").gsub(/\n/, "\\n")
    #end 
  end
end
exlap.quit


