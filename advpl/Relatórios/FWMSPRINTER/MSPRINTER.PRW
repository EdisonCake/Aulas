#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RPTDEF.CH'
#INCLUDE 'FWPRINTSETUP.CH'

#DEFINE PRETO       RGB(000,000,000)
#DEFINE VERMELHO    RGB(255,000,000)

#DEFINE LINHA_INIT  105
#DEFINE MAX_LINE    770


/*/{Protheus.doc} User Function MSPRINTER
    Fun��o de usu�rio para a impress�o de relat�rio com a classe FwMsPrinter().
    @type  Function
    @author Edison Cake
    @since 13/04/2023
    /*/
User Function MSPRINTER()
    //! Aqui ser� criada um aconsulta no SQL para definir quais os dados ser�o retornados.
    local cAlias := GeraCons()

    if !Empty(cAlias)

        //! Fun��o Processa() cria uma barra de carregamento/processamento para exibi��o do relat�rio.
        //! Fun��o MontaRel() far� a montagem do relat�rio.
        Processa({|| MontaRel(cAlias)}, "Aguarde...", "Imprimindo relat�rio...", .F.)
    else

        //! Caso n�o haja retorno no GeraCons(), ser� informado ao usu�rio.
        FwAlertError("Nenhum registro encontrado.", "Aten��o!")
    endif


Return 

Static Function GeraCons()
    local aArea     := GetArea()
    local cAlias    := GetNextAlias()
    local cQuery := ""

    //! Aqui � criada a consulta no SQL para definir os dados a serem exibidos.
    cQuery := "SELECT A1_COD, A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_MSBLQL FROM " + RetSqlName("SA1") + " WHERE D_E_L_E_T_ = ' '"
    TCQUERY cQuery ALIAS (cAlias) NEW

    (cAlias)->(DbGoTop())

    if (cAlias)->(Eof())
        cAlias := ""
    endif

    RestArea(aArea)
Return cAlias

Static Function MontaRel(cAlias)
    //! Definindo o caminho a ser salvo o arquivo, e o nome do mesmo.
    local cCaminho := "C:\Users\ediso\Desktop\"
    local cArquivo := "CadCli.pdf"

    Private nLinha  := LINHA_INIT
    Private oPrint

    //! TFont():New(<cNomeFont>, /*Compat.*/, <nFontSize>, /*Compat.*/, <lBold>, /*Compat.*/, /*Compat.*/, /*Compat.*/, /*Compat.*/, <lUnderline>, <lItalic>)
    Private oFont10 := TFont():New("Fira Code", /* Compatibilidade */, 10, /* Compatibilidade */, .F., /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, .F., .F. )
    Private oFont12 := TFont():New("Fira Code", /* Compatibilidade */, 12, /* Compatibilidade */, .T., /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, .F., .F. )
    Private oFont14 := TFont():New("Fira Code", /* Compatibilidade */, 14, /* Compatibilidade */, .T., /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, .F., .F. )
    Private oFont16 := TFont():New("Fira Code", /* Compatibilidade */, 16, /* Compatibilidade */, .T., /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, /* Compatibilidade */, .T., .F. )

    //! Instanciando a classe de impress�o.
    //! FWMsPrinter():New(<cFilePrinter>, [nDevice], [lAdjustToLegacy], [cPathInServer], [lDisabeSetup], [lTReport], [@oPrintSetup], [cPrinter], [lServer], [lPDFAsPNG], [lRaw], [lViewPDF], [nQtdCopy])
    oPrint := FwMsPrinter():New(cArquivo, IMP_PDF, .F., "", .T., /* TR */, @oPrint, "", /* lServ */, /* Compatibilidade */, /* RAW */, .T.)
    
    //! Definindo aonde ser� salvo o arquivo.
    oPrint:cPathPDF := cCaminho

    //! M�todo para definir a orienta��o da impress�o para retrato.
    oPrint:SetPortrait()

    //! M�todo para definir a orienta��o da impress�o para paisagem (se necess�rio)
    // oPrint:SetLandscape()

    //! M�todo para definir o tamnho do papel para A4.
    oPrint:SetPaperSize(9)

    //! Iniciando a p�gina para a impress�o das informa��es.
    oPrint:StartPage()

    // Fun��es (personalizadas ou de usu�rio) para criar cabe�alho e impressao de dados.
    Cabecalho() 
    ImpDados(cAlias)

    //! Finalizando o documento e enviando para a impress�o.
    oPrint:EndPage()
    oPrint:Preview()
