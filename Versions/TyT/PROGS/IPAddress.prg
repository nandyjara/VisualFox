*!* Devuelve las direcciones IP
*!* Sintaxis: IPAddress()
*!* Valor devuelto: lcRetVal
*!* lcRetVal viene expresado como una cadena con el formato: 192.100.100.100, 192.100.100.101, ...
FUNCTION IPAddress
  LOCAL lnCnt, lpWSAData, lpWSHostEnt, lpHostName, lcRetVal, lpHostIp_Addr, ;
    lpHostEnt_Addr, lnHostEnt_Lenght, lnHostEnt_AddrList
  *!* Instrucciones DECLARE DLL para manipular Windows Sockets
  DECLARE INTEGER WSAGetLastError IN WSock32.DLL
  DECLARE INTEGER WSAStartup IN WSock32.DLL INTEGER wVersionRequested , STRING @lpWSAData
  DECLARE INTEGER WSACleanup IN WSock32.DLL
  DECLARE INTEGER gethostname IN WSock32.DLL STRING @lpHostName, INTEGER iHostNameLenght
  DECLARE INTEGER gethostbyname IN WSock32.DLL STRING lpHostName
  DECLARE RtlMoveMemory IN Win32API STRING @lpDest, INTEGER nSource, INTEGER nBytes
  *!* Valores
  lcRetVal           = ''
  lpHostName         = SPACE(256)
  lnHostEnt_Addr     = 0
  lnHostEnt_Lenght   = 0
  lnHostEnt_AddrList = 0
  lnHostIp_Addr      = 0
  lpTempIp_Addr      = CHR(0)
  lpHostIp_Addr      = REPLICATE(CHR(0), 4)
  lpWSHostEnt        = REPLICATE(CHR(0), 4 +4 +2 +2 +4)
  lpWSAData          = REPLICATE(CHR(0), 2 +2 + ;
    WSADESCRIPTION_LEN +1 +WSASYS_STATUS_LEN +1 +2 +2 +4)
  *!* Iniciar Windows Sockets
  IF WSAStartup(WS_VERSION_REQD, @lpWSAData) =  0
    *!* Valores
    lnVersion    = StrToInt(SUBSTR(lpWSAData, 1, 2))
    lnMaxSockets = StrToInt(SUBSTR(lpWSAData, 391, 2))
    *!* Determinar si Windows Sockets responde
    IF gethostname(@lpHostName, 256) <> SOCKET_ERROR
      *!* Valores
      lpHostName = ALLTRIM(lpHostName)
      lnHostEnt_Addr = gethostbyname(lpHostName)
      *!* Determinar si Windows Sockets no dio error
      IF lnHostEnt_Addr <> 0
        *!* Mover bloques de memoria
        RtlMoveMemory(@lpWSHostEnt, lnHostEnt_Addr, 16)
        *!* Valores
        lnHostEnt_AddrList = StrToLong(SUBSTR(lpWSHostEnt, 13, 4))
        lnHostEnt_Lenght   = StrToInt(SUBSTR(lpWSHostEnt, 11, 2))
        *!* Obtener todas las direcciones IP de la máquina
        DO WHILE .T.
          *!* Mover bloques de memoria
          RtlMoveMemory(@lpHostIp_Addr, lnHostEnt_AddrList, 4)
          *!* Valores
          lnHostIp_Addr = StrToLong(lpHostIp_Addr)
          *!* No hay o no quedan más direcciones validas
          IF lnHostIp_Addr = 0
            EXIT
          ELSE
            *!* Separar multiples IP`s con comas
            lcRetVal = lcRetVal + IIF(EMPTY(lcRetVal), '', ',')
          ENDIF
          lpTempIp_Addr = REPLICATE(CHR(0), lnHostEnt_Lenght)
          *!* Mover bloques de memoria
          RtlMoveMemory(@lpTempIp_Addr, lnHostIp_Addr, lnHostEnt_Lenght)
          *!* Componer cadena IP con puntos
          FOR lnCnt = 1 TO lnHostEnt_Lenght
            lcRetVal = lcRetVal + TRANSFORM(ASC(SUBSTR(lpTempIp_Addr, lnCnt, 1))) + ;
              IIF(lnCnt = lnHostEnt_Lenght, '', '.')
          ENDFOR
          *!* Continuar con la siguiente direccion
          lnHostEnt_AddrList = lnHostEnt_AddrList + 4
        ENDDO
      ENDIF
    ENDIF
  ENDIF
  *!* Parar Windows Sockets
  IF WSACleanup() <> 0
    lcRetVal = ''
  ENDIF
  *!* Retorno
  RETURN lcRetVal
ENDFUNC
