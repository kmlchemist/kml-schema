<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" id="kml-2.3" xml:lang="en"
  queryBinding="xslt2" defaultPhase="Main"
  schemaVersion="2.3.0">

  <title>Schematron schema for OGC KML 2.3 documents.</title>

  <ns prefix="kml" uri="http://www.opengis.net/kml/2.2" />

  <p>This schema specifies constraints regarding the structure and content of 
  OGC KML 2.3 documents (OGC 12-007).</p>

  <phase id="Main">
    <active pattern="KmlDocument" />
    <active pattern="DeprecatedElements" />
  </phase>

  <let name="kmlVer" value="if (/kml:kml/@version) then /kml:kml/@version else '2.2'" />

  <pattern id="KmlDocument">
    <rule context="/">
      <assert test="kml:kml" diagnostics="doc.elem">
        The document element must have [local name] = "kml" and [namespace name] = "http://www.opengis.net/kml/2.2".
      </assert>
    </rule>
    <rule context="kml:Track">
      <assert test="$kmlVer eq '2.3'" diagnostics="kml.ver">
        Track elements are only allowed for version 2.3 or higher.
      </assert>
    </rule>
    <rule context="kml:Tour">
      <assert test="$kmlVer eq '2.3'" diagnostics="kml.ver">
        Tour elements are only allowed for version 2.3 or higher.
      </assert>
    </rule>
  </pattern>

  <pattern id="DeprecatedElements">
    <title>Reports the occurrence of deprecated elements.</title>
    <rule context="kml:Placemark | kml:NetworkLink | kml:Folder | kml:Document | kml:GroundOverlay | kml:PhotoOverlay | kml:ScreenOverlay">
      <report flag="warning" diagnostics="parent"
        test="kml:Metadata">The kml:Metadata element is deprecated in KML features (OGC 14-068, ATC-304). Use kml:ExtendedData instead.</report>
      <report flag="warning" diagnostics="parent"
        test="kml:Snippet">The kml:Snippet element is deprecated in KML features (OGC 14-068, ATC-308). Use kml:snippet instead.</report>
    </rule>
    <rule context="kml:BalloonStyle">
      <report flag="warning"
        test="kml:color">The kml:BalloonStyle/kml:color element is deprecated (OGC 14-068, ATC-303). Use kml:bgColor instead.</report>
    </rule>
    <rule context="kml:NetworkLink">
      <report flag="warning"
        test="kml:Url">The kml:NetworkLink/kml:Url element is deprecated (OGC 14-068, ATC-309). Use kml:Link instead.</report>
    </rule>
  </pattern>

  <diagnostics>
    <diagnostic id="doc.elem" xml:lang="en">
      The document element has [local name] = '<value-of select="local-name(/*[1])"/>' and [namespace name] = '<value-of select="namespace-uri(/*[1])"/>'.
    </diagnostic>
    <diagnostic id="kml.ver" xml:lang="en">
      The indicated version is <value-of select="$kmlVer" />.
    </diagnostic>
    <diagnostic id="parent" 
    xml:lang="en">Parent element is <value-of select="local-name(.)"/>[@id='<value-of select="@id"/>']</diagnostic>
  </diagnostics>

</schema>
