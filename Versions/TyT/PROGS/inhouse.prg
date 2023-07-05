
CLEAR ALL
ON SHUTDOWN ShutDown()
ON ERROR DO FatalError WITH ERROR(), PROGRAM(), LINENO() IN MAIN.PRG

*-- Archivo de Inclusión general
#INCLUDE DOBRA.H

*-- Librerias Externas
SET LIBRARY TO FOXTOOLS
*#IF DEBUG_MODE = 0
*	SET PROCEDURE TO APP 
*#ELSE
*	SET PROCEDURE TO APP_DEBUG
*#ENDIF

*-- Archivos no Implícitos
EXTERNAL PROCEDURE Fecha, Pivot
EXTERNAL FILE MAIL.CUR
EXTERNAL FORM SEG_HOME_PASSWORDI, SIS_HEADER_TOOLBAR, ORG_HOME_ORGANIZER, SIS_STATUS_ESTADO, SIS_HOME_INICIO, SIS_HOME_INICIOI

_VFP.AutoYield = .F.

*-- Crear objeto _DOBRA descendiente del FRAMEWORK privado de Aplicaciones de CODETEK S. A.
SET CLASSLIB TO APP
SET CLASSLIB TO CONTROLS ADDITIVE
SET CLASSLIB TO FORMS ADDITIVE
_DOBRA = CREATEOBJECT("Dobra70_App")

IF TYPE("_DOBRA") = "O"  && Validar si se creó el objeto _DOBRA
	_DOBRA.PasswordWindow 	= [SEG_HOME_PASSWORDI]
	_DOBRA.DesktopWindow	= [SIS_DESKTOP_DESKTOP]
	_DOBRA.HeaderWindow		= [SIS_HEADER_TOOLBAR]
	_DOBRA.StatusWindow		= [SIS_STATUS_ESTADO]
	_DOBRA.HomeWindow 		= [SIS_HOME_INICIO]
	*_DOBRA.MenuWindow 		= [SIS_GENERIC_MENU]
	_DOBRA.ApplicationIcon	= [APPICON.ICO]
	_DOBRA.Run()
ENDIF

*-- CleanUp 
ON ERROR
ON SHUTDOWN
CLEAR ALL
SET PROCEDURE TO
SET LIBRARY TO
#IF DEBUG_MODE = 0
	CLOSE ALL
#ENDIF
RETURN

*-- Controlar Salida de Dobra
FUNCTION ShutDown
	IF MESSAGEBOX('Esta operación cerrará la sesión de Dobra, está seguro de salir...', MB_ICONQUESTION + MB_YESNO, _SCREEN.Caption ) = IDYES
		CLEAR EVENTS
		#IF DEBUG_MODE = 0
			_SCREEN.Hide()
			CLOSE ALL
		#ENDIF
	ENDIF
	RETURN
	
*-- Controlar errores Fatales	
FUNCTION FatalError
LPARAMETER nError, cMethod, nLine 
	LOCAL lcErrorMsg, lcCodeLineMsg
	lcErrorMsg = "Ha ocurrido un error no previsto por el programador." + CHR(13) + ;
		"Por favor, copie la información que aparecerá a continuación y " + ;
		"contáctese a los teléfonos de Asistencia Técnica para la revisión " + ;
		"del producto." + CHR(13) + CHR(13) + MESSAGE() + CHR(13) + CHR(13)
	lcErrorMsg    = lcErrorMsg + "Método: " + cMethod
	lcCodeLineMsg = MESSAGE(1)
	IF BETWEEN( nLine, 1, 10000 ) AND NOT lcCodeLineMsg = "..."
		lcErrorMsg = lcErrorMsg + CHR(13) + "Línea: " + ALLTRIM(STR( nLine ))
		IF NOT EMPTY( lcCodeLineMsg )
			lcErrorMsg = lcErrorMsg + CHR(13) + CHR(13) + lcCodeLineMsg
		ENDIF
	ENDIF
	MESSAGEBOX( lcErrorMsg , MB_ICONSTOP, "Dobra Empresarial 7 - Error Fatal" )
	IF TYPE("_DOBRA") = "O"  && Guardar el error si existe el objeto _DOBRA 
		_DOBRA.WriteErrorFile( nError, PROGRAM(), cMethod, nLine, MESSAGE(), MESSAGE(1))
		CLEAR EVENTS
	ENDIF
	#IF DEBUG_MODE = 0
		CLOSE ALL
	#ENDIF
	RETURN TO MASTER
	
	