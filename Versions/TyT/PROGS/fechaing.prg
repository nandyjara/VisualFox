*      Solo en forma britanica Y americana.
*       CadFecha(Date(),1) ---> "12 August, 1995"
*       CadFecha(Date(),2) ---> "August 12th, 1995"

LPARAMETER MiFecha, TipoFecha
*FUNCTION CadFechaING(MiFecha,TipoFecha)
Local RespFecha,MiDia,MiMesN,MiMesC,MiMesL,MiAño,MiDia2
If !BETWEEN(TipoFecha,1,2)
 Retu "Tipo incorrecto"
EndIf
MiDia2 = getwordnum("SUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY",Dow(MiFecha),",")
MiDia1 = getwordnum("ST,ND,RD,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,TH,ST,ND,RD,TH,TH,TH,TH,TH,TH,TH,ST",Day(MiFecha),',')
MiDia  = PadL(Day(MiFecha),2,"0")
MiMesN = Allt(Str(Month(MiFecha)))
MiMesL = getwordnum("JANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER",Val(MiMesN),",")
MiMesC = LEFT(MiMesL,3)
MiAñoN = Allt(Str(Year(MiFecha)))
RespFecha =  getwordnum(MiDia  + " " + MiMesL + ", " + MiAñoN + "-"  + ;
      MiMesL + " " + MiDia  + " "  + MiDia1 + ", " + MiAñoN + "-" ;
      ,TipoFecha,"-")
RETURN (RespFecha)