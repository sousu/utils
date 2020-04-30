#!/usr/local/bin/ruby
# -*- encoding: UTF-8 -*-

require 'mechanize'
require 'nokogiri'

class Anki
  LOGIN="https://ankiweb.net/account/login"

  def initialize(config)
    @a = Mechanize.new{|a| a.ssl_version="SSLv23"}
    @a.user_agent_alias = 'Windows Mozilla'
    page = @a.get(LOGIN)
    form = page.forms[0]
    form.field_with(:name => "username").value = config["u"]
    form.field_with(:name => "password").value = config["p"]
    page = @a.submit(form)
    @n = page.at('div.deckDueNumber').inner_text.gsub(/\r\n|\r|\n|\s|\t/,"")
  end

  def num
    (10*(120-@n.to_i)/120).to_i
  end
end

if $0 == __FILE__
  require 'yaml'
  a = Anki.new(YAML.load_file(ARGV[0]))

  puts a.num
end

