#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'


/*/{Protheus.doc} User Function TREPORT
    Criação do relatório do tipo TReport.
    @type  Function
    @author Edison Cake
    @since 05/04/2023
    /*/
User Function TREPORT()
    // Atribuindo uma função de emissão do nosso relatório, atribuindo ao nosso objeto.
    local oReport := GeraReport()

    // Função para imprimir nosso relatório na tela.
    oReport:PrintDialog()
Return

// Função de emissão do relatório
Static Function GeraReport()
    local cAlias := GetNextAlias()
    local oRel
    local oSection 

    //? Criando o objeto do relatório (folha de papel)
    //! New(cReport, cTitle, uParam, bAction, cDescription, lLandscape, uTotalText, lTotalInLine, cPageTText, lPageTInLine, lTPageBreak, nColSpace)
    oRel := TReport():New("TREPORT", "Relatório de Clientes", /* uParam */, {|oRel| Imprime(oRel, cAlias)}, "Esse relatório imprimirá todos os cadastros de clientes.", .F., /* uTotalText */, /* lTotalInLine*/, /* cPageTText*/, /* lTotInLine */, /* lTPageBreak */, /* nColSpace */)

    //? Criando o objeto da seção (retângulos)
    //! New(oParent, cTitle, uTable, aOrder, lLoadCells, lLoadOrder, uTotalText, lTotalInLine, lHeaderPage, lHeaderBreak, lPageBreak, lLineBreak)
    oSection := TRSection():New(oRel, "Cadastros de Clientes")

    // Método para mudar a orientação da página.
    // oRel:SetLandscape() --> Altera a orientação de retrato para paisagem
    // oRel:SetPortrait() --> Altera a orientação de paisagem para retrato

    //? Criando uma coluna CODIGO
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_COD", "SA1", "CODIGO", /* cPicture */, 8, /* lPixel */, /* bBlock */, "CENTER", .T., "CENTER", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna nome
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_NOME", "SA1", "NOME", /* cPicture */, 30, /* lPixel */, /* bBlock */, "LEFT", .T., "LEFT", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

    //? Criando uma coluna endereço
    //! New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)
    TRCell():New(oSection, "A1_END", "SA1", "ENDEREÇO", /* cPicture */, 30, /* lPixel */, /* bBlock */, "LEFT", .T., "LEFT", /* lCellBreak */, /* nColSpace */, .T., /* Cor Funo */, /* Cor Front */, .T.)

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

// Função responsável pela impressão dos dados do relatório
Static Function Imprime(oRel, cAlias)
    local oSection := oRel:Section(1)
    local nTotReg  := 0
    local cQuery   := GeraQuery()

    // Função para chamar uma consulta SQL para obter os registros/dados
    DbUseArea(.T., 'TOPCONN', TcGenQRY(/* Compatibilidade */, /* Compatibilidade */, cQuery), cAlias, .T., .T.)
    
    // Atribuindo a quantidade de registros ao nosso contador total de registros.
    Count TO nTotReg

    // Definindo nossa régua/limite.
    oRel:SetMeter(nTotReg)

    // Definindo um título para o nosso relatório.
    oRel:SetTitle("Relatório de clientes")

    // Iniciando a página e começando a imprimir as informações nela.
    oRel:StartPage()

    // Iniciando a impressão das seções
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

        // Método responsável pela impressão da linha no relatório
        oSection:PrintLine()

        // Incrementando a régua do relatório
        oRel:IncMeter()


        (cAlias)->(DbSkip())
    End Do
    
    (cAlias)->(DbCloseArea())

    // Finalizando a impressão/seção
    oSection:Finish()

    // Finalizando o relatório
    oRel:EndPage()

Return

Static Function GeraQuery()
    local cQuery := ''

    cQuery := "SELECT A1_COD, A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP FROM "  + RetSqlName("SA1") + " SA1 WHERE D_E_L_E_T_ = ' '" 

Return cQuery
