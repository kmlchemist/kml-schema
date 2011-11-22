<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsv="http://www.w3.org/2000/05/xsv" version="1.0" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes = "xsv">
 <!-- $Id: xsv.xsl,v 1.12 2003/07/01 16:09:43 ht Exp $ -->
 <!-- Stylesheet for XSV output:  this version tested with IE6 and 
Mozilla 1.3 -->
 
 <xsl:output method="xml" indent="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>

 <!-- The real stylesheet starts here -->
 <xsl:template match="/">
<xsl:processing-instruction name="xml-stylesheet">href="#internalStyle" type="text/css"</xsl:processing-instruction>
  <html>
   <head>
    <title>
     Schema validation report for
	<xsl:value-of select="xsv:xsv/@target"/>
    </title>
    <style type="text/css" id="internalStyle">p.nas { margin-left: 1em; color: red; margin-top: 0px}
           p.sdf { margin-bottom: 0px }
           .node { font-weight: bold }
    </style>
   </head>
   <body>
    <xsl:apply-templates/>
   </body>
  </html>
 </xsl:template>
 
 <xsl:template match="xsv:xsv">
  <h3>Schema validating with <xsl:value-of select="@version"/></h3>
  <xsl:if test="@crash">
    <p><strong>Schema validator crashed</strong><br/>
The maintainers of XSV will be notified, you don't need to
send mail about this unless you have extra information to provide.
If there are Schema errors reported below, try correcting
them and re-running the validation.</p>
  </xsl:if>
  <ul>
    <xsl:apply-templates select="@target"/>
    <xsl:apply-templates select="@docElt"/>
    <xsl:apply-templates select="@validation"/>
    <xsl:apply-templates select="@schemaLocs"/>
    <xsl:apply-templates select="@schemaDocs"/>
    <xsl:apply-templates select="@schemaErrors"/>
    <xsl:apply-templates select="@instanceAssessed"/>
  </ul>
  <hr/>
  <xsl:if test="xsv:XMLMessages">
  <xsl:apply-templates select="xsv:XMLMessages"/>
  </xsl:if>
  
  <xsl:if test="xsv:schemaDocAttempt">
   <h3>Schema resources involved</h3>
   <xsl:apply-templates select="xsv:schemaDocAttempt"/>
   <hr/>
  </xsl:if>
  <xsl:if test="xsv:schemaWarning">
   <h3>Schema representation Warnings</h3>
   <xsl:if test="xsv:schemaWarning[@phase='schema']">
    <h4>Detected during schema construction</h4>
    <xsl:for-each select="xsv:schemaWarning[@phase='schema']">
     <xsl:call-template name="warn"/>
    </xsl:for-each>
   </xsl:if>
   <xsl:if test="xsv:schemaWarning[@phase='instance']">
    <h4>Detected during instance validation</h4>
    <xsl:for-each select="xsv:schemaWarning[@phase='instance']">
     <xsl:call-template name="warn"/>
    </xsl:for-each>
   </xsl:if>
  </xsl:if>
  <xsl:if test="xsv:schemaError">
   <h3>Schema representation errors</h3>
  <xsl:if test="xsv:schemaError[@phase='schema']">
    <h4>Detected during schema construction</h4>
    <xsl:for-each select="xsv:schemaError[@phase='schema']">
     <xsl:call-template name="error"/>
    </xsl:for-each>
   </xsl:if>
   <xsl:if test="xsv:schemaError[@phase='instance']">
    <h4>Detected during instance validation</h4>
    <xsl:for-each select="xsv:schemaError[@phase='instance']">
     <xsl:call-template name="error"/>
    </xsl:for-each>
   </xsl:if>
  </xsl:if>
  <xsl:if test="xsv:invalid|xsv:warning">
   <h3>Problems with the schema-validity of the target</h3> 
  <xsl:apply-templates select="xsv:invalid|xsv:warning"/>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="@*">
  <li>
<strong>
<xsl:value-of select="name()"/>
</strong>: <xsl:value-of select="."/></li>
 </xsl:template>
 
 <xsl:template match="@schemaDocs|@docElt">
  <li>
<strong>
<xsl:value-of select="name()"/>
</strong>: <code><xsl:value-of select="."/></code></li>
 </xsl:template>
 
  <xsl:template match="@target">
  <li><strong>Target</strong>: <code><xsl:value-of select="."/></code>
   <xsl:if test="../@realName"><br/>&#160;&#160;&#160;(<xsl:apply-templates select="../@realName"/>
   <xsl:apply-templates select="../@size"/>
   <xsl:apply-templates select="../@modDate"/>
   <xsl:apply-templates select="../@server"/>)</xsl:if></li>
 </xsl:template>
 
 <xsl:template match="@realName">Real name: <xsl:value-of select="."/></xsl:template>
  
 <xsl:template match="@size">
  <br/>&#160;&#160;&#160;&#160;Length: <xsl:value-of select="."/> bytes
 </xsl:template>
  
 <xsl:template match="@modDate">
  <br/>&#160;&#160;&#160;&#160;Last Modified: <xsl:value-of select="."/>
 </xsl:template>
  
 <xsl:template match="@server">
  <br/>&#160;&#160;&#160;&#160;Server: <xsl:value-of select="."/>
 </xsl:template>
 
 <xsl:template match="@schemaErrors">
  <xsl:variable name="val" select="."/>
  <li>The schema(s) used for schema-validation had
  <xsl:choose>
   <xsl:when test="$val=0">no</xsl:when>
   <xsl:when test="$val=-1">no</xsl:when>
   <xsl:otherwise><xsl:value-of select="$val"/></xsl:otherwise>
  </xsl:choose> error<xsl:choose>
   <xsl:when test="$val=1"></xsl:when>
   <xsl:otherwise>s</xsl:otherwise>
  </xsl:choose>
