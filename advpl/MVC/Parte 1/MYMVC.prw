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

    // Objeto que será utilizado como "browse"
    // O objeto recebe o método "novo" para criar uma nova tela com base na FwMBrowse()"
    local oBrowse := FwMBrowse():New()

    // Aqui, é atribuído qual alias (tabela) que será utilizado.
    oBrowse:SetAlias(cAlias)

    // Aqui é a descrição, ou o título da nossa tela/do nosso browse.
    oBrowse:SetDescription(cTitle)

    // Adicionando legendas no browse.
    // oBrowse:AddLegend('A1_TIPO == "F"', 'BLACK',  'Consumidor Final')   // AddLegend("Condição", "Cor", "Descrição")
    // oBrowse:AddLegend('A1_TIPO == "L"', 'GREEN',  'Produtor Rural')     
    // oBrowse:AddLegend('A1_TIPO == "S"', 'ORANGE', 'Solidário')          

    // Adicionando um filtro ao nosso browse.
    // oBrowse:SetFilterDefault('A1_TIPO == "F"')                       // Aqui, aparecerá somente os cadastros com o A1_TIPO == "F"

    // Aqui é desabilitado o campo "Detalhes" da linha posicionada.
    oBrowse:DisableDetails()

    // Esse método desativa o relatório de erro ao fechar a função.
    oBrowse:DisableReport()

    // Aqui é ativado nosso browse.
    oBrowse:Activate()
Return 

Static Function MenuDef()
    local aRotina := {}

    ADD OPTION aRotina      TITLE 'Incluir'    ACTION 'VIEWDEF.MYMVC'   OPERATION 3    ACCESS 0
    ADD OPTION aRotina      TITLE 'Alterar'    ACTION 'VIEWDEF.MYMVC'   OPERATION 4    ACCESS 0
    ADD OPTION aRotina      TITLE 'Excluir'    ACTION 'VIEWDEF.MYMVC'   OPERATION 5    ACCESS 0
    
Return aRotina

Static Function ModelDef()
    
    local oModel   := MPFormModel():New("MYMVCM")       // Aqui é pego o modelo, os dados da classe, todos métodos e informações/atributos.
    local oStruZZC := FwFormStruct(1, "ZZC")            // Aqui cria a estrutura do formulário com as suas propriedades

    // Aqui adiciona os campos com base no modelo/objeto modelo de dados e estrutura.
    oModel:AddFields('ZZCMASTER', NIL, oStruZZC)

    // Aqui cria uma descrição ao modelo criado.
    oModel:SetDescription("Modelo de Dados dos Cursos")

    // Aqui, pega um modelo de dados e adiciona uma descrição.
    oModel:GetModel("ZZCMASTER"):SetDescription("Formulário do Curso")

    // Aqui é definido um índice de visualização, é atribuída uma chave primária.
    oModel:SetPrimaryKey({"ZZC_CODIGO"})

Return oModel

Static Function ViewDef()
    local oModel := FwLoadModel("MYMVC")        // Aqui é carregado o modelo a ser exibido.
    local oStruZZC := FwFormStruct(2, "ZZC")    // Aqui cria a estrutura do formulário com as suas propriedades
    local oView := FwFormView():New()           // Aqui é criada o objeto de visualização para a janela.

    // Aqui é definido o modelo que será executado / objeto de tela.
    oView:SetModel(oModel)

    // Aqui é criada a definição do formulário da tela.
    oView:AddField('VIEW_ZZC', oStruZZC, 'ZZCMASTER')

    // Aqui é criada uma tela, na qual servirá como agrupamento dos elementos do formulário.
    oView:CreateHorizontalBox("TELA", 100)

    oView:SetOwnerView("VIEW_ZZC", "TELA")

Return oView
