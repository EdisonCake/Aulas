#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function MYMVC_2
    Exemplo MVC
    @type  Function
    @author Edison Cake
    @since 20/03/2023
    /*/
User Function MYMVC_2()
    local cAlias := "ZZC"
    local cTitle := "Cursos"
    local oBrowse := FwMBrowse():New()      // Iniciei meu modelo com a função MBrowse

    oBrowse:SetAlias(cAlias)                // Defini a tabela que será utilizada
    oBrowse:SetDescription(cTitle)          // Defini a descrição na tabela

    oBrowse:AddButton("Informações do Curso", {|| u_GetCurso()})

    oBrowse:DisableDetails()                // Desabilitada a guia de detalhes na mBrowse
    oBrowse:DisableReport()                 // Desabilitada a mensagem de erro ao fechar o mBrowse

    oBrowse:Activate()                      // Ativação do mBrowse
Return 

Static Function MenuDef()                   // Função para criar as opções do menu
    local aRotina := {}
    
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MYMVC_2' OPERATION 2 ACCESS 0     // Adicionada a opção/botão no Menu
    ADD OPTION aRotina TITLE 'Cadastrar'  ACTION 'VIEWDEF.MYMVC_2' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Mudar'      ACTION 'VIEWDEF.MYMVC_2' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Deletar'    ACTION 'VIEWDEF.MYMVC_2' OPERATION 5 ACCESS 0


Return aRotina                              // Deve retornar o array com os botões de menu

Static Function ModelDef()                  // Função para a criação de modelo.
    local oModel   := MpFormModel():New("MyMVC_2M")         // Criando um modelo, e definindo um tipo de formulário
    local oStruZZC := FwFormStruct(1, 'ZZC')                // Definindo a estrutura do formulario, com o parâmetro 1, que é o modelo completo.
    local oStruZZB := FwFormStruct(1, 'ZZB')
    local aGatilho  := FwStruTrigger('ZZB_COD', 'ZZB_NOME', 'ZZS->ZZS_NOME', .T., 'ZZS', 1, 'xFilial("ZZS")+alltrim(M->ZZB_COD)')  // Índice para o gatilho.

    oStruZZB:AddTrigger(aGatilho[1], aGatilho[2], aGatilho[3], aGatilho[4])

    oModel:AddFields("ZZCMASTER", /* Componente Pai */, oStruZZC) // Criei um componente de formulário

    oModel:AddGrid('ZZBDETAIL', 'ZZCMASTER', oStruZZB)    // Método para criação de grade, com linhas e colunas.
    oModel:GetModel('ZZBDETAIL'):SetDescription("Alunos")

    oModel:SetDescription("Cursos")                         // Definindo uma descrição ao nosso modelo.
    oModel:GetModel('ZZCMASTER'):SetDescription("Cursos")
    oModel:SetPrimaryKey({'ZZC_CODIGO', 'ZZB_COD'})                       // Definindo o índice de ordenação da tela.

    oModel:SetRelation('ZZBDETAIL', {{'ZZB_FILIAL', 'xFilial("ZZB")'}, {'ZZB_CURSO', 'ZZC_CODIGO'}}, ZZB->(IndexKey(1)))        // Definindo a relação entre os componentes

Return oModel                               // Deve retornar o modelo que foi "construído"

Static Function ViewDef()                   // Função para a visualização da tela, opções.
    local oModel    := FwLoadModel('MYMVC_2')               // Deve ser passado como string o nome do fonte onde se encontra o modelo.
    local oStruZZC  := FwFormStruct(2, 'ZZC')               // Definindo a estrutura do formulario, com o parâmetro 2, que é a estrutura de tela.
    local oStruZZB  := FwFormStruct(2, 'ZZB')
    local oView     := FwFormView():New()                   // Instanciando a classe da tela, criação do esqueleto da tela.

    // Preciso vincular o modelo carregado com o objeto criado, para esse vínculo funcionar.
    oView:SetModel(oModel)  

    //Precisa criar um componente visual compatível com o componente de dados
    oView:AddField("VIEW_ZZC", oStruZZC, 'ZZCMASTER')       // Vinculei meu componente visual de formulário, com o componente de formulário do modelo de dados (ModelDef).

    // Preciso adicionar um componente de grade;
    oView:AddGrid("VIEW_ZZB", oStruZZB, 'ZZBDETAIL')

    // Para fazer a exibição dos componentes, deve-se criar uma "caixa horizontal"
    oView:CreateHorizontalBox("CURSO", 30)        // O segundo parâmetro é o percentual vertical de uso da tela ativa. O programa utilizará todo o espaço dispobível horizontal por padrão.
    oView:CreateHorizontalBox("ALUNOS", 70)

    // Preciso vincular nosso componente visual com a tela criada.
    oView:SetOwnerView('VIEW_ZZC', 'CURSO')                     // Estou atribuindo um proprietário à minha view.

    oView:SetOwnerView('VIEW_ZZB', 'ALUNOS')

    oView:EnableTitleView('VIEW_ZZB', 'Alunos Matriculados')    // Habilitando os títulos para melhor visualização/identificação da grid
    oView:EnableTitleView('VIEW_ZZC', 'Dados do Curso')

    // Adicionando uma ação em um determinado momento.
    oView:SetViewAction('BUTTONOK', { |oView| MostraMsg(oView) })

    oView:SetFieldAction("ZZC_CODIGO", { |oView| CarregaNome(oView)})

    oView:AddUserButton('Um botão', 'CLIPS', { || FwAlertInfo('Pronto', 'Essa é a mensagem!') }, 'Botão de Mensagem', /* nShortcut */, {MODEL_OPERATION_INSERT, MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE})

    oView:AddOtherObjects("BOTÃO", { |oPanel| Clique(oPanel)})
    oView:SetOwnerView('BOTÃO', 'CURSO')

Return oView                                // Deve retornar nossa tela de visualização criada

Static Function MostraMsg(oView)
    local nOper   := oView:GetOperation()
    local cCurso  := oView:GetValue('ZZCMASTER', "ZZC_CURSO")
    local cLinhas := cValToChar(oView:GetModel('ZZBDETAIL'):Length(.T.))

    if nOper == 3
        FwAlertSuccess("Inclusão do curso <b>" + cCurso + "</b> realizada com sucesso!", "SetViewAction")
    elseif nOper == 4
        FwAlertSuccess("Alteração do curso <b>" + cCurso + "</b> realizada com sucesso!", "SetViewAction")
    elseif nOper == 5
        FwAlertSuccess("Exclusão do curso <b>" + cCurso + "</b> realizada com sucesso!", "SetViewAction")
    endif

    FwAlertInfo("Existem <b>" + cLinhas + "</b> linhas no grid.")

Return

Static Function CarregaNome(oView)
    local cNome  := 'Curso'
    local oModel := oView:GetModel("ZZCMASTER")

    oModel:SetValue('ZZC_CURSO', cNome)

    oView:Refresh()
Return

Static Function Clique(oPanel)
    local oButton

    oButton := TButton():New(005, 001, 'Não clique aqui', oPanel, { || FwAlertSuccess("Curioso...", "KKKKKKK!") }, 050, 020)
    oButton:SetCSS("QPushButton {color: red; font-weigth: bolder;}")
Return
