DECLARE @id 	char(10), 	
	@NOMBRE char(50),
	@RUTA 	VARchar(1024), 	
	@ORDEN 	VARchar(1024)

UPDATE HEROCA..ACC_CUENTAS SET RUTA = '', ORDEN = ''

DECLARE TMP_Acc_cuentas CURSOR
FOR SELECT ID, RUTA, ORDEN FROM grupoHeroca..acc_cuentas WITH(NOLOCK) 

OPEN TMP_Acc_cuentas
FETCH NEXT FROM TMP_Acc_cuentas INTO @ID, @RUTA, @ORDEN
WHILE @@FETCH_STATUS = 0
BEGIN
	print 'Actualizando : '+ @NOMBRE
	UPDATE heroca..Acc_cuentas SET ruta = @RUTA, ORDEN = @ORDEN WHERE ID = @ID 
	  	
	FETCH NEXT FROM TMP_Acc_cuentas INTO @ID, @RUTA, @ORDEN
END

CLOSE TMP_Acc_cuentas
DEALLOCATE TMP_Acc_cuentas

GO
