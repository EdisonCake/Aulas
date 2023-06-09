#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'


/*/{Protheus.doc} User Function TREPORT
    Cria��o do relat�rio do tipo TReport.
    @type  Function
    @author Edison Cake
    @since 05/04/2023
    /*/
User Function TREPORT()
    // Atribuindo uma fun��o de emiss�o do nosso relat�rio, atribuindo ao nosso objeto.
    local oReport := GeraReport()

    // Fun��o para imprimir nosso relat�rio na tela.
    oReport:PrintDialog()
Return

// Fun��o de emiss�o do relat�rio
Static Function GeraReport()
    local cAlias := GetNextAlias()
    local oRel
    local oSection 

    //? Criando o objeto do relat�rio (folha de papel)
    //! New(cReport, cTitle, uParam, bAction, cDescription, lLandscape, uTotalText, lTotalInLine, cPageTText, lPageTInLine, lTPageBreak, nColSpace)
    oRel := TReport():New("TREPORT", "Relat�rio de Clientes", /* uParam */, {|oRel| Imprime(oRel, cAlias)}, "Esse relat�rio imprimir� todos os cadastros de clientes.", .F., /* uTotalText */, /* lTotalInLine*/, /* cPageTText*/, /* lTotInLine */, /* lTPageBreak */, /* nColSpace */)

    //? Criando o objeto da se��o (ret�ngulos)
    //! New(oParent, cTitle, uTable, aOrder, lLoadCells, lLoadOrder, uTotalText, lTotalInLine, lHeaderPage, lHeaderBreak, lPageBreak, lLineBreak)
    oSection := TRSection():New(oRel, "Cadastros de Clientes")

    // M�todo para mudar a orienta��o da p�gina.
    // oRel:SetLandscape() --> Altera a orienta��o de retrato para paisagem
    // oRel:SetPortrait() --> Altera a orienta��o de paisagem para retrato

    //? Criando uma coluna CODIGO
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_COD", "SA1", "CODIGO", /* cPicture */, 8, /* lPixel */, /* bBlock */, "CENTER", .T., "CENTER", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna nome
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_NOME", "SA1", "NOME", /* cPicture */, 30, /* lPixel */, /* bBlock */, "LEFT", .T., "LEFT", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna endere�o
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_END", "SA1", "ENDERE�O", /* cPicture */, 30, /* lPixel */, /* bBlock */, "LEFT", .T., "LEFT", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna bairro
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_BAIRRO", "SA1", "BAIRRO", /* cPicture */, 20, /* lPixel */, /* bBlock */, "LEFT", .T., "LEFT", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna cidade
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_MUN", "SA1", "CIDADE", /* cPicture */, 20, /* lPixel */, /* bBlock */, "LEFT", .T., "LEFT", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna UF
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_EST", "SA1", "UF", /* cPicture */, 4, /* lPixel */, /* bBlock */, "CENTER", .T., "CENTER", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna CEP
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_CEP", "SA1", "CEP", "@E 99.999-999", 12, /* lPixel */, /* bBlock */, "CENTER", .T., "CENTER", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)
Return oRel

// Fun��o respons�vel pela impress�o dos dados do relat�rio
Static Function Imprime(oRel, cAlias)
    local oSection := oRel:Section(1)
    local nTotReg  := 0
    local cQuery   := GeraQuery()

    // Fun��o para chamar uma consulta SQL para obter os registros/dados
    DbUseArea(.T., 'TOPCONN', TcGenQRY(/* Compatibilidade */, /* Compatibilidade */, cQuery), cAlias, .T., .T.)
    
    // Atribuindo a quantidade de registros ao nosso contador total de registros.
    Count TO nTotReg

    // Definindo nossa r�gua/limite.
    oRel:SetMeter(nTotReg)

    // Definindo um t�tulo para o nosso relat�rio.
    oRel:SetTitle("Relat�rio de clientes")

    // Iniciando a p�gina e come�ando a imprimir as informa��es nela.
    oRel:StartPage()

    // Iniciando a impress�o das se��es
    oSection:Init()

    (cAlias)->(DbGoTop())

    While(cAlias)->(!EoF())
        if oRel:Cancel()
            Exit
        endif

        oSection:Cell("A1_COD"):SetValue((cAlias)->(A1_COD))
        oSection:Cell("A1_NOME"):SetValue((cAlias)->(A1_NOME))
        oSection:Cell("A1_END"):SetValue((cAlias)->(A1_END))
        oSection:Cell("A1_BAIRRO"):SetValue((cAlias)->(A1_BAIRRO))
        oSection:Cell("A1_MUN"):SetValue((cAlias)->(A1_MUN))
        oSection:Cell("A1_EST"):SetValue((cAlias)->(A1_EST))
        oSection:Cell("A1_CEP"):SetValue((cAlias)->(A1_CEP))

        // M�todo respons�vel pela impress�o da linha no relat�rio
        oSection:PrintLine()

        // Incrementando a r�gua do relat�rio
        oRel:IncMeter()


        (cAlias)->(DbSkip())
    End Do
    
    (cAlias)->(DbCloseArea())

    // Finalizando a impress�o/se��o
    oSection:Finish()

    // Finalizando o relat�rio
    oRel:EndPage()

Return

Static Function GeraQuery()
    local cQuery := ''

    cQuery := "SELECT A1_COD, A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP FROM "  + RetSqlName("SA1") + " SA1 WHERE D_E_L_E_T_ = ' '" 

Return cQuery
