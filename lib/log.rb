#!/usr/bin/env ruby
# -*- encoding: Windows-31j -*-
#  general logger

class BasicLog
  # log-level constant
  FATAL, ERROR, WARN, INFO, DEBUG = 1, 2, 3, 4, 5

  attr_accessor :level

  def initialize(log_file=nil, level=nil)
    @level = level || INFO
    case log_file
    when String
      @log = open(log_file, "a+")
      @log.sync = true
      @opened = true
    when NilClass
      @log = $stderr
    else
      @log = log_file  # requires "<<". (see BasicLog#log)
    end
  end

  def close
    @log.close if @opened
    @log = nil
  end

  def log(level, data)
    if @log && level <= @level
      data += "\n" if /\n\Z/ !~ data
      @log << data
    end
  end

  def <<(obj)
    log(INFO, obj.to_s)
  end

  def fatal(msg) log(FATAL, "FATAL " << format(msg)); end
  def error(msg) log(ERROR, "ERROR " << format(msg)); end
  def warn(msg)  log(WARN,  "WARN  " << format(msg)); end
  def info(msg)  log(INFO,  "INFO  " << format(msg)); end
  def debug(msg) log(DEBUG, "DEBUG " << format(msg)); end

  def fatal?; @level >= FATAL; end
  def error?; @level >= ERROR; end
  def warn?;  @level >= WARN; end
  def info?;  @level >= INFO; end
  def debug?; @level >= DEBUG; end

  private

  def format(arg)
    str = if arg.is_a?(Exception)
      "#{arg.class}: #{arg.message}\n\t" <<
      arg.backtrace.join("\n\t") << "\n"
    elsif arg.respond_to?(:to_str)
      arg.to_str
    else
      arg.inspect
    end
  end

  def parse_caller(at)
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      file = $1
      line = $2.to_i
      method = $3
      [file, line, method]
    end
  end
end

class Log < BasicLog
  attr_accessor :header_format,:backtrace

  def initialize(log_file=nil, level=nil)
    super(log_file, level)
    @header_format = "[%Y-%m-%d %H:%M:%S]"
  end

  def log(level, data)
    tmp = Time.now.strftime(@header_format)
    tmp << " " << parse_caller(caller[1])
    tmp << " " << data
    super(level, tmp)
  end

  def parse_caller(at)
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      file = File::basename($1)
      line = $2.to_i
      #method = $3
      "#{line}:#{file}"
    end
  end
end


