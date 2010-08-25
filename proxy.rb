require 'rubygems'
require 'sinatra'
require 'net/https'
require 'xml/xslt'
require 'haml'
require 'logger'


set :run, true
set :logging, true

get '/' do
    haml :index
end

get '/tickets/:server/:username/:apikey/:project' do
    # Get user's posterous details
    apikey = params[:apikey]
    username = params[:username]
    project = params[:project]
    server = params[:server]
    
    tickets = ""
    http = Net::HTTP.new("#{server}.codebasehq.com", 443)
    http.use_ssl = true
    http.start do |http|
      req = Net::HTTP::Get.new("/#{project}/tickets.xml")
      req.basic_auth(username, apikey)
      response = http.request(req)
      tickets = response.body
#      logger.info tickets
    end
    
	xslt = XML::XSLT.new()
	xslt.xml = tickets
	xsl = <<XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/tickets">
  <external_stories type="array">
      <xsl:for-each select="ticket">
      <external_story>
        <external_id><xsl:value-of select="ticket-id"/></external_id>
        <description><xsl:value-of select="summary"/></description>
        <name><xsl:value-of select="summary"/></name>
        <requested_by><xsl:value-of select="reporter"/></requested_by>
        <story_type><xsl:value-of select="ticket-type"/></story_type>
      </external_story>
      </xsl:for-each>
  </external_stories>
</xsl:template>
</xsl:stylesheet>
XML

	out = xslt.serve()
    out
    #tickets
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
  %a(href="http://ideasasylum.com") Jamie Lawrence
  and hosted on Heroku. 
