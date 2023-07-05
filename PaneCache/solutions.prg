*** Support classes for the Solutions pane
#define SOLUTIONADDIN_LOC 		"Solution Add-In"
#define ERROR_BADMANIFEST_LOC 	"Not a valid Solution Add-In manifest file."
#define TITLE_LOC 				"Results of Query"
#define TITLE2_LOC 				"Results of View"
#define ONESOLUTION_LOC			"1 solution found:"
#define MANYSOLUTIONS_LOC		"solutions found:"
#define NOSOLUTIONS_LOC			"No solutions were found that match your search string."
#define SUCCESS_LOC				"Solutions have been successfully updated!"
#define SOLUTIONS_ADDED_LOC		"Number of new solutions:"
#define SOLUTIONS_UPDATED_LOC	"Number of updated solutions:"
#define ERROR_CLEARADDINS_LOC	"Unable to clear Add-Ins due to the following error:"
#define CLEAR_CONFIRM_LOC		"Are you sure you want to clear all add-ins?"

DEFINE CLASS Solutions AS Session

	FUNCTION Handler(cAction, oParameters, oBrowser, oContent)
		LOCAL oAddIn
		LOCAL cType
		LOCAL cFilename
		LOCAL cMethod
		LOCAL cSearchString
		LOCAL lSuccess

		m.lSuccess = .T.		

		DO CASE
		CASE m.cAction == "addin"
			m.lSuccess = .F.
			TRY
				oAddIn = NEWOBJECT("SolutionsAddIn", oContent.CacheDir + "solutions.prg")
				IF oAddIn.ProcessManifest(oContent.CacheDir)
					m.lSuccess = .T.
					MessageBox(SUCCESS_LOC + CHR(10) + CHR(10) + ;
					 SOLUTIONS_ADDED_LOC + " " + TRANSFORM(oAddIn.SolutionsAdded) + ;
					 IIF(oAddIn.SolutionsUpdated > 0, CHR(10) + SOLUTIONS_UPDATED_LOC + " " + TRANSFORM(oAddIn.SolutionsUpdated), ''), 64, SOLUTIONADDIN_LOC)
				ENDIF
			CATCH TO oException
				MessageBox(oException.Message, 48, SOLUTIONADDIN_LOC)
			ENDTRY

		CASE m.cAction == "clearaddins"
			m.lSuccess = .F.
			IF MESSAGEBOX(CLEAR_CONFIRM_LOC, 32 + 4 + 256, SOLUTIONADDIN_LOC) == 6
				TRY
					oAddIn = NEWOBJECT("SolutionsAddIn", oContent.CacheDir + "solutions.prg")
					oAddIn.ClearAddIns(oContent.CacheDir)
					m.lSuccess = .T.
				CATCH TO oException
					MessageBox(oException.Message, 48, SOLUTIONADDIN_LOC)
				ENDTRY
			ENDIF

		OTHERWISE
			m.cType     = oParameters.GetParam("type")
			m.cFilename = oParameters.GetParam("filename")
			m.cHomeDir  = oParameters.GetParam("homedir")

			DO CASE
			CASE m.cAction == "runsolution"
				THIS.RunSolution(m.cType, m.cFilename, m.cHomeDir)

			CASE m.cAction == "viewsolution"
				m.cMethod = oParameters.GetParam("method")
				THIS.ViewSolution(m.cType, m.cFilename, m.cHomeDir, m.cMethod)

			CASE m.cAction == "search"
				m.cSearchString = oParameters.GetParam("searchstring")
				THIS.SearchSolutions(m.cSearchString, oBrowser)
			ENDCASE
		ENDCASE

		RETURN m.lSuccess
	ENDFUNC

	* This function is used to generate an XML
	* string of the combined solution sources:
	* 	- Solution.dbf from the HOME(2) + "Samples\Solution" directory
	*	- TaskPaneSolution.dbf from the cache directory (for add-in solutions)
	FUNCTION GetXML(cCacheDir)
		LOCAL oRec

		SET DELETED ON

		CREATE CURSOR PaneSolution ( ;
		 Key C(25), ;
		 Parent C(25), ;
		 Vendor C(25), ;
		 SetName C(25), ;
		 Text C(254), ;
		 Image C(12), ;
		 File C(254), ;
		 Type C(1), ;
		 HomeDir M, ;
		 Method C(254), ;
		 Descript M ;
		 )

		* grab the standard solutions and put into our cursor
		TRY
			IF FILE(HOME(2) + "Solution\Solution.dbf")
				USE (HOME(2) + "Solution\Solution.dbf") IN 0 SHARED AGAIN ALIAS SolutionStandard
				SELECT * FROM SolutionStandard ORDER BY Text INTO CURSOR TempCursor
				SCAN ALL 
					SCATTER MEMO NAME oRec
					INSERT INTO PaneSolution FROM NAME oRec
					REPLACE ;
					  File WITH ADDBS(ALLTRIM(TempCursor.Path)) + ALLTRIM(oRec.File), ;
					  HomeDir WITH '', ;
					  Vendor WITH "Microsoft" ;
					 IN PaneSolution
				ENDSCAN
			ENDIF
		CATCH TO oException
			MessageBox(oException.Message, 48)
		ENDTRY

		* grab third-party/added solutions and put into our cursor
		TRY
			IF FILE(ADDBS(m.cCacheDir) + "TaskPaneSolution.dbf")
				USE (ADDBS(m.cCacheDir) + "TaskPaneSolution.dbf") IN 0 SHARED AGAIN ALIAS SolutionAddIn

				SELECT * FROM SolutionAddIn ORDER BY Text INTO CURSOR TempCursor
				SCAN ALL
					SCATTER MEMO NAME oRec

					IF EMPTY(oRec.Parent)
						oRec.Parent = "0_"
					ENDIF
					IF EMPTY(oRec.Image)
						oRec.Image = "dot"
					ENDIF
					INSERT INTO PaneSolution FROM NAME oRec
				ENDSCAN
			ENDIF
		CATCH TO oException
			MessageBox(oException.Message, 48)
		ENDTRY

		TRY
			CURSORTOXML("PaneSolution", "cXML", 1, 8)
		CATCH TO oException
			MessageBox(oException.Message, 48)
			m.cXML = .NULL.
		ENDTRY

		RETURN cXML
	ENDFUNC

	FUNCTION SearchSolutions(cSearchString, oBrowser)
		LOCAL nResultsCount
		LOCAL cXML
		LOCAL cXMLResults

		oBrowser.document.all("SearchResults").style.display = "none"
		oBrowser.document.all("ResultsHeader").style.display = "none"

		m.nResultsCount = 0
		IF !EMPTY(m.cSearchString)
			USE (HOME(2) + "Solution\Solution") SHARED AGAIN
			SELECT  ;
			  Image, ;
			  Text, ;
			  Descript, ;
			  Type, ;
			  File, ;
			  Path ;
			 FROM Solution ;
			 WHERE ;
			  Type <> 'N' AND ;
			  (ATC(m.cSearchString, Solution.Text) > 0 OR ATC(m.cSearchString, Descript) > 0) ;
			  ORDER BY Solution.Text ;
			  INTO CURSOR TempCursor
			IF _TALLY > 0
				CREATE CURSOR SolutionCursor (Image M, Title M, Description M, Type M, RunLink M, ViewLink M)

				SELECT TempCursor
				SCAN ALL
					INSERT INTO SolutionCursor ( ;
					 Image, ;
					 Title, ;
					 Description, ;
					 Type, ;
					 RunLink, ;
					 ViewLink ;
					 ) VALUES ( ;
					 ALLTRIM(TempCursor.Image), ;
					 ALLTRIM(TempCursor.Text), ;
					 TempCursor.Descript, ;
					 TempCursor.Type, ;
					 [vfps:runsolution?filename=] + ALLTRIM(TempCursor.path) + '\' + ALLTRIM(TempCursor.file) + [&type=] + TempCursor.type, ;
					 [vfps:viewsolution?filename=] + ALLTRIM(TempCursor.path) + '\' + ALLTRIM(TempCursor.file) + [&type=] + TempCursor.type ;
					)
				ENDSCAN  
				nResultsCount = RECCOUNT("SolutionCursor") 
			ENDIF	
		
			IF m.nResultsCount > 0
				CURSORTOXML("SolutionCursor", "cXML", 1, 8)
				IF m.nResultsCount  = 1
					cXMLResults = "<resultsdata><results>" + ONESOLUTION_LOC + "</results></resultsdata>"
				ELSE
					cXMLResults = "<resultsdata><results>" + ALLTRIM(STR(nResultsCount )) + " " + MANYSOLUTIONS_LOC + "</results></resultsdata>"
				ENDIF
				
				oBrowser.document.all("ResultsXML").loadXML(m.cXML)
				oBrowser.document.all("ResultsHeaderXML").loadXML(m.cXMLResults)
				oBrowser.document.all("ResultsHeader").style.display = ""
				oBrowser.document.all("SearchResults").style.display = ""
			ELSE
				* display no results found
				cXMLResults = "<resultsdata><results>" + NOSOLUTIONS_LOC + "</results></resultsdata>"
				oBrowser.document.all("ResultsHeaderXML").loadXML(m.cXMLResults)
				oBrowser.document.all("ResultsHeader").style.display = ""
			ENDIF
		ENDIF

		RETURN
	ENDFUNC

	FUNCTION RunSolution(cType, cFilename, cHomeDir)
		LOCAL cDirectory
		LOCAL cSavePath
		LOCAL oException
		LOCAL cViewName

		m.cDirectory = SET("DEFAULT") + CURDIR()
		
		IF EMPTY(m.cHomeDir)
			m.cHomeDir = HOME(2) + "Solution"
		ENDIF
		IF DIRECTORY(m.cHomeDir)
			SET DEFAULT TO (m.cHomeDir)
		ENDIF

		m.cSavePath = SET("PATH")
		IF m.cType <> 'V'
			SET PATH TO (m.cSavePath + ';' + JUSTPATH(m.cFilename))
		ENDIF
		m.cFilename = JUSTFNAME(m.cFilename)

		IF ATCC("FFC", SET("PATH")) == 0
			SET PATH TO (SET("PATH") + ';' + HOME() + "FFC\")
		ENDIF

		TRY
			DO CASE
			CASE m.cType == 'F'  && form
				DO FORM (m.cFilename)

			CASE m.cType == 'R'  && report
				REPORT FORM (m.cFilename) PREVIEW NOCONSOLE

			CASE m.cType == 'Q'  && query
				DEFINE WINDOW brow_wind FROM 1,1 TO 30, 100 TITLE TITLE_LOC + ' ' + UPPER(m.cFilename)+ ".QPR " FLOAT GROW MINIMIZE ZOOM CLOSE FONT "Arial",10
				ACTIVATE WINDOW brow_wind NOSHOW
				DO (m.cFilename + ".QPR")
				RELEASE WINDOW brow_wind

			CASE m.cType == 'V'  && view
				DEFINE WINDOW brow_wind FROM 1,1 TO 30, 100 TITLE TITLE2_LOC + ' ' + UPPER(m.cFilename) FLOAT GROW MINIMIZE ZOOM CLOSE FONT "Arial",10
				ACTIVATE WINDOW brow_wind NOSHOW

				IF AT('!', m.cFilename) > 0
					m.cViewName = SUBSTR(m.cFilename, AT('!', m.cFilename) + 1)
					m.cFilename = LEFT(m.cFilename, AT('!', m.cFilename) - 1)
				ELSE
					m.cViewName = m.cFilename
					m.cFilename = "testdata"
				ENDIF

				SET DATABASE TO (m.cFilename)
				SELECT 0
				TRY
					USE (m.cViewName) ALIAS _VIEW
				CATCH
				ENDTRY
				IF !EMPTY(ALIAS())
					* We had no error opening table
					BROWSE
					RELEASE WINDOW brow_wind
					USE
				ENDIF

			ENDCASE
		CATCH TO oException
			MessageBox(oException.Message)
		ENDTRY

		IF EMPTY(m.cSavePath)
			SET PATH TO
		ELSE
			SET PATH TO (m.cSavePath)
		ENDIF

		IF !EMPTY(m.cDirectory)
			SET DEFAULT TO (m.cDirectory)
		ENDIF

		RETURN
	ENDFUNC

	FUNCTION ViewSolution(cType, cFilename, cHomeDir, cMethod)
		LOCAL cDirectory
		LOCAL cSavePath
		LOCAL oException
		LOCAL cViewName

		m.cDirectory = SET("DEFAULT") + CURDIR()

		IF EMPTY(m.cHomeDir)
			m.cHomeDir = HOME(2) + "Solution"
		ENDIF
		IF DIRECTORY(m.cHomeDir)
			SET DEFAULT TO (m.cHomeDir)
		ENDIF

		m.cSavePath = SET("PATH")

		IF m.cType <> 'V'
			SET PATH TO (m.cSavePath + ';' + JUSTPATH(m.cFilename))
		ENDIF
		m.cFilename = JUSTFNAME(m.cFilename)
		
		IF ATCC("FFC", SET("PATH")) == 0
			SET PATH TO (SET("PATH") + ';' + HOME() + "FFC\")
		ENDIF
	
		TRY
			DO CASE
			CASE m.cType == 'F'  && form
				IF EMPTY(m.cMethod)
					MODIFY FORM (m.cFilename)
				ELSE		
					MODIFY FORM (m.cFilename) METHOD &cMethod
				ENDIF

			CASE m.cType == 'R'  && report
				MODIFY REPORT (m.cFilename)

			CASE m.cType == 'Q'  && query
				MODIFY QUERY (m.cFilename)

			CASE m.cType == 'V'  && view
				IF AT('!', m.cFilename) > 0
					m.cViewName = SUBSTR(m.cFilename, AT('!', m.cFilename) + 1)
					m.cFilename = LEFT(m.cFilename, AT('!', m.cFilename) - 1)
				ELSE
					m.cViewName = m.cFilename
					m.cFilename = "testdata"
				ENDIF
				SET DATABASE TO m.cFilename
				MODIFY VIEW (m.cViewName)
			ENDCASE
		CATCH TO oException
			MessageBox(oException.Message)
		ENDTRY

		IF EMPTY(m.cSavePath)
			SET PATH TO
		ELSE
			SET PATH TO (m.cSavePath)
		ENDIF

		IF !EMPTY(m.cDirectory)
			SET DEFAULT TO (m.cDirectory)
		ENDIF
	ENDFUNC

ENDDEFINE

* This classes is used to process a solution
* add-in manifest file.
DEFINE CLASS SolutionsAddIn AS Session
	Vendor  = ''
	SetName = ''
	
	SolutionsAdded   = 0
	SolutionsUpdated = 0
	
	HomeDir = ''

	* <cDirectory> = cache directory where TaskPaneSolution.dbf can be found or should be created
	* [cFilename] = name of manifest xml file; if not specified, user is prompted for it
	FUNCTION ProcessManifest(cDirectory, cFilename)
		LOCAL xmldoc
		LOCAL oXMLRoot
		LOCAL lSuccess
		LOCAL oException
		LOCAL lSuccess
		LOCAL cDir

		THIS.SolutionsAdded   = 0
		THIS.SolutionsUpdated = 0

		IF VARTYPE(m.cFilename) <> 'C' OR !FILE(m.cFilename)
			m.cDir = SET("DIRECTORY")
			IF DIRECTORY(HOME(2) + "Solution")
				SET DIRECTORY TO (HOME(2) + "Solution")
			ENDIF
			m.cFilename = GETFILE("xml")
			SET DIRECTORY TO (m.cDir)

			IF EMPTY(m.cFilename)
				RETURN .F.
			ENDIF
		ENDIF
		
		THIS.HomeDir = JUSTPATH(m.cFilename)
		
		m.lSuccess = .T.
		IF FILE(HOME(2) + "Solution\Solution.dbf")
			TRY
				USE (HOME(2) + "Solution\Solution") IN 0 SHARED AGAIN ALIAS Solution
			CATCH
			ENDTRY
		ENDIF
		
		m.cDirectory = ADDBS(m.cDirectory)
		IF FILE(m.cDirectory + "TaskPaneSolution.dbf")
			TRY
				USE (m.cDirectory + "TaskPaneSolution") IN 0 SHARED AGAIN ALIAS TaskPaneSolution
			CATCH TO oException
				m.lSuccess = .F.
				MESSAGEBOX(oException.Message, 48, SOLUTIONADDIN_LOC)
			ENDTRY
		ELSE
			TRY
				CREATE TABLE (m.cDirectory + "TaskPaneSolution") ( ;
				  Key C(25), ;
				  Parent C(25), ;
				  Vendor C(25), ;
				  SetName C(25), ;
				  Text C(65), ;
				  Image C(254), ;
				  File C(254), ;
				  Type C(1), ;
				  HomeDir M, ;
				  Method C(130), ;
				  Descript M, ;
				  Internal L, ;
				  Modified T ;
				 )
			CATCH TO oException
				m.lSuccess = .F.
				MESSAGEBOX(oException.Message, 48, SOLUTIONADDIN_LOC)
			ENDTRY
		ENDIF

		IF m.lSuccess
			TRY
				m.xmldoc = CREATEOBJECT("Microsoft.XMLDOM")
			CATCH TO oException
				MESSAGEBOX(oException.Message, 48, SOLUTIONADDIN_LOC)
			ENDTRY

			IF VARTYPE(m.xmldoc) == 'O'
				m.xmldoc.async = .F.
				IF m.xmldoc.Load(m.cFilename)
					oXMLRoot = m.xmldoc.DocumentElement
					THIS.Vendor = THIS.GetXMLAttrib(oXMLRoot, "vendor")
					THIS.SetName = THIS.GetXMLAttrib(oXMLRoot, "name")
					
					IF EMPTY(THIS.Vendor) OR EMPTY(THIS.SetName)
						m.lSuccess = .F.
					ELSE
						THIS.ProcessSolutions(oXMLRoot)
						THIS.ProcessCategories(oXMLRoot)
					ENDIF
				ELSE
					m.lSuccess = .F.
				ENDIF

				IF !m.lSuccess
					MESSAGEBOX(ERROR_BADMANIFEST_LOC, 48, SOLUTIONADDIN_LOC)
				ENDIF
			ENDIF
		ENDIF
		
		RETURN m.lSuccess
	ENDFUNC


	FUNCTION ProcessCategories(oRoot, cCategoryID)
		LOCAL oCategoryList
		LOCAL nCategoryIndex
		LOCAL oCategory
		LOCAL cCategoryKey
		LOCAL cID
		LOCAL cText
		
		IF VARTYPE(m.cCategoryID) <> 'C'
			m.cCategoryID = ''
		ENDIF
		
		oCategoryList = oRoot.SelectNodes("category")
		FOR nCategoryIndex = 1 TO oCategoryList.length
			oCategory = oCategoryList.item(nCategoryIndex - 1)

			m.cID = THIS.GetXMLAttrib(oCategory, "key")
			IF EMPTY(m.cID)
				m.cID = SYS(2015)
			ENDIF
			
			IF EMPTY(m.cCategoryID)
				m.cCategoryID = "0_"
			ENDIF

			* create or update an existing category
			SELECT TaskPaneSolution
			SCATTER MEMO NAME oRec BLANK
			oRec.Key      = PADR(m.cID, LEN(TaskPaneSolution.Key))
			oRec.Parent   = PADR(m.cCategoryID, LEN(TaskPaneSolution.Parent))
			oRec.Vendor   = THIS.Vendor
			oRec.SetName  = THIS.SetName
			oRec.Text     = THIS.GetXMLValue(oCategory, "text")
			oRec.Type     = 'N'
			oRec.Image    = THIS.GetXMLValue(oCategory, "image")
			oRec.File     = ''
			oRec.HomeDir  = ''
			oRec.Method   = ''
			oRec.Descript = ''
			oRec.Modified = DATETIME()
			oRec.Internal = .F.

			LOCATE FOR Key == oRec.Key AND Parent == oRec.Parent
			IF FOUND()
				GATHER MEMO NAME oRec
			ELSE
				INSERT INTO TaskPaneSolution FROM NAME oRec
			ENDIF

			THIS.ProcessSolutions(oCategory, m.cID)
			THIS.ProcessCategories(oCategory, m.cID)
			
		ENDFOR
	ENDFUNC


	FUNCTION ProcessSolutions(oRoot, cCategoryID)
		LOCAL cText
		LOCAL oSolutionList
		LOCAL nSolutionIndex
		LOCAL oSolution
		LOCAL cID
		LOCAL oRec
		LOCAL lFoundCategory

		IF VARTYPE(m.cCategoryID) <> 'C' OR EMPTY(m.cCategoryID)
			m.cCategoryID = ''
		ENDIF

		oSolutionList = oRoot.SelectNodes("solution")
		FOR nSolutionIndex = 1 TO oSolutionList.length
			oSolution = oSolutionList.item(nSolutionIndex - 1)

			IF EMPTY(m.cCategoryID)
				m.cCategoryID = THIS.GetXMLAttrib(oSolution, "parent")
			ENDIF
			
			* make sure the category exists
			SELECT TaskPaneSolution
			LOCATE FOR Key == PADR(m.cCategoryID, LEN(TaskPaneSolution.Key))
			m.lFoundCategory = FOUND()
			IF !m.lFoundCategory AND USED("Solution")
				SELECT Solution
				LOCATE FOR Key == PADR(m.cCategoryID, LEN(Solution.Key))
				m.lFoundCategory = FOUND()
			ENDIF
			
			IF m.lFoundCategory
				m.cID = THIS.GetXMLAttrib(oSolution, "key")
				IF EMPTY(m.cID)
					m.cID = SYS(2015)
				ENDIF
				
				* create or update existing solution
				SELECT TaskPaneSolution
				SCATTER MEMO NAME oRec BLANK
				oRec.Key      = PADR(m.cID, LEN(TaskPaneSolution.Key))
				oRec.Parent   = PADR(m.cCategoryID, LEN(TaskPaneSolution.Parent))
				oRec.Vendor   = THIS.Vendor
				oRec.SetName  = THIS.SetName
				oRec.Text     = THIS.GetXMLValue(oSolution, "text")
				oRec.Type     = THIS.GetXMLValue(oSolution, "type")
				oRec.Image    = THIS.GetXMLValue(oSolution, "image")
				oRec.File     = THIS.GetXMLValue(oSolution, "file")
				oRec.HomeDir  = THIS.GetXMLValue(oSolution, "homedir")
				oRec.Method   = THIS.GetXMLValue(oSolution, "method")
				oRec.Descript = THIS.GetXMLValue(oSolution, "description")
				oRec.Modified = DATETIME()
				oRec.Internal = .F.

				IF EMPTY(oRec.HomeDir)
					oRec.HomeDir = THIS.HomeDir
				ENDIF

				LOCATE FOR Key == oRec.Key AND Parent == oRec.Parent
				IF FOUND()
					GATHER MEMO NAME oRec
					THIS.SolutionsUpdated = THIS.SolutionsUpdated + 1

				ELSE
					INSERT INTO TaskPaneSolution FROM NAME oRec
					THIS.SolutionsAdded = THIS.SolutionsAdded + 1
				ENDIF
			ENDIF
		ENDFOR
	ENDFUNC


	FUNCTION GetXMLAttrib(oNode, cAttrib)
		LOCAL cValue
		
		TRY
			m.cValue = oNode.Attributes.GetNamedItem(m.cAttrib).Text
		CATCH
			m.cValue = ''
		ENDTRY
		
		RETURN m.cValue
	ENDFUNC

	FUNCTION GetXMLValue(oNode, cElement)
		LOCAL cValue

		TRY
			m.cValue = oNode.selectSingleNode(m.cElement).text
		CATCH
			m.cValue = ''
		ENDTRY
		
		RETURN m.cValue
		
	ENDFUNC


	* Clear out all add-ins
	FUNCTION ClearAddIns(m.cDirectory)
		LOCAL oException
		LOCAL cBackupTable
		LOCAL nFileCnt
		LOCAL cSafety

		TRY
			USE (m.cDirectory + "TaskPaneSolution") IN 0 EXCLUSIVE ALIAS TaskPaneSolution
		CATCH TO oException
			m.lSuccess = .F.
			MESSAGEBOX(ERROR_CLEARADDINS_LOC + CHR(10) + CHR(10) + m.oException.Message, MB_ICONEXCLAMATION, TOOLBOX_LOC)
		ENDTRY

		IF USED("TaskPaneSolution")		
			m.nFileCnt = 0
			m.cBackupTable = m.cDirectory + JUSTSTEM("TaskPaneSolution") + "Backup.dbf"
			DO WHILE FILE(m.cBackupTable)
				m.nFileCnt = m.nFileCnt + 1
				m.cBackupTable = m.cDirectory + JUSTSTEM("TaskPaneSolution") + "Backup_" + TRANSFORM(m.nFileCnt) + ".dbf"
			ENDDO

			m.cSafety = SET("SAFETY")
			SET SAFETY OFF
			TRY
				SELECT TaskPaneSolution
				COPY TO (m.cBackupTable) WITH PRODUCTION

				SELECT TaskPaneSolution
				ZAP IN TaskPaneSolution
				APPEND FROM (m.cBackupTable) FOR Internal

			CATCH TO oException
				MESSAGEBOX(ERROR_CLEARADDINS_LOC + CHR(10) + CHR(10) + m.oException.Message, MB_ICONEXCLAMATION, TOOLBOX_LOC)
			ENDTRY

			SET SAFETY &cSafety
			
			IF USED("TaskPaneSolution")
				USE IN TaskPaneSolution
			ENDIF
		ENDIF
		
	ENDFUNC
ENDDEFINE
