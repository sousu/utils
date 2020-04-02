#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*- 

require 'optimist'
require 'mechanize'
require 'pp'

opts = Optimist::options do
  opt :usr,"user", :type=> String
  opt :pas,"password", :type=> String
  opt :id,"id", :type=> String
  opt :ost,"post", :type=> String
end

#agent = Mechanize.new
#agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
#agent.get('https://ifttt.com/login?wp_=1')
#
#agent.page.form_with(:action => '/session') do |f|
#  f['user[username]'] = opts[:usr]
#  f['user[password]'] = opts[:pas]
#  f.click_button
#end
#agent.get('https://ifttt.com/applets/'+opts[:id])
#
#headers={
#  'Accept'=>'*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript',
#  'Accept-Encoding'=>'gzip, deflate, br',
#  'Accept-Language'=>'ja,en-US;q=0.7,en;q=0.3',
#  'Cache-Control'=>'no-cache',
#  'Connection'=>'keep-alive',
#  'Content-Length'=>'0',
#  'DNT'=>'1',
#  'Host'=>'ifttt.com',
#  'Referer'=>'https://ifttt.com/applets/'+opts[:id],
#  'TE'=>'Trailers',
#  'User-Agent'=>'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0',
#  'X-Requested-With'=>'XMLHttpRequest'
#}
#
#res = agent.post('https://ifttt.com/services/line/applets/'+opts[:ost]+'/check',{},headers)
#
#pp res

