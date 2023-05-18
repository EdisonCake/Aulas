#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function InsBook()
    // Declaração de variáveis
    local aLocal    := {"001=PRATELEIRA 1", "002=PRATELEIRA 2", "003=PRATELEIRA 3", "004=PRATELEIRA 4", "005=PRATELEIRA 5", "006=PRATELEIRA TV", "007=MESA"}
    local aStatus   := {"1=Sim", "2=Não", "3=Em Andamento"}
    local cTitle    := "Cadastro de Livro"
    Private oJanela, oGrp
    Private oTitulo,        cTitulo := space(50) // Título
    Private oAutor,         cAutor := space(50) // Autor
    Private oEditora,       cEditora := space(30) // Editora
    Private oCombo,         cCombo := "" // Localizações
    Private oCombo2,        cCombo2 := "" // Lido ou Não
    Private cISBN := space(30)

    // Definição de tamanho da janela a ser criada.
    private nJanAlt  := 200
    private nJanLarg := 500

    // Iniciando a janela com os elementos
    DEFINE MSDIALOG oJanela TITLE cTitle FROM 000, 000 TO nJanAlt, nJanLarg PIXEL
    oJanela:SetCSS()

        @ 003, 003 GROUP oGrp TO (nJanAlt / 2) - 3 , (nJanLarg / 2) - 3 PROMPT "Cadastro de Livros: " OF oJanela PIXEL

        @ 015, 015 SAY "ISBN: "                     SIZE 060, 007 OF oJanela PIXEL
        @ 025, 015 MSGET cISBN                      SIZE 060, 008 OF oJanela PIXEL

        // Área de digitação das informações.
        @ 015, 080 SAY "Digite abaixo as informações:" SIZE 155, 008 OF oJanela PIXEL
        @ 025, 080 MSGET oTitulo VAR cTitulo        SIZE 155, 008 OF oJanela PIXEL
        oTitulo:cPlaceHold := "Título do livro"

        @ 040, 080 MSGET oAutor VAR cAutor          SIZE 155, 008 OF oJanela PIXEL
        oAutor:cPlaceHold := "Autor"

        @ 055, 080 MSGET oEditora VAR cEditora      SIZE 155, 008 OF oJanela PIXEL
        oEditora:cPlaceHold := "Editora"

        // ComboBox com as opções de cadastro de localização.
        oCombo := TComboBox():New(070, 015, {|u| if(PCount()>0, cCombo := u, cCombo)}, aLocal, 060, 010, oJanela,,,,,,.T.,,,,,,,,,'Localização')

        // ComboBox para informar se o livro foi lido ou não.
        @ 045, 015 SAY "Status de Leitura:" SIZE 060, 010 OF oJanela PIXEL
        oCombo2 := TComboBox():New(055, 015, {|u| if(PCount()>0, cCombo2 := u, cCombo2)}, aStatus, 060, 010, oJanela,,,,,,.T.,,,,,,,,,'Status')

        // Botão para realizar o cadastro do livro.
        @ 070, 080 BUTTON "Cadastrar"                SIZE 060, 010 OF oJanela PIXEL;
        ACTION ( CommitBook() )


    ACTIVATE MSDIALOG oJanela CENTERED

Return 

Static Function CommitBook()
    if ValISBN( alltrim(cISBN) )
        IncLivro()
    else
        MsgStop("ISBN Inválido!")
    endif

Return

Static Function ValISBN(cISBN)
    local cEntry := cISBN
    local aISBN := {}
    local aISBN2 := {}
    local nCount := 0
    local nValida := 0
    local nSoma := 0
    local lPrograma := .F.

    if !len(cISBN) == 13
        lPrograma := .F.
    else

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

        nValida := 0
        while (nSoma + nValida) % 10 != 0
            nValida++
        end do

        aAdd(aISBN, alltrim(str(nValida)))

        cISBN := ""
        For nCount := 1 to 13
            cISBN := cISBN + "" + alltrim(aISBN[nCount])
        Next nCount

    endif

    if cISBN == cEntry
        lPrograma := .T.
    endif

Return lPrograma

Static Function IncLivro()
    local aDados := {}

    private lMsErroAuto := .F.
    private aRotina     := {}
    private oModel      := NIL

    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    oModel := FwLoadModel('CADLIVM')

    aAdd(aDados, {'ZZL_FILIAL', FWxFilial('ZZL'), NIL})
    aAdd(aDados, {'ZZL_COD',    GETSXENUM("ZZL", "ZZL_COD"), NIL})
    aAdd(aDados, {'ZZL_ISBN',   cISBN, NIL})
    aAdd(aDados, {'ZZL_TITULO', cTitulo, NIL})
    aAdd(aDados, {'ZZL_AUTOR',  cAutor, NIL})
    aAdd(aDados, {'ZZL_EDITOR', cEditora, NIL})
    aAdd(aDados, {'ZZL_LIDO',   cCombo2, NIL})
    aAdd(aDados, {'ZZL_LOCAL',  cCombo, NIL})

    FwMVCRotAuto(oModel, 'ZZL', MODEL_OPERATION_INSERT, {{'ZZLMASTER', aDados}})

    if lMsErroAuto
        MostraErro()
    endif

Return
