#!/usr/bin/env ruby
# -*- encoding: Windows-31j -*-
# ����f�B���N�g�����̃t�@�C���ɑ΂��ĉ��炩�̏������s��

$:.unshift File.expand_path("./", File.dirname(__FILE__))
require 'log'

class FilePicker

  attr_accessor :path,:depth
  attr_reader :logger
  def initialize(path,depth=nil,logger=nil)
    @path = path
    @depth = depth
    @proc = nil
    @logger = (logger||=Log::new)
  end

  def set_proc(&proc)
    @proc = proc
    return self
  end

  def done
    traverse(@path,0)
  end

  private
  def traverse(path,cur_cnt)
    logger.debug "path->#{path}"
    logger.debug "cur_cnt->#{cur_cnt}"
    return if @depth and cur_cnt >= @depth
    begin
      Dir::foreach(path) do |e|
        next if e == "." or e == ".."
        e_path = "#{path}/#{e}"
        logger.debug "e_path->#{e_path}"
        @proc.call(e_path) 
        if FileTest::directory?(e_path)
          traverse(e_path,cur_cnt+1)
        end
      end
    rescue =>exc
      logger.error exc
    ensure
      return
    end
  end
end

# �ȈՎ��s��
if __FILE__ == $0
  require 'optparse'
  # test 
  logger = Log.new(STDOUT,Log::INFO)
  path = 'c:/'
  fp = FilePicker.new path,2,logger
  fp.set_proc do |file|
    if FileTest::directory?(file)
      #f.puts(file) if file =~ /^.*temp.*$/
      puts file
      puts File::atime(file)
    end
  end.done
end

