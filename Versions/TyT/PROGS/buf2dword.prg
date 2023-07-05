PARAMETERS lcBuffer
RETURN	ASC(SUBSTR(lcBuffer, 1,1)) + ASC(SUBSTR(lcBuffer, 2,1)) * 256 + ;
		ASC(SUBSTR(lcBuffer, 3,1)) * 65536 + ASC(SUBSTR(lcBuffer, 4,1)) * 16777216