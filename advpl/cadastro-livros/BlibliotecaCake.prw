#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

// Função para legenda.
User Function LegZZL(param_name)
    local cQualquer := "Legenda"
    local aCor      := {}

    aAdd(aCor, {"VERDE", "Lido"})
    aAdd(aCor, {"VERMELHO", "Não Lido"})
    aAdd(aCor, {"AMARELO", "Leitura em Andamento"})

    brwlegenda(cCadastro, cQualquer, aCor)
Return aCor

// Função para validação de ISBN do livro cadastrado.
User Function ValISBN()
    local cISBN := ""
    local aISBN := {}
    local aISBN2 := {}
    local nCount := 0
    local nValida := 0
    local nSoma := 0
    local lPrograma := .F.

    cISBN := alltrim(M->ZZL_ISBN)

    For nCount := 1 to 12
        aAdd(aISBN, substr(cISBN, nCount, 1))
    Next nCount

    aAdd(aISBN2, val(aISBN[1]) * 1)
    aAdd(aISBN2, val(aISBN[2]) * 3)
    aAdd(aISBN2, val(aISBN[3]) * 1)
    aAdd(aISBN2, val(aISBN[4]) * 3)
    aAdd(aISBN2, val(aISBN[5]) * 1)
    aAdd(aISBN2, val(aISBN[6]) * 3)
    aAdd(aISBN2, val(aISBN[7]) * 1)
    aAdd(aISBN2, val(aISBN[8]) * 3)
    aAdd(aISBN2, val(aISBN[9]) * 1)
    aAdd(aISBN2, val(aISBN[10]) * 3)
    aAdd(aISBN2, val(aISBN[11]) * 1)
    aAdd(aISBN2, val(aISBN[12]) * 3)

    For nCount := 1 to len(aISBN2)
        nSoma += aISBN2[nCount]
    Next nCount

    nValida := 1
    while (nSoma + nValida) % 10 != 0
        nValida++
    end do

    aAdd(aISBN, alltrim(str(nValida)))

    cISBN := ""
    For nCount := 1 to 13
        cISBN := cISBN + "" + alltrim(aISBN[nCount])
    Next nCount

    if cISBN == alltrim(M->ZZL_ISBN)
        lPrograma := .T.
    else
        MsgStop("ISBN inválido!!")
    endif

Return lPrograma

User Function PesqCod()
    // Declaração de variáveis
    local cTitle := "Pesquisa de Livro"
    Private oJanela, oGrp
    Private oExibe1, cExibe1 := "" // Título
    Private oExibe2, cExibe2 := "" // Autor
    Private oExibe3, cExibe3 := "" // Editora
    Private oExibe4, cExibe4 := "" // Localização
    Private cProduto := space(30)

    // Definição de tamanho da janela a ser criada.
    private nJanAlt  := 200
    private nJanLarg := 500

    // Iniciando a janela com os elementos
    DEFINE MSDIALOG oJanela TITLE cTitle FROM 000, 000 TO nJanAlt, nJanLarg PIXEL
    oJanela:SetCSS()

        // Grupo para a busca dos produtos
        @ 003, 003 GROUP oGrp TO (nJanAlt / 2) - 3 , (nJanLarg / 2) - 3 PROMPT "Busca de Livros: " OF oJanela PIXEL

        @ 015, 015 SAY "Código do Produto: "            SIZE 060, 007 OF oJanela PIXEL
        @ 025, 015 MSGET cProduto                       SIZE 060, 008 OF oJanela F3 "ZZL" PIXEL

        // Botão para realizar a busca no banco de dados.
        @ 040, 015 BUTTON "Pesquisar"                   SIZE 060, 010 OF oJanela PIXEL;
        ACTION ( LivInfo() )

        // Área de exibição dos resultados
        @ 025, 080 MSGET oExibe1 VAR cExibe1            SIZE 155, 008 OF oJanela PIXEL
        oExibe1:lActive := .F.
        oExibe1:setCSS("QLineEdit{font-weight: bold; font-family: Times, Times New Roman, Georgia, serif;}")

        @ 040, 080 MSGET oExibe2 VAR cExibe2            SIZE 155, 008 OF oJanela PIXEL
        oExibe2:lActive := .F.
        oExibe2:setCSS("QLineEdit{font-family: calibri;}")

        @ 055, 080 MSGET oExibe3 VAR cExibe3            SIZE 155, 008 OF oJanela PIXEL
        oExibe3:lActive := .F.
        oExibe3:setCSS("QLineEdit{font-family: calibri;}")

        @ 070, 080 MSGET oExibe4 VAR cExibe4            SIZE 155, 008 OF oJanela PIXEL
        oExibe4:lActive := .F.
        oExibe4:setCSS("QLineEdit{font-family: calibri;}")

    ACTIVATE MSDIALOG oJanela CENTERED

Return 

/*/{Protheus.doc} LivInfo
    Função estática para a pesquisa das informações solicitadas para a exibição.
    @type  Function
    @author Edison Cake
    @since 21/03/2023
    /*/
Static Function LivInfo()
    
    local aArea  := GetArea()
    local cAlias := GetNextAlias()
    local cQuery := ""

    cQuery := "SELECT * FROM " + RetSqlName("ZZL") + " WHERE ZZL_COD = '" + alltrim(ZZL->ZZL_COD) + "'"
    TCQUERY cQuery ALIAS &(cAlias) NEW

    cExibe1 := "Título: " + ZZL->ZZL_TITULO
    oExibe1:Refresh()
    
    cExibe2 := "Autor: " + ZZL->ZZL_AUTOR
    oExibe2:Refresh()

    cExibe3 := "Editora: " + ZZL->ZZL_EDITOR
    oExibe3:Refresh()
    
    cExibe4 := "Localização: " + ZZL->ZZL_LOCAL
    oExibe4:Refresh()

    &(cAlias)->(DbCloseArea())
    RestArea(aArea)

Return
