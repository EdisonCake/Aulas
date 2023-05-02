#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function MYMVC
    Exemplo de uso da classe FwMBrowse
    @type  Function
    @author Edison Cake
    @since 17/03/2023
    /*/
User Function MYMVC()
    local cAlias := "ZZC"
    local cTitle := "Cadastro de Cursos"

    // Objeto que ser� utilizado como "browse"
    // O objeto recebe o m�todo "novo" para criar uma nova tela com base na FwMBrowse()"
    local oBrowse := FwMBrowse():New()

    // Aqui, � atribu�do qual alias (tabela) que ser� utilizado.
    oBrowse:SetAlias(cAlias)

    // Aqui � a descri��o, ou o t�tulo da nossa tela/do nosso browse.
    oBrowse:SetDescription(cTitle)

    // Adicionando legendas no browse.
    // oBrowse:AddLegend('A1_TIPO == "F"', 'BLACK',  'Consumidor Final')   // AddLegend("Condi��o", "Cor", "Descri��o")
    // oBrowse:AddLegend('A1_TIPO == "L"', 'GREEN',  'Produtor Rural')     
    // oBrowse:AddLegend('A1_TIPO == "S"', 'ORANGE', 'Solid�rio')          

    // Adicionando um filtro ao nosso browse.
    // oBrowse:SetFilterDefault('A1_TIPO == "F"')                       // Aqui, aparecer� somente os cadastros com o A1_TIPO == "F"

    // Aqui � desabilitado o campo "Detalhes" da linha posicionada.
    oBrowse:DisableDetails()

    // Esse m�todo desativa o relat�rio de erro ao fechar a fun��o.
    oBrowse:DisableReport()

    // Aqui � ativado nosso browse.
    oBrowse:Activate()
Return 

Static Function MenuDef()
    local aRotina := {}

    ADD OPTION aRotina      TITLE 'Incluir'    ACTION 'VIEWDEF.MYMVC'   OPERATION 3    ACCESS 0
    ADD OPTION aRotina      TITLE 'Alterar'    ACTION 'VIEWDEF.MYMVC'   OPERATION 4    ACCESS 0
    ADD OPTION aRotina      TITLE 'Excluir'    ACTION 'VIEWDEF.MYMVC'   OPERATION 5    ACCESS 0
    
Return aRotina

Static Function ModelDef()
    
    local oModel   := MPFormModel():New("MYMVCM")       // Aqui � pego o modelo, os dados da classe, todos m�todos e informa��es/atributos.
    local oStruZZC := FwFormStruct(1, "ZZC")            // Aqui cria a estrutura do formul�rio com as suas propriedades

    // Aqui adiciona os campos com base no modelo/objeto modelo de dados e estrutura.
    oModel:AddFields('ZZCMASTER', NIL, oStruZZC)

    // Aqui cria uma descri��o ao modelo criado.
    oModel:SetDescription("Modelo de Dados dos Cursos")

    // Aqui, pega um modelo de dados e adiciona uma descri��o.
    oModel:GetModel("ZZCMASTER"):SetDescription("Formul�rio do Curso")

    // Aqui � definido um �ndice de visualiza��o, � atribu�da uma chave prim�ria.
    oModel:SetPrimaryKey({"ZZC_CODIGO"})

Return oModel

Static Function ViewDef()
    local oModel := FwLoadModel("MYMVC")        // Aqui � carregado o modelo a ser exibido.
    local oStruZZC := FwFormStruct(2, "ZZC")    // Aqui cria a estrutura do formul�rio com as suas propriedades
    local oView := FwFormView():New()           // Aqui � criada o objeto de visualiza��o para a janela.

    // Aqui � definido o modelo que ser� executado / objeto de tela.
    oView:SetModel(oModel)

    // Aqui � criada a defini��o do formul�rio da tela.
    oView:AddField('VIEW_ZZC', oStruZZC, 'ZZCMASTER')

    // Aqui � criada uma tela, na qual servir� como agrupamento dos elementos do formul�rio.
    oView:CreateHorizontalBox("TELA", 100)

    oView:SetOwnerView("VIEW_ZZC", "TELA")

Return oView
