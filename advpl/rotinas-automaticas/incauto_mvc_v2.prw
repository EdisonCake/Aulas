#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function IncMVC2
    Rotina autom�tica para um cadastro de produto que funciona somente em telas no padr�o MVC.
    @type  Function
    @author user
    @since 05/05/2023
    /*/
User Function IncMVC2()
    local oModel := NIL
    private lMsErroAuto := .F.

    //? Prepara��o do ambiente para fazer a inclus�o de um produto sem a necessidade de abertura do Protheus.
    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    //? Carregamento do modelo com todas as suas propriedades.
    oModel := FwLoadModel('MATA010')

    //? Informando que a opera��o � de inser��o de dados.
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()

    //? Atribui��o das informa��es/dados aos campos referenciados.
    oModel:SetValue('SB1MASTER', 'B1_FILIAL'    , FwFilial('SB1'))
    oModel:SetValue('SB1MASTER', 'B1_COD'       , '002EA')
    oModel:SetValue('SB1MASTER', 'B1_DESC'      , 'POMADA')
    oModel:SetValue('SB1MASTER', 'B1_TIPO'      , 'PA')
    oModel:SetValue('SB1MASTER', 'B1_UM'        , 'UN')
    oModel:SetValue('SB1MASTER', 'B1_LOCPAD'    , '01')

    //? Feita a verifica��o das informa��es, � feito um "commit" das informa��es no banco de dados.
    IF oModel:VldData()
        oModel:CommitData()
        MsgInfo('Processo conclu�do, produto adicionado!', "Conclu�do")
    ELSE
        VarInfo('', oModel:GetErrorMessage())
    ENDIF

    oModel:DeActivate()
    oModel:Destroy()

    oModel := NIL

Return 
