#INCLUDE 'PROTHEUS.CH'

User Function ConfCad()
    local cPergunta := "Confirma o cadastro do produto?"
    local lRetorno := .F.

    if INCLUI
        cPergunta := "Confirma a inclusão do produto?"
    else
        cPergunta := "Confirma a alteração do produto?"
    endif
     
    lRetorno := MsgYesNo(cPergunta, "Tem certeza?")

Return lRetorno
