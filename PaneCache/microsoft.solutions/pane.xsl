<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="Windows-1252"/>
<xsl:template match="VFPData">
	<HTML>
		<HEAD>
		</HEAD>
		<STYLE>
			BODY {
			font-family:verdana;
			font-size:9pt;
			margin-top:0px;
			margin-left:2px;
			margin-right:2px;	
			margin-bottom:2px;
			}  
			H3  {
			margin-bottom:0px;
			margin-top:0px;
			font-weight: bold
			}	  	
			TD   {font-size:9pt}
			a:link {  color: #0033CC;text-decoration: none}
			a:visited {   text-decoration: none}
			a:hover {  color: #CC0000;text-decoration: underline}
			A {  text-decoration: underline; font-family: Verdana, Arial, Helvetica, sans-serif; color: #0066FF}
			}
A.button
	{
	background:#E0DFE3;
	font-family:Tahoma;
	font-weight:bold;
	padding:2px;
	margin-left:0px;
	margin-right:2px;
	border-top:1px solid #E5E4E8;
	border-left:1px solid #E5E4E8;
	border-bottom:1px solid #6699CC;
	border-right:1px solid #6699CC;	
	color: #0066CC;
	font-size:10pt;
	line-height:2em;
	text-align:center;
	}
			TD.TableTitle
			{ 
			padding:2px;
			background-color:#6699CC;
			color:#FFFFFF;
			}
			TR.TableSubTitle TD
			{
			border-bottom: #6699CC  1pt solid
			}
			

			TABLE.Sol 
			{
				border-right: #cccc99 1px solid;
				border-top: #cccc99 1px solid;
				border-left:#cccc99 1px solid;
				border-bottom: #cccc99 1px solid;
			}
			
			TR.SolutionHeader TD
			{
			font-weight: bold;
			padding:2px;
			background-color:#f5f5dc;
				border-right: #cccc99 1px solid;
				border-top: #cccc99 1px solid;
				border-left:#cccc99 1px solid;
				border-bottom: #cccc99 1px solid;

				
			}

			TR.SolutionTitle TD
			{
			font-size: 8pt; 
			border-bottom: #C0C0C0  1pt solid
			}

			TR.ResultsHeader TD
			{
			font-size: 8pt; 
			color:	#000080 ;
			background-color:#f0f8ff;
			}
			TABLE.cat {
			margin-left: 15px;
			}
			TABLE.subcat {
			margin-left: 15px;
			}
			A.toggle:link {  font-weight: bold;color: #000000;text-decoration: none}
			A.toggle:visited {   font-weight: bold;text-decoration: none}
			A.toggle:hover {  font-weight: bold;color: #000000;text-decoration: none}
			A.toggle {  font-weight: bold;text-decoration: none; color: #000000}

			
		</STYLE>	
		<SCRIPT><xsl:comment><![CDATA[
				
				function showContent( cID) {
				var content = cID + "_content"
				var link = cID + "_link"
				if (window.document.all(content).style.display == "none")
				{
				window.document.all(link).src = "m1.gif";
				window.document.all(content).style.display = "";
				}
				else
				{
				window.document.all(link).src = "p1.gif";
				window.document.all(content).style.display = "none";
				}
				}

				function doSearch( ) {
				if (window.document.thisform.searchstring.value == "") {
					alert("Please enter a search phrase.");
					window.document.thisform.searchstring.focus()
					} else { window.document.thisform.submit();
					}
				}
									
				]]></xsl:comment></SCRIPT>
		
		<SCRIPT for="window" event="onload"><xsl:comment><![CDATA[
				stylesheet = document.XSLDocument;
				source = document.XMLDocument;
				]]></xsl:comment>
		</SCRIPT>

		<BODY leftmargin="0" topmargin="0">
			<XML ID="ResultsHeaderXML">
			</XML>
			<XML ID="ResultsXML">
			</XML>
			
			<TABLE width="100%" cellspacing="0" cellpadding="0">
				<TR>
					<TD class="TableTitle" width="100%"><h3>Solution Samples</h3></TD>
					<TD  align="left" valign="center"><img src="solend.gif" alt="" /></TD>
				</TR>
				<TR>
				<TD colspan="2">
					<TABLE width="100%" cellspacing="2" cellpadding="2">
						<TR class="TableSubTitle" >
							<TD colspan="2" >You can search or browse for solution samples you have installed.</TD>
						
						</TR>
					</TABLE>
				</TD>
				</TR>
				<TR >
					<TD colspan="2" height="10"></TD>
					
				</TR>
				<TR>
					<TD colspan="2">
						<TABLE width="100%" cellspacing="0" cellpadding="0">
						<tr class="SolutionHeader">
						<td>Search for a sample by entering a search string below:</td>
						</tr>
						<tr>
						<td >
						<TABLE class="Sol" width="100%" cellspacing="2" cellpadding="2">
							<tr>
							<td>
								<form action="vfps:search" style="margin-bottom:0px" name="thisform">
								<input type="text" id="searchstring" style="vertical-align:middle;" /><xsl:text> </xsl:text>
								<A href="javascript:doSearch()" class="button">Search</A>
								
								</form>
							</td>
							</tr>
							<tr id="ResultsHeader" class="ResultsHeader" style="display:none">
							<td >
								<span datasrc="#ResultsHeaderXML" datafld="results"></span>
							</td>
							</tr>
							<tr>
							<td>
							    <table datasrc="#ResultsXML" id="SearchResults" cellpadding="2" cellspacing="2" width="100%" style="display:none">
								<TR>
									<TD valign="top">
										<A datafld="runlink"><span datafld="title"></span></A>
									</TD>
									<TD valign="top" align="right">
										<A datafld="viewlink"><img border="0" src="showcode.gif" align="absmiddle" alt="Click here to view the code" /></A>
									</TD>
								</TR>
								<TR class="SolutionTitle">
									<TD colspan="2" valign="top">
										<span datafld="description"></span>
									</TD>
								</TR>
								<TR class="spacer">
									<TD valign="top" colspan="2" height="6">
									</TD>
								</TR>
							    </table>
							</td>
							</tr>
						</TABLE>
						</td>
						</tr>
						</TABLE>
					</TD>
					</TR>			          
					<TR >
					<TD colspan="2" height="10"></TD>
					
					</TR>
					<TR>
					<TD valign="top" colspan="2">
					<TABLE width="100%" cellspacing="0" cellpadding="0">
						<TR class="SolutionHeader">
						<td>Browse for a sample by category:</td>
						</TR>
						<TR>
						<TD>
						<TABLE class="Sol" width="100%" cellspacing="0" cellpadding="1">
							<tr>
							<td width="100%">
							<DIV id="categories">
								<xsl:apply-templates/>
							</DIV>
							</td>
							</tr>
						</TABLE>
						</TD>
						</TR>
					</TABLE>	
					</TD>
					
				</TR>
<TR >
					<TD colspan="2" height="10"></TD>
					
					</TR>
				<TR>
				<TD width="100%" colspan="2">
				<TABLE width="100%" cellspacing="0" cellpadding="0">
						<TR class="SolutionHeader">
						<td >
						Solution Sample Add-Ins: 
						</td>
						</TR>
						<TR>
						<td >
						Install downloaded samples so that they are available from the Task Pane. Simply click the button below and navigate to the sample's manifest file. 
						</td>
						</TR>
						<TR>
						<td>
						<A href="vfps:addin?refresh" class="button">Install Sample</A>
						</td>
						</TR>
					</TABLE>	
			
			
				</TD>
				</TR>
			</TABLE>
			
		</BODY>		

	</HTML>
</xsl:template>

<xsl:template match="//category" name="categories">
	<xsl:variable name="idvar" select="id"/>
	<xsl:variable name="imagevar" select="showimage"/>
	<TR>
		<TD>
			<A href="javascript:showContent('{$idvar}')" class="toggle"><img border="0" src="p1.gif" id="{$idvar}_link" 

align="absmiddle" /><img border="0" src="{$imagevar}.gif" align="absmiddle" /><xsl:text> </xsl:text>
			<xsl:value-of select="title"/></A>
		</TD>
		</TR>
		<TR>
		<TD width="100%">
		<TABLE cellspacing="0" cellpadding="1" id="{$idvar}_content" style="display:none" class="cat" width="95%">
			<xsl:if test="category">
				<xsl:for-each select="category">
					<xsl:call-template name="categories"/>
				</xsl:for-each>
			</xsl:if>
			<xsl:call-template name="solution"/>
		</TABLE>
			
		</TD>
	</TR>
</xsl:template>		

<xsl:template name="solution">
	<xsl:for-each select="solution">
		<xsl:variable name="idvar" select="id"/>
		<xsl:variable name="runlinkvar" select="runlink"/>
		<xsl:variable name="viewlinkvar" select="viewlink"/>
		<TR >
			<TD valign="top">
				<A href="{$runlinkvar}"><xsl:value-of select="title"/></A>
			</TD>
			<TD valign="top" align="right">
			<xsl:if test="string(viewlink)">
				<A href="{$viewlinkvar}" ><img border="0" src="showcode.gif" align="absmiddle" alt="Click here to view the code" /></A>
			</xsl:if>
			</TD>
		</TR>
		<TR class="SolutionTitle">
			<TD colspan="2" valign="top">
				<xsl:value-of select="description"/>
			</TD>
		</TR>
		<TR class="spacer">
			<TD valign="top" colspan="2" height="6">
			</TD>
		</TR>
	</xsl:for-each>
</xsl:template>

	
</xsl:stylesheet>
