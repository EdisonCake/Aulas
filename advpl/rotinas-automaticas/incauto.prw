#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} IncAuto1
    Função de teste para rotina automática em fontes sem padrão MVC.
    @type  Function
    @author Edison Cake
    @since 05/05/2023
    /*/
User Function IncAuto1()
    Local aDados := {}
    Local nOper  := 3
    Private lMsErroAuto := .F.

    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    //? Adicionando as informações nos campos especificos. {NOME_CAMPO, INFORMAÇÃO, PARAMETRO_NULO}
    aAdd(aDados, {'B1_FILIAL',  xFilial('SB1'),     NIL}) 
    aAdd(aDados, {'B1_COD',     '001ROTAUTO',       NIL}) 
    aAdd(aDados, {'B1_DESC',    'TESTE - EXECAUTO', NIL}) 
    aAdd(aDados, {'B1_TIPO',    'PA',               NIL}) 
    aAdd(aDados, {'B1_UM',      'UN',               NIL}) 
    aAdd(aDados, {'B1_LOCPAD',  '01',               NIL}) 

    //? Chamando a função de rotina automática.
    MsExecAuto({|x, y| MATA010(x, y)}, aDados, nOper)

    if lMsErroAuto
        MostraErro()
    endif

Return 
