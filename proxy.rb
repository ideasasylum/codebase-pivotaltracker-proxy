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

get '/tickets/:server/:project' do
    auth ||=  Rack::Auth::Basic::Request.new(request.env)
    if auth.provided? && auth.basic? && auth.credentials        
        # Get user's posterous details
        username = auth.credentials[0]
        apikey = auth.credentials[1]
        project = params[:project]
        server = params[:server]
        
        tickets = ""
        http = Net::HTTP.new("api3.codebasehq.com", 443)
        http.use_ssl = true
        http.start do |http|
          req = Net::HTTP::Get.new("/#{project}/tickets.xml")
          req.basic_auth("#{server}/#{username}", apikey)
          response = http.request(req)
          tickets = response.body
        end
        
	    xslt = XML::XSLT.new()
	    xslt.xml = tickets
	    xslt.xsl = <<XML
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
        <xsl:choose>
            <xsl:when test="ticket-type = 'enhancement'">
                <story_type>feature</story_type>
            </xsl:when>
            <xsl:when test="ticket-type = 'bug'">
                <story_type>bug</story_type>
            </xsl:when>
            <xsl:when test="ticket-type = 'task'">
                <story_type>chore</story_type>
            </xsl:when>
            <xsl:otherwise>
                <story_type>feature</story_type>
            </xsl:otherwise>
        </xsl:choose>
        <created_at type="datetime">2010/8/1 00:00:00 UTC</created_at>
        <estimate type="integer">2</estimate>
      </external_story>
      </xsl:for-each>
  </external_stories>
</xsl:template>
</xsl:stylesheet>
XML
    
	    output = xslt.serve()
    else
        "No Basic HTTP authentication provided. Please use your Codebase username and apikey"
    end
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