</li>
 </xsl:template>
 
 <xsl:template match="@instanceAssessed">
  <xsl:variable name="val" select="."/>
  <li>
   <xsl:choose>
   <xsl:when test="$val='false'"><xsl:text>The target was not assessed</xsl:text></xsl:when>
    <xsl:otherwise><xsl:apply-templates select="../@instanceErrors"/></xsl:otherwise>
  </xsl:choose></li>
 </xsl:template>
 
  <xsl:template match="@instanceErrors">
  <xsl:variable name="val" select="."/>
   <xsl:choose>
   <xsl:when test="$val=0">No schema-validity problems were</xsl:when>
   <xsl:when test="$val=1">1 schema-validity problem was</xsl:when>
    <xsl:otherwise><xsl:value-of select="$val"/> schema-validity problems were</xsl:otherwise>
  </xsl:choose> found in the target
 </xsl:template>
 
 <xsl:template match="@validation[.='lax']">
  <li>No declaration for document root found, validation was lax</li>
 </xsl:template>
 
 <xsl:template match="@validation[.='strict']">
  <li>Validation was strict, starting with type <code><xsl:value-of select="../@rootType"/></code></li>
 </xsl:template>
 
 <xsl:template match="xsv:XMLMessages">
  <h3>Low-level XML well-formedness and/or validity processing output</h3>
  <p>
  <pre><xsl:apply-templates/></pre>
  </p>
  <hr/>
 </xsl:template>
 
 <xsl:template match="xsv:schemaDocAttempt">
  <xsl:call-template name="resourceAttempt">
   <xsl:with-param name="rtype"><xsl:value-of select="@source"></xsl:value-of></xsl:with-param>
  </xsl:call-template>
 </xsl:template> 

 <xsl:template name="resourceAttempt">
  <xsl:param name="rtype"/>
  <p class="sdf">Attempt to load a schema document from
<xsl:choose>
 <xsl:when test="@trueURI"><code><xsl:value-of select="@trueURI"/></code> (via <code><xsl:value-of select="@URI"/></code>)</xsl:when>
 <xsl:otherwise><code><xsl:value-of select="@URI"/></code></xsl:otherwise>
</xsl:choose>
 (source: <code><xsl:value-of select="@source"/></code>) for
   <xsl:choose><xsl:when test="@namespace"><code><xsl:value-of select="@namespace"/></code></xsl:when>
    <xsl:otherwise>no namespace</xsl:otherwise>
   </xsl:choose>,
   <xsl:choose>
    <xsl:when test="@outcome='success'"> succeeded</xsl:when>
    <xsl:when test="@outcome='redundant'"> skipped, already loaded</xsl:when>
    <xsl:when test="@outcome='skipped'"> skipped, other docs already loaded for
this namespace: <xsl:value-of select="@otherLocs"/></xsl:when>
    <xsl:when test="@outcome='failure'"> failed:</xsl:when>
   </xsl:choose>
</p>
  <xsl:apply-templates select="xsv:notASchema"/>
 </xsl:template>
 
 <xsl:template match="xsv:notASchema">
  <p class="nas">
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="xsv:invalid" name="error">
  <p><span style="color: red"><xsl:value-of select="@resource"/>:<xsl:value-of select="@line"/>:<xsl:value-of select="@char"/></span>: <span style="color: blue">Invalid<xsl:if test="@code">&#160;per&#160;<a>
<xsl:choose><xsl:when test="contains(@code,'.')"><xsl:attribute name="HREF">http://www.w3.org/TR/xmlschema-1/#<xsl:value-of select="substring-before(@code,'.')"/></xsl:attribute></xsl:when><xsl:otherwise><xsl:attribute name="HREF">http://www.w3.org/TR/xmlschema-1/#<xsl:value-of select="@code"/></xsl:attribute></xsl:otherwise></xsl:choose>
<xsl:value-of select="@code"/></a></xsl:if></span>: <xsl:apply-templates/></p>
  <!-- would like to use whole code, but the clauses don't have IDs yet -->
 </xsl:template>
 
 <xsl:template match="xsv:warning" name="warn">
  <p><span style="color: green"><xsl:value-of select="@resource"/>:<xsl:value-of select="@line"/>:<xsl:value-of select="@char"/></span>: <span style="color: blue">Warning</span>: <xsl:value-of select="."/></p>
 </xsl:template>
 
 <xsl:template match="xsv:fsm">
  <div>
   <h4>Finite State Machine for content model</h4>
   <dl><xsl:apply-templates/></dl>
  </div>
 </xsl:template>
 
 <xsl:template match="xsv:node">
  <dt class="node"><xsl:value-of select="@id"/>
<xsl:if test="@final">*</xsl:if></dt>
  <dd><xsl:apply-templates/></dd>
 </xsl:template>
  
 <xsl:template match="xsv:edge">
  <xsl:value-of select="@label"/>&#160;->&#160;<span class="node"><xsl:value-of select="@dest"/></span><br/>
 </xsl:template>
</xsl:stylesheet>
