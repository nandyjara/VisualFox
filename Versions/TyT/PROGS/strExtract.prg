FUNCTION STREXTRACT
PARAMETER tcSearchExpression, tcBeginDelim, tcEndDelim, tnOccurrence

LOCAL lnPos1, lnPos2, lnLen, lnOccurrence, lcStrExtract

lnOccurrence = IIF( EMPTY( tnOccurrence ), 1, tnOccurrence )
IF EMPTY(tcBeginDelim)
  lnPos1 = 1
ELSE
  lnPos1 = AT( tcBeginDelim, tcSearchExpression, lnOccurrence ) + LEN( tcBeginDelim )
ENDIF
lnLen  = AT( tcEndDelim, substr( tcSearchExpression, lnPos1 ), 1 ) -1
lcStrExtract = SUBSTR( tcSearchExpression, lnPos1, lnLen )

RETURN ALLTRIM(UPPER(lcStrExtract))