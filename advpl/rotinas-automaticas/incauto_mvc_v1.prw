#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} IncAutMVC
    Rotina automática para cadastro de produto em tela/modelo MVC.
    @type  Function
    @author Edison Cake
    @since 05/05/2023
    /*/
User Function IncAutMVC()
    local aDados := {}

    private lMsErroAuto := .F.
    private aRotina     := {}
    private oModel      := NIL

    //? Preparando o ambiente para executar a rotina sem a necessidade de abrir o Protheus.
    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    //? Carregando o modelo da MATA010 para nossa variável.
    oModel := FwLoadModel('MATA010')

    //? Adicionando as informações em um array para fazer a transmissão/inclusão.
    aAdd(aDados, {'B1_FILIAL',  FwFilial('SB1'),    NIL})
    aAdd(aDados, {'B1_COD',     '001RATST',         NIL})
    aAdd(aDados, {'B1_DESC',    'PRODUTO AUTOMATICO', NIL})
    aAdd(aDados, {'B1_TIPO',    'MP',               NIL})
    aAdd(aDados, {'B1_UM',      'KG',               NIL})
    aAdd(aDados, {'B1_LOCPAD',  '01',               NIL})

    //? Função para a rotina automática.
    FwMVCRotAuto(oModel, 'SB1', MODEL_OPERATION_INSERT, {{'SB1MASTER', aDados}})

    if lMsErroAuto
        MostraErro()
    endif

Return 
