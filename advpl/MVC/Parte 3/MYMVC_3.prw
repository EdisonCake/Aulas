#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function MYMVC_3
    Exemplo MVC
    @type  Function
    @author Edison Cake
    @since 22/03/2023
    /*/
User Function MYMVC_3()
    local cAlias := "ZZC"
    local cTitle := "Cursos"
    local oBrowse := FwMBrowse():New()      // Inicidei meu modelo com a função MBrowse

    oBrowse:SetAlias(cAlias)                // Defini a tabela que será utilizada
    oBrowse:SetDescription(cTitle)          // Defini a descrição na tabela

    oBrowse:DisableDetails()                // Desabilitada a guia de detalhes na mBrowse
    oBrowse:DisableReport()                 // Desabilitada a mensagem de erro ao fechar o mBrowse

    oBrowse:Activate()                      // Ativação do mBrowse
Return 

Static Function MenuDef()                   // Função para criar as opções do menu
    local aRotina := {}
    
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MYMVC_3' OPERATION 2 ACCESS 0     // Adicionada a opção/botão no Menu
    ADD OPTION aRotina TITLE 'Cadastrar'  ACTION 'VIEWDEF.MYMVC_3' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Mudar'      ACTION 'VIEWDEF.MYMVC_3' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Deletar'    ACTION 'VIEWDEF.MYMVC_3' OPERATION 5 ACCESS 0

Return aRotina                              // Deve retornar o array com os botões de menu

Static Function ModelDef()                  // Função para a criação de modelo.
    // Validações do modelo
    local bModelPre     := { |oModel| ValidPre(oModel) }
    local bModelPos     := { |oModel| ValidPos(oModel) }
    local bModelCancel  := { |oModel| Cancel(oModel)   }

    // Validações do formulário
    local bFieldPos := { |oFields| ValidFields(oFields)}
    // local bLoadFields := { |oFields, lCopy| LoadFields(oFields)}

    //Validações de Grid
    local bLinePre      := {|oGrid, nLine, cAction, cFieldId, xValue, xCurValue| ValidLine(oGrid, nLine, cAction, cFieldId, xValue, xCurValue)}
    local bLinePos      := {|oGrid, nLine| ValidPosLine(oGrid)}
    local bLineLoad     := {|oGrid, lCopy| LoadLine(oGrid)}

    
    local oModel   := MpFormModel():New("MyMVC_3M", bModelPre, bModelPos, /* bModelCommit */, bModelCancel)         // Criando um modelo, e definindo um tipo de formulário
    local oStruZZC := FwFormStruct(1, 'ZZC')                // Definindo a estrutura do formulario, com o parâmetro 1, que é o modelo completo.
    local oStruZZB := FwFormStruct(1, 'ZZB')
    local aGatilho  := FwStruTrigger('ZZB_COD', 'ZZB_NOME', 'ZZS->ZZS_NOME', .T., 'ZZS', 1, 'xFilial("ZZS")+alltrim(M->ZZB_COD)')  // Índice para o gatilho.

    oStruZZB:AddTrigger(aGatilho[1], aGatilho[2], aGatilho[3], aGatilho[4])

    oModel:AddFields("ZZCMASTER", /* Componente Pai */, oStruZZC, /* bPre */, bFieldPos)       // Criei um componente de formulário

    oModel:AddGrid('ZZBDETAIL', 'ZZCMASTER', oStruZZB, bLinePre, bLinePos,,, bLineLoad)                  // Método para criação de grade, com linhas e colunas.

    oModel:GetModel('ZZBDETAIL'):SetDescription("Alunos")
    oModel:SetDescription("Cursos")                                     // Definindo uma descrição ao nosso modelo.
    oModel:GetModel('ZZCMASTER'):SetDescription("Cursos")
    oModel:SetPrimaryKey({'ZZC_CODIGO', 'ZZB_COD'})                     // Definindo o índice de ordenação da tela.
    oModel:SetRelation('ZZBDETAIL', {{'ZZB_FILIAL', 'xFilial("ZZB")'}, {'ZZB_CURSO', 'ZZC_CODIGO'}}, ZZB->(IndexKey(1)))        // Definindo a relação entre os componentes

    // Definindo um método para indicar linha única/impedir duplicidade de dados.
    oModel:GetModel('ZZBDETAIL'):SetUniqueLine({'ZZB_COD'})