Return

Static Function Cabecalho()
    //! Criando uma caixa
    oPrint:Box(15, 15, 85, 580, '-8')

    //! Criando uma linha separando a caixa
    oprint:Line(50, 15, 50, 580, /* COR */, '-6')

    //! Iniciando a impress�o das informa��es do cabe�alho.
    oPrint:Say(35, 020, "Empresa / Filial: " + Alltrim(SM0->M0_NOME) + " / " + alltrim(SM0->M0_FILIAL), oFont14, /* nLargura */, /* nColorText */)
    oPrint:Say(70, 220, "Cadastros de Clientes", oFont16, /* nLargura */, /* nColorText */)

    //! Iniciando a impress�o do cabe�alho das colunas.
    oPrint:Say(nLinha, 020, "C�DIGO"     , oFont12,, PRETO)
    oPrint:Say(nLinha, 080, "NOME"       , oFont12,, PRETO)
    oPrint:Say(nLinha, 200, "ENDERECO"   , oFont12,, PRETO)
    oPrint:Say(nLinha, 320, "BAIRRO"     , oFont12,, PRETO)
    oPrint:Say(nLinha, 400, "CIDADE"     , oFont12,, PRETO)
    oPrint:Say(nLinha, 485, "ESTADO"     , oFont12,, PRETO)
    oPrint:Say(nLinha, 545, "CEP"        , oFont12,, PRETO)

    nLinha += 5

    //! Imprimindo uma linha de separa��o entre o cabe�alho das colunas e conte�do a ser apresentado.
    oPrint:Line(nLinha, 15, nLinha, 580,, '-6')

    nLinha += 20
Return

Static Function ImpDados(cAlias)
    local cString   := ""
    private nCor      := 0

    DbSelectArea(cAlias)
    (cAlias)->(DbGoTop())

    While (cAlias)->(!Eof())
        VeriQuebPag(MAX_LINE)

        if alltrim((cAlias)->(A1_MSBLQL)) == "1"
            nCor := VERMELHO
        else
            nCor := PRETO
        endif

        oPrint:Say(nLinha, 020, ALLTRIM((cAlias)->(A1_COD)), oFont10,,nCor)

        //! Fun��o personalizada para verificar se haver� quebra de linha com o nome.
        cString := alltrim((cAlias)->(A1_NOME))
        VeriQuebLn(cString, 20, 80)

        //! Fun��o personalizada para verificar se haver� quebra de linha com o endere�o.
        cString := alltrim((cAlias)->(A1_END))
        VeriQuebLn(cString, 25, 200)
        
        //! Fun��o personalizada para verificar se haver� quebra de linha com o bairro.
        cString := alltrim((cAlias)->(A1_BAIRRO))
        VeriQuebLn(cString, 20, 320)

        //! Fun��o personalizada para verificar se haver� quebra de linha com a cidade.
        cString := alltrim((cAlias)->(A1_MUN))
        VeriQuebLn(cString, 20, 400)

        oPrint:Say(nLinha, 485, ALLTRIM((cAlias)->(A1_EST)), oFont10,,nCor)
        oPrint:Say(nLinha, 545, ALLTRIM((cAlias)->(A1_CEP)), oFont10,,nCor)
        
        nLinha += 30
        IncProc()

        

        (cAlias)->(DbSkip())
    End do

Return

Static Function VeriQuebLn(cString, nQtdCar, nCol)
    local cTxtLinha     := ""
    local lTemQuebra    := .F.
    local nQtdLinhas    := MLCount(cString, nQtdCar, /* Tabula��o */, .F.)
    local nI            := 0

    if nQtdLinhas > 1
        lTemQuebra := .T.
        for nI := 1 to nQtdLinhas
            cTxtLinha := MemoLine(cString, nQtdCar, nI)

            oPrint:Say(nLinha, nCol, cTxtLinha, oFont10,,nCor)
            nLinha += 10
        next
    else
        oPrint:Say(nLinha, nCol, cString, oFont10,,nCor)
    endif

    if lTemQuebra
        nLinha -= (nQtdLinhas * 10)
    endif

Return

Static Function VeriQuebPag(nMax)`

    if nLinha > nMax
        oPrint:EndPage()
        oPrint:StartPage()

        nLinha := LINHA_INIT
        Cabecalho()
    endif

Return
