<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Edited by XMLSpy® -->
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