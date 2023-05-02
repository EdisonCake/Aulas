#INCLUDE 'TOTVS.CH'

User Function A010TOK()
    local aArea     := GetArea()
    local aAreaSB1  := SB1->(GetArea())
    local lRetorno  := .T.

   if ExistBlock('ConfCad')
        lRetorno := ExecBlock('ConfCad', .F., .F.)
   endif

    RestArea(aArea)
    RestArea(aAreaSB1)
Return lRetorno
