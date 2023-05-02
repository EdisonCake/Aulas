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
    local oBrowse := FwMBrowse():New()      // Iniciei meu modelo com a fun��o MBrowse

    oBrowse:SetAlias(cAlias)                // Defini a tabela que ser� utilizada
    oBrowse:SetDescription(cTitle)          // Defini a descri��o na tabela

    oBrowse:AddButton("Informa��es do Curso", {|| u_GetCurso()})

    oBrowse:DisableDetails()                // Desabilitada a guia de detalhes na mBrowse
    oBrowse:DisableReport()                 // Desabilitada a mensagem de erro ao fechar o mBrowse

    oBrowse:Activate()                      // Ativa��o do mBrowse
Return 

Static Function MenuDef()                   // Fun��o para criar as op��es do menu
    local aRotina := {}
    
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MYMVC_2' OPERATION 2 ACCESS 0     // Adicionada a op��o/bot�o no Menu
    ADD OPTION aRotina TITLE 'Cadastrar'  ACTION 'VIEWDEF.MYMVC_2' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Mudar'      ACTION 'VIEWDEF.MYMVC_2' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Deletar'    ACTION 'VIEWDEF.MYMVC_2' OPERATION 5 ACCESS 0


Return aRotina                              // Deve retornar o array com os bot�es de menu

Static Function ModelDef()                  // Fun��o para a cria��o de modelo.
    local oModel   := MpFormModel():New("MyMVC_2M")         // Criando um modelo, e definindo um tipo de formul�rio
    local oStruZZC := FwFormStruct(1, 'ZZC')                // Definindo a estrutura do formulario, com o par�metro 1, que � o modelo completo.
    local oStruZZB := FwFormStruct(1, 'ZZB')
    local aGatilho  := FwStruTrigger('ZZB_COD', 'ZZB_NOME', 'ZZS->ZZS_NOME', .T., 'ZZS', 1, 'xFilial("ZZS")+alltrim(M->ZZB_COD)')  // �ndice para o gatilho.

    oStruZZB:AddTrigger(aGatilho[1], aGatilho[2], aGatilho[3], aGatilho[4])

    oModel:AddFields("ZZCMASTER", /* Componente Pai */, oStruZZC) // Criei um componente de formul�rio

    oModel:AddGrid('ZZBDETAIL', 'ZZCMASTER', oStruZZB)    // M�todo para cria��o de grade, com linhas e colunas.
    oModel:GetModel('ZZBDETAIL'):SetDescription("Alunos")

    oModel:SetDescription("Cursos")                         // Definindo uma descri��o ao nosso modelo.
    oModel:GetModel('ZZCMASTER'):SetDescription("Cursos")
    oModel:SetPrimaryKey({'ZZC_CODIGO', 'ZZB_COD'})                       // Definindo o �ndice de ordena��o da tela.

    oModel:SetRelation('ZZBDETAIL', {{'ZZB_FILIAL', 'xFilial("ZZB")'}, {'ZZB_CURSO', 'ZZC_CODIGO'}}, ZZB->(IndexKey(1)))        // Definindo a rela��o entre os componentes

Return oModel                               // Deve retornar o modelo que foi "constru�do"

Static Function ViewDef()                   // Fun��o para a visualiza��o da tela, op��es.
    local oModel    := FwLoadModel('MYMVC_2')               // Deve ser passado como string o nome do fonte onde se encontra o modelo.
    local oStruZZC  := FwFormStruct(2, 'ZZC')               // Definindo a estrutura do formulario, com o par�metro 2, que � a estrutura de tela.
    local oStruZZB  := FwFormStruct(2, 'ZZB')
    local oView     := FwFormView():New()                   // Instanciando a classe da tela, cria��o do esqueleto da tela.

    // Preciso vincular o modelo carregado com o objeto criado, para esse v�nculo funcionar.
    oView:SetModel(oModel)  

    //Precisa criar um componente visual compat�vel com o componente de dados
    oView:AddField("VIEW_ZZC", oStruZZC, 'ZZCMASTER')       // Vinculei meu componente visual de formul�rio, com o componente de formul�rio do modelo de dados (ModelDef).

    // Preciso adicionar um componente de grade;
    oView:AddGrid("VIEW_ZZB", oStruZZB, 'ZZBDETAIL')

    // Para fazer a exibi��o dos componentes, deve-se criar uma "caixa horizontal"
    oView:CreateHorizontalBox("CURSO", 30)        // O segundo par�metro � o percentual vertical de uso da tela ativa. O programa utilizar� todo o espa�o dispob�vel horizontal por padr�o.
    oView:CreateHorizontalBox("ALUNOS", 70)

    // Preciso vincular nosso componente visual com a tela criada.
    oView:SetOwnerView('VIEW_ZZC', 'CURSO')                     // Estou atribuindo um propriet�rio � minha view.

    oView:SetOwnerView('VIEW_ZZB', 'ALUNOS')

    oView:EnableTitleView('VIEW_ZZB', 'Alunos Matriculados')    // Habilitando os t�tulos para melhor visualiza��o/identifica��o da grid
    oView:EnableTitleView('VIEW_ZZC', 'Dados do Curso')

    // Adicionando uma a��o em um determinado momento.
    oView:SetViewAction('BUTTONOK', { |oView| MostraMsg(oView) })

    oView:SetFieldAction("ZZC_CODIGO", { |oView| CarregaNome(oView)})

    oView:AddUserButton('Um bot�o', 'CLIPS', { || FwAlertInfo('Pronto', 'Essa � a mensagem!') }, 'Bot�o de Mensagem', /* nShortcut */, {MODEL_OPERATION_INSERT, MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE})

    oView:AddOtherObjects("BOT�O", { |oPanel| Clique(oPanel)})
    oView:SetOwnerView('BOT�O', 'CURSO')

Return oView                                // Deve retornar nossa tela de visualiza��o criada

Static Function MostraMsg(oView)
    local nOper   := oView:GetOperation()
    local cCurso  := oView:GetValue('ZZCMASTER', "ZZC_CURSO")
    local cLinhas := cValToChar(oView:GetModel('ZZBDETAIL'):Length(.T.))

    if nOper == 3
        FwAlertSuccess("Inclus�o do curso <b>" + cCurso + "</b> realizada com sucesso!", "SetViewAction")
    elseif nOper == 4
        FwAlertSuccess("Altera��o do curso <b>" + cCurso + "</b> realizada com sucesso!", "SetViewAction")
    elseif nOper == 5
        FwAlertSuccess("Exclus�o do curso <b>" + cCurso + "</b> realizada com sucesso!", "SetViewAction")
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

    oButton := TButton():New(005, 001, 'N�o clique aqui', oPanel, { || FwAlertSuccess("Curioso...", "KKKKKKK!") }, 050, 020)
    oButton:SetCSS("QPushButton {color: red; font-weigth: bolder;}")
Return
