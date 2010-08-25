require 'rubygems'
require 'sinatra'
require 'curb'
require 'xml/xslt'
require 'haml'

set :run, true

get '/' do
    haml :index
end

get '/tickets/:server/:username/:apikey/:project' do
    # Get user's posterous details
    apikey = params[:apikey]
    username = params[:username]
    project = params[:project]
    server = params[:server]
    
    c = Curl::Easy.new("http://#{server}.codebasehq.com/#{project}/tickets.xml") 
    c.username = username
    c.password = apikey
    c.http_get
    tickets = c.body_str
    puts tickets
    
	xslt = XML::XSLT.new()
	xslt.xml = tickets
	xslt.xsl = "cb2pt.xslt"

	out = xslt.serve()
    puts outcb-pt.xslt
end

enable :inline_templates

__END__

@@ layout
%html
  = yield


@@ index
%h1 Codebase 2 PivotalTracker
%p 
  A tiny proxy application which will extract your tickets from Codebase and allow them to be viewed in PivotalTracker. Written by
  %a(href="http://ideasasylum.com") Jamie Lawrence and hosted on Heroku. 
