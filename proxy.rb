require 'rubygems'
require 'sinatra'
require 'curl'
require 'xml/xslt'

get '/' do
    haml :index
end

post '/:server/:username/:apikey/:project' do
    # Get user's posterous details
    apikey = params[:apikey]
    user = params[:username]
    project = params[:project]
    
    c = Curl::Easy.new("http://#{server}.codebasehq.com/#{project}/tickets.xml") 
    c.username = username
    c.password = password
    c.http_get
    tickets = c.body_str
    puts tickets
    
	xslt = XML::XSLT.new()
	xslt.xml = tickets
	xslt.xsl = "cb2pt.xslt"

	out = xslt.serve()
    puts outcb-pt.xslt
end
