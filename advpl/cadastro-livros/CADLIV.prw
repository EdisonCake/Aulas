#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} CADLIV
    Treinamento/Estudo para criação de telas em MVC com cadastro de livros.
    @type  Function
    @author Edison Cake
    @since 21/03/2023
    /*/
User Function CADLIV()
    local cAlias := 'ZZL'
    local cTitle := 'Cadastro de Livros'
    local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cAlias)
    oBrowse:SetDescription(cTitle)

    oBrowse:DisableDetails()
    oBrowse:DisableReport() 

    oBrowse:AddLegend('alltrim(ZZL_LIDO) == "1"', 'GREEN',  'Livro lido.')
    oBrowse:AddLegend('alltrim(ZZL_LIDO) == "2"', 'RED',    'Livro não lido.')
    oBrowse:AddLegend('alltrim(ZZL_LIDO) == "3"', 'YELLOW', 'Leitura em andamento.')

    oBrowse:AddButton('Informações dos Livros', {|| Livros()})
    oBrowse:AddButton('Pesquisa de ISBN',       {|| u_PesqCod()})

    oBrowse:Activate()
Return 

Static Function MenuDef()
    local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION 'VIEWDEF.CADLIV' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION 'VIEWDEF.CADLIV' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION 'VIEWDEF.CADLIV' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"      ACTION 'VIEWDEF.CADLIV' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
    local oModel    := MPFormModel():New("CADLIVM")
    local oStruZZL  := FWFormStruct(1, "ZZL")

    oModel:AddFields("ZZLMASTER",,oStruZZL)
    oModel:SetDescription("Cadastro de Livros")

    oModel:SetPrimaryKey({"ZZL_FILIAL", "ZZL_COD"})

Return oModel

Static Function ViewDef()
    local oModel    := FwLoadModel('CADLIV')
    local oStruZZL  := FwFormStruct(2, "ZZL")
    local oView     := FwFormView():New()

    oView:SetModel(oModel)
    oView:AddField("VIEW_ZZL", oStruZZL, "ZZLMASTER")
    oView:CreateHorizontalBox("LIVROS", 100)
    oView:SetOwnerView("VIEW_ZZL", "LIVROS")
    oView:EnableTitleView("VIEW_ZZL", "Cadastro de Livros")

Return oView

/*/{Protheus.doc} Livros
    Função para a criação de um relatório em PDF utilizando a classe PSAY
    @type  Function
    @author Edison Cake
    @since 21/03/2023
    /*/
Static Function Livros()
    private cTitle := "Livros"

    private cAlias      := "ZZL"
    private cProgram    := "CADLIV" 
    private cDesc1      := "Cadastro de Livros"
    private cDesc2      := ""
    private cDesc3      := ""
    private cSize       := "M"
    private m_pag       := 1

    private cCabec1     := "  ISBN:               DESCRIÇÃO:                                        AUTOR:"
    private cCabec2     := ""

    private aReturn     := {"Zebrado", 1, "Administração", 1, 2, "", "", 1}
    private cNomeRel    := SetPrint(cAlias, cProgram, "", @cTitle, cDesc1, cDesc2, cDesc3, .F.,, .T., cSize,, .F.)

    SetDefault(aReturn, cAlias)
    RptStatus({|| ImpLiv()}, cTitle, "Catalogando... Por favor, aguarde!")
Return

Static Function ImpLiv()
    local nLinha    := 8

    DbSelectArea("ZZL")
    ZZL->(DbSetOrder(1))
    ZZL->(DBGOTOP())

    Cabec(cTitle, cCabec1, cCabec2, cProgram, cSize)

    While !EOF()
        @ nLinha, 2     PSAY    PADR(ZZL->ZZL_ISBN, 20)
        @ nLinha, 22    PSAY    PADR(ZZL->ZZL_TITULO, 50)
        @ nLinha, 72    PSAY    PADR(ZZL->ZZL_AUTOR, 20)

        nLinha++
        ZZL->(DBSKIP())
    End Do

    SET DEVICE TO SCREEN

    if aReturn[5] == 1
        SET PRINTER TO DbCommitAll()
        OurSpool(cNomeRel)
    endif

    MS_FLUSH()

Return 

