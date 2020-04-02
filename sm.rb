#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*- 

require 'selenium-webdriver'

d = Selenium::WebDriver.for(:chrome)
wait = Selenium::WebDriver::Wait.new(:timeout=>20) #動作完了まで最大20秒待タイマ
d.manage.window.resize_to(1400,1000)

begin
  d.get "https://www.google.co.jp/"
  #sleep 3
  q = wait.until{ d.find_element(:name,'q') }
  q.send_keys('テスト検索')
  q.send_keys(:enter)
  sleep 5
  d.save_screenshot('./ss.png')
ensure
  d.quit
end

