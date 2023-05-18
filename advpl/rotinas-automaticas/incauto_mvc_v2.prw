#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function IncMVC2
    Rotina automática para um cadastro de produto que funciona somente em telas no padrão MVC.
    @type  Function
    @author user
    @since 05/05/2023
    /*/
User Function IncMVC2()
    local oModel := NIL
    private lMsErroAuto := .F.

    //? Preparação do ambiente para fazer a inclusão de um produto sem a necessidade de abertura do Protheus.
    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    //? Carregamento do modelo com todas as suas propriedades.
    oModel := FwLoadModel('MATA010')

    //? Informando que a operação é de inserção de dados.
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()

    //? Atribuição das informações/dados aos campos referenciados.
    oModel:SetValue('SB1MASTER', 'B1_FILIAL'    , FwFilial('SB1'))
    oModel:SetValue('SB1MASTER', 'B1_COD'       , '002EA')
    oModel:SetValue('SB1MASTER', 'B1_DESC'      , 'POMADA')
    oModel:SetValue('SB1MASTER', 'B1_TIPO'      , 'PA')
    oModel:SetValue('SB1MASTER', 'B1_UM'        , 'UN')
    oModel:SetValue('SB1MASTER', 'B1_LOCPAD'    , '01')

    //? Feita a verificação das informações, é feito um "commit" das informações no banco de dados.
    IF oModel:VldData()
        oModel:CommitData()
        MsgInfo('Processo concluído, produto adicionado!', "Concluído")
    ELSE
        VarInfo('', oModel:GetErrorMessage())
    ENDIF

    oModel:DeActivate()
    oModel:Destroy()

    oModel := NIL

Return 
