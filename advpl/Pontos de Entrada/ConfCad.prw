#INCLUDE 'PROTHEUS.CH'

User Function ConfCad()
    local cPergunta := "Confirma o cadastro do produto?"
    local lRetorno := .F.

    if INCLUI
        cPergunta := "Confirma a inclus�o do produto?"
    else
        cPergunta := "Confirma a altera��o do produto?"
    endif
     
    lRetorno := MsgYesNo(cPergunta, "Tem certeza?")

Return lRetorno