Return oModel                               // Deve retornar o modelo que foi "construído"

Static Function ViewDef()                   // Função para a visualização da tela, opções.
    local oModel    := FwLoadModel('MYMVC_3')               // Deve ser passado como string o nome do fonte onde se encontra o modelo.
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

Static Function ValidPre(oModel)
    local nOperation := oModel:GetOperation()
    local lOK        := .T.

    if nOperation == MODEL_OPERATION_UPDATE
        oModel:GetModel("ZZCMASTER"):GetStruct():SetProperty("ZZC_CODIGO", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, ".F."))
    endif

Return lOk

Static Function ValidPos(oModel)
    local nOperation   := oModel:GetOperation()
    local cNomeCurso   := alltrim(upper(oModel:GetValue("ZZCMASTER", "ZZC_CURSO")))
    local lTudoOK      := .T.

    if nOperation == 5
        lTudoOK := .F.
        Help(NIL, NIL, 'Não é permitido exclusão.', NIL, 'Você não tem autorização para realizar essa ação.', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Contate o admnistrador do sistema.'})
    elseif cNomeCurso == "TESTE"
        lTudoOK := .F.
        Help(NIL, NIL, 'Não é possível gravar o curso.', NIL, 'O <b>NOME DO CURSO</b> não foi pode ser <b>TESTE</b>.', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Seja mais criativo!'})
    endif
    
Return lTudoOK

Static Function Cancel(oModel)
    local lCancela  := .F.
    local cMsg      := "Deseja cancelar a operação?"

    FwFormCancel(oModel)
    lCancela := MsgYesNo(cMsg, 'Cancelar?')

Return lCancela

Static Function ValidFields(oFields)
    local lTudoOK := .T.
    local cCod    := oFields:GetValue("ZZC_CODIGO")

    if cCod == "000000"
        lTudoOK := .F.
        Help(NIL, NIL, 'Operação não permitida.', NIL, 'O código do curso não pode ser <b>000000</b>.', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Seja mais criativo!'})
    endif

Return lTudoOK

Static Function LoadFields(oFields)
    local aDados := {}
    local nRecNo := LASTREC()

    aAdd(aDados, {xFilial('ZZC'), '111111', 'COBOL'})
    AaDD(aDados, nRecNo)
Return aDados

Static Function ValidLine(oGrid, nLine, cAction, cFieldId, xValue, xCurValue)
    Local lValido := .T.

    if cFieldId == 'ZZB_COD' .AND. cAction == 'SETVALUE' .AND. xValue == xCurValue
        lValido := .F.
        Help(NIL, NIL, 'Não tem porque fazer isso', NIL, 'Você digitou o mesmo código!', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Digite outra coisa!'})
    endif

Return lValido

Static Function ValidPosLine(oGrid)
    local lValido   := .T.
    local cAluno    := alltrim(upper(oGrid:GetValue("ZZB_NOME")))

    if cAluno == "MURIEL"
        lValido := .F.
        Help(NIL, NIL, 'Aluno banido!.', NIL, 'O aluno <b>' + cAluno + '</b> está proibido de estudar aqui!', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Selecione outro aluno!'})
    endif

Return lValido

Static Function LoadLine(oGrid)
    local aRetorno  := {}
    local aFields   := oGrid:GetStruct():GetFields()
    local aAux      := Array(Len(aFields))
    local nI        := 0

    For nI := 1 to len(aFields)
        if alltrim(aFields[nI, 3]) == "ZZB_DTINIC"
            aAux[nI] := Date()
        endif
    Next

    aAdd(aRetorno, {0, aAux})

Return aRetorno

