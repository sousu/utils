#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*- 

require 'optimist'
require 'yaml'
require 'selenium-webdriver'
require 'pp'

opts = Optimist::options do
  opt :config,"Set config file",:type=>:string
end
exit unless opts[:config]
cnf = YAML.load_file(opts[:config])

d = Selenium::WebDriver.for(:firefox)
wait = Selenium::WebDriver::Wait.new(:timeout=>20)

begin
  puts "init"
  d.get('https://ifttt.com/login?wp_=1')
  u = wait.until{ d.find_element(:name,'user[username]') }
  u.send_keys(cnf['u'])
  p = wait.until{ d.find_element(:name,'user[password]') }
  p.send_keys(cnf['p'])
  p.send_keys(:enter)
  sleep 5

  x = '//*[@id="config-editor"]/div[3]/div/div[3]/div[2]/a'
  cnf['l'].each do |url|
    puts "update #{url}"
    d.get(url)
    a = wait.until{ d.find_element(:xpath,x) }
    a.click
    sleep 5
  end

  #d.save_screenshot('./ss.png')
ensure
  puts "end"
  d.quit
end


