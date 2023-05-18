#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} IncAuto2
    Função de teste para rotina automática em fontes sem padrão MVC.
    @type  Function
    @author Edison Cake
    @since 05/05/2023
    /*/
User Function IncAuto2()
    Local aCabec    := {}
    Local aItens    := {}
    Local aLinha    := {}
    Local lOK       := .T.
    Local nOper     := 3
    local nI        := 0
    Private lMsErroAuto := .F.

    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'FAT'

    DbSelectArea('SB1')
    DbSetOrder(1)

    if !SB1->(MsSeek(xFilial('SB1') + 'C00001'))
        lOK := .F.
    endif

    //!-------------------------------------------------------------------------------------------------

    DbSelectArea('SF4')
    DbSetOrder(1)

    if !SF4->(MsSeek(xFilial('SF4') + '501'))
        lOK := .F.
    endif

    //!-------------------------------------------------------------------------------------------------

    DbSelectArea('SE4')
    DbSetOrder(1)

    if !SE4->(MsSeek(xFilial('SE4') + '01'))
        lOK := .F.
    endif

    //!-------------------------------------------------------------------------------------------------

    DbSelectArea('SA1')
    DbSetOrder(1)

    if !SA1->(MsSeek(xFilial('SA1') + '000001'))
        lOK := .F.
    endif
    
    if lOK

        aAdd(aCabec, {'C5_NUM',     '000101',       NIL}) 
        aAdd(aCabec, {'C5_TIPO',    'N',            NIL}) 
        aAdd(aCabec, {'C5_CLIENTE', SA1->A1_COD,    NIL}) 
        aAdd(aCabec, {'C5_LOJACLI', SA1->A1_LOJA,   NIL}) 
        aAdd(aCabec, {'C5_TIPINC',  '1',            NIL}) 
        aAdd(aCabec, {'C5_CONDPAG', SE4->E4_CODIGO, NIL}) 

        For nI := 1 to 3
            aLinha := {}

            aAdd(aLinha, {'C6_ITEM', StrZero(nI, 2), NIL})
            aAdd(aLinha, {'C6_PRODUTO', SB1->B1_COD, NIL})
            aAdd(aLinha, {'C6_QTDVEN', 10, NIL})
            aAdd(aLinha, {'C6_PRCVEN', 300, NIL})
            aAdd(aLinha, {'C6_PRUNIT', 300, NIL})
            aAdd(aLinha, {'C6_VALOR', 3000, NIL})
            aAdd(aLinha, {'C6_TES', SF4->F4_CODIGO, NIL})
            aAdd(aItens, aLinha)
        Next

        //? Chamando a função de rotina automática.
        MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, nOper)
    endif

    if lMsErroAuto
        MostraErro()
    endif

Return 
