#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function InsBook()
    // Declara��o de vari�veis
    local cTitle := "Cadastro de Livro"
    Private oJanela, oGrp
    Private oTitulo, cTitulo := space(50) // T�tulo
    Private oAutor,  cAutor := space(50) // Autor
    Private oEditora, cEditora := space(30) // Editora

    Private cProduto := space(30)

    // Defini��o de tamanho da janela a ser criada.
    private nJanAlt  := 200
    private nJanLarg := 500

    // Iniciando a janela com os elementos
    DEFINE MSDIALOG oJanela TITLE cTitle FROM 000, 000 TO nJanAlt, nJanLarg PIXEL
    oJanela:SetCSS()

        @ 003, 003 GROUP oGrp TO (nJanAlt / 2) - 3 , (nJanLarg / 2) - 3 PROMPT "Busca de Livros: " OF oJanela PIXEL

        @ 015, 015 SAY "C�digo do Produto: "            SIZE 060, 007 OF oJanela PIXEL
        @ 025, 015 MSGET cProduto                       SIZE 060, 008 OF oJanela PIXEL

        // Bot�o para realizar o cadastro do livro.
        @ 040, 015 BUTTON "Cadastrar"                   SIZE 060, 010 OF oJanela PIXEL;
        ACTION ( CommitBook() )

        // �rea de exibi��o dos resultados
        @ 025, 080 MSGET oTitulo VAR cTitulo            SIZE 155, 008 OF oJanela PIXEL
        oTitulo:setCSS("QLineEdit{font-weight: bold; font-family: Times, Times New Roman, Georgia, serif;}")

        @ 040, 080 MSGET oAutor VAR cAutor            SIZE 155, 008 OF oJanela PIXEL
        oAutor:setCSS("QLineEdit{font-family: calibri;}")

        @ 055, 080 MSGET oEditora VAR cEditora            SIZE 155, 008 OF oJanela PIXEL
        oEditora:setCSS("QLineEdit{font-family: calibri;}")

    ACTIVATE MSDIALOG oJanela CENTERED

Return 

Static Function CommitBook()

    MsgInfo("Funcionou")

Return
