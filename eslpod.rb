#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*- 

require 'optimist'
require 'mechanize'
require 'pp'

opts = Optimist::options do
  banner <<-EOS
resl.rb - get pod pdf
  EOS
  opt :usr,"user", :type=> String
  opt :pas,"password", :type=> String
  opt :dir,"destnation", :type=> String
end

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
agent.get('https://esl.culips.com/')
entries = agent.page.search('div#pg-5890-1 div.entry-main') #リスト入手／Latestエピソードのみ

agent.page.link_with(:href => 'https://esl.culips.com/amember/member.php').click
agent.page.form_with(:name => 'login') do |f|
  f['amember_login'] = opts[:usr]
  f['amember_pass'] = opts[:pas]
  f.click_button
end
#puts agent.page.search('div.hgroup') #ログイン状況チェック

entries.each do |e|
  agent.get('https://esl.culips.com/')
  h = e.at('a').text
  agent.page.link_with(:text => h).click

  pdf = "#{opts[:dir]}/"
  as = agent.page.search('div.entry-content a')
  as.each do |e|
    pdf = pdf + $1 if e[:href].to_s.match(/.+\/([^\/]+\.pdf)$/)
  end

  begin
    unless File.exist?(pdf)
      agent.page.link_with(:text => 'btn_lipservice.gif').click
      File.binwrite(pdf,agent.page.body)
      puts "Download to #{pdf}"
    else 
      puts "Skip #{pdf}"
    end
  rescue Exception => e
    pp e
  end
  sleep 2
end

