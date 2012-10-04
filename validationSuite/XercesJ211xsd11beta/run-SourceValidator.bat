@echo off

set JAVA_HOME=C:\Java\jre7
set XERCES_DEV_HOME=C:\GaldosOffline\GoogleKML\KML2.3\SVN\validationSuite\XercesJ211xsd11beta\lib
set PSYCHOPATH_DEPS=%XERCES_DEV_HOME%\org.eclipse.wst.xml.xpath2.processor_1.2.0.jar;%XERCES_DEV_HOME%\cupv10k-runtime.jar
set LIBJARS=%XERCES_DEV_HOME%\xml-apis.jar;%XERCES_DEV_HOME%\xercesImpl.jar;%XERCES_DEV_HOME%\xercesSamples.jar;%PSYCHOPATH_DEPS%

%JAVA_HOME%\bin\java -classpath %LIBJARS% jaxp.SourceValidator -xsd11 -f -va -i %1
