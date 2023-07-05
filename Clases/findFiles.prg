DO functionFiles

DEFINE CLASS findFiles AS CUSTOM
	cursorname	= ""
	wildCards	= ""
 
PROCEDURE INIT(lcPath, lcWildCards, loParent)
    IF TYPE("loParent") = "O"
        THIS.cursorname	= loParent.cursorname
        THIS.wildCards	= loParent.wildCards
    ELSE
        THIS.cursorname	= "cs" + SUBSTR(SYS(2015), 3,10)
        THIS.wildCards	= UPPER(lcWildCards)
	 
        SELECT 0
        CREATE CURSOR (THIS.cursorname) (nameFile C(250), routePath C(250))
    ENDIF
 
    THIS.DoFind(lcPath)
 
PROCEDURE DoFind(lcPath)
	#DEFINE MAX_PATH 260
	#DEFINE FILE_ATTRIBUTE_DIRECTORY 16
	#DEFINE INVALID_HANDLE_VALUE -1
	#DEFINE MAX_DWORD 0xffffffff+1
	#DEFINE FIND_DATA_SIZE  318 

	lcPath 		= ALLTRIM(lcPath)
	IF Right(lcPath,1) <> "\"
		lcPath = lcPath + "\"
	ENDIF
	
	LOCAL hFind, cFindBuffer, lnAttr, cFilename, nFileCount,;
	nDirCount, nFileSize, cWriteTime, nLatestWriteTime, oNext
	
	cFindBuffer	= REPLICATE(Chr(0), FIND_DATA_SIZE)
	hFind		= FindFirstFile(lcPath + "*.*", @cFindBuffer)
	IF hFind = INVALID_HANDLE_VALUE
		RETURN
	ENDIF
	
	STORE 0 TO nDirCount, nFileCount, nFileSize, nLatestWriteTime
	DO WHILE .T.
		lnAttr		= buf2dword(SUBSTR(cFindBuffer, 1,4))
		cFilename	= SUBSTR(cFindBuffer, 45,MAX_PATH)
		cFilename	= Left(cFilename, AT(Chr(0),cFilename)-1)
		cWriteTime	= SUBSTR(cFindBuffer, 21,8)
		
		IF EMPTY(nLatestWriteTime)
			nLatestWriteTime = cWriteTime
		ELSE
			IF CompareFileTime(cWriteTime, nLatestWriteTime) = 1
				nLatestWriteTime = cWriteTime
			ENDIF
		ENDIF
		
		IF BITAND(lnAttr, FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY
			* for a directory
			nDirCount = nDirCount + 1
			IF !LEFT(cFilename,1)="."
				oNext = CREATEOBJECT("findFiles", lcPath + cFilename + "\", This.wildCards, THIS)
			ENDIF
		ELSE
			* for a regular file
			nFileCount	= nFileCount + 1
			nFileSize	=	nFileSize +;
							buf2dword(SUBSTR(cFindBuffer, 29,4)) * MAX_DWORD +;
							buf2dword(SUBSTR(cFindBuffer, 33,4))
		ENDIF
		
		IF LIKE(This.wildCards, UPPER(cFilename))
			INSERT INTO (THIS.cursorname) VALUES ( UPPER(ALLTRIM(cFilename)), UPPER(lcPath) )
		ENDIF
		IF FindNextFile(hFind, @cFindBuffer) = 0
			EXIT
		ENDIF
	ENDDO
	= FindClose(hFind)
ENDDEFINE
 
FUNCTION buf2dword(lcBuffer)
RETURN	ASC(SUBSTR(lcBuffer, 1,1)) + ASC(SUBSTR(lcBuffer, 2,1)) * 256 + ;
		ASC(SUBSTR(lcBuffer, 3,1)) * 65536 + ASC(SUBSTR(lcBuffer, 4,1)) * 16777216
 
PROCEDURE functionFiles
    DECLARE INTEGER FindClose IN kernel32 INTEGER hFindFile
 
    DECLARE INTEGER FindFirstFile IN kernel32;
        STRING lpFileName, STRING @lpFindFileData
 
    DECLARE INTEGER FindNextFile IN kernel32;
        INTEGER hFindFile, STRING @lpFindFileData
 
    DECLARE INTEGER FileTimeToSystemTime IN kernel32;
        STRING lpFileTime, STRING @lpSystemTime
 
    DECLARE INTEGER CompareFileTime IN kernel32;
        STRING lpFileTime1, STRING lpFileTime2