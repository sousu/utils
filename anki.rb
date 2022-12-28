#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*-

require 'mechanize'
require 'nokogiri'

class Anki
  LOGIN="https://ankiweb.net/account/login"

  def initialize(config,cnt)
    @c = cnt
    @a = Mechanize.new{|a| a.ssl_version="SSLv23"}
    @a.user_agent_alias = 'Windows Mozilla'
    page = @a.get(LOGIN)
    form = page.forms[0]
    form.field_with(:name => "username").value = config["u"]
    form.field_with(:name => "password").value = config["p"]
    page = @a.submit(form)
    sleep 1
    @n = page.at('div.deckDueNumber').inner_text.gsub(/\r\n|\r|\n|\s|\t/,"")
  end

  def num
    b = @c.to_i
    n = (10*(b-@n.to_i)/b).to_i
    n >= 0 ? n : 0
  end
end

if $0 == __FILE__
  require 'yaml'
  a = Anki.new(YAML.load_file(ARGV[0]),ARGV[1])

  puts a.num
end

