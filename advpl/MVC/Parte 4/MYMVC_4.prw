#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function MyMVC_4
  Exemplo MVC
  @type  Function
  @author Muriel Zounar
  @since 24/03/2023
/*/
User Function MyMVC_4()
  Local cAlias  := 'ZZC'
  Local cTitle  := 'Cursos'
  Local oMark   := FwMarkBrowse():New()

  oMark:SetAlias(cAlias)
  oMark:SetDescription(cTitle)
  
  oMark:SetFieldMark('ZZC_MARC')
  oMark:AddButton("Marcar Todos",     "U_Marcar"    ,   , 1)
  oMark:AddButton("Desarcar Todos",   "U_Desmarcar" ,   , 1)
  oMark:AddButton("Inverter Seleção", "U_Inverter"  ,   , 1)
  oMark:AddButton("Deletar Marcados", "U_Deletar"   ,  5, 1)
    
  oMark:DisableDetails()
  oMark:DisableReport()
  oMark:Activate()

Return

Static Function MenuDef()
  Local aRotina := {}

  ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.MYMVC_4' OPERATION 3 ACCESS 0
  ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.MYMVC_4' OPERATION 4 ACCESS 0
  ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.MYMVC_4' OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
  Local oModel    := MPFormModel():New('MYMVC_4M')
  Local oStruZZC  := FWFormStruct(1, 'ZZC')
  Local oStruZZB  := FWFormStruct(1, 'ZZB')
  Local aGatilho  := FwStruTrigger('ZZB_COD', 'ZZB_NOME', 'ZZS->ZZS_NOME', .T., 'ZZS', 1, 'xFilial("ZZS")+AllTrim(M->ZZB_COD)')

  oStruZZB:AddTrigger(aGatilho[1], aGatilho[2], aGatilho[3], aGatilho[4])
  
  oModel:SetDescription('Cursos')

  oModel:AddFields('ZZCMASTER', /*COMPONENTE PAI*/, oStruZZC)
  oModel:GetModel('ZZCMASTER'):SetDescription('Cursos')

  oModel:AddGrid('ZZBDETAIL', 'ZZCMASTER', oStruZZB)
  oModel:GetModel('ZZBDETAIL'):SetDescription('Alunos')
  
  oModel:SetRelation('ZZBDETAIL', {{'ZZB_FILIAL', 'xFilial("ZZB")'}, {'ZZB_CURSO', 'ZZC_CODIGO'}}, ZZB->(IndexKey(1)))
  oModel:GetModel('ZZBDETAIL'):SetUniqueLine({'ZZB_COD'})
  oModel:SetPrimaryKey({'ZZC_CODIGO', 'ZZB_COD'})
Return oModel

Static Function ViewDef()
  Local oModel   := FWLoadModel('MYMVC_4')
  Local oStruZZC := FWFormStruct(2, 'ZZC')
  Local oStruZZB := FWFormStruct(2, 'ZZB')
  Local oView    := FWFormView():New()

  oView:SetModel(oModel)
  oView:AddField('VIEW_ZZC', oStruZZC, 'ZZCMASTER')
  oView:AddGrid('VIEW_ZZB', oStruZZB, 'ZZBDETAIL')

  oView:CreateHorizontalBox('SUPERIOR', 30)
  oView:CreateHorizontalBox('INFERIOR', 70)

  oView:SetOwnerView('VIEW_ZZC', 'SUPERIOR')
  oView:SetOwnerView('VIEW_ZZB', 'INFERIOR')

  oView:EnableTitleView('VIEW_ZZC', 'Dados do Curso')
  oView:EnableTitleView('VIEW_ZZB', 'Alunos Matriculados')

  oView:SetCloseOnOk({||.T.})
  oView:SetAfterOkButton({|| FwAlertSuccess("Tudo Certo", "SetAfterOkButton")})
  // oView:SetViewCanActivate({|| MsgYesNo("Ativar tela?", "SetViewCanActivate")})
  oView:SetAfterViewActivate({||FwAlertError("??", "??")})

Return oView

User Function Marcar()
  DbSelectArea("ZZC")

    ZZC->(DbGoTop())

    While !ZZC->(EoF())
      if !oMark:IsMark()
        oMark:MarkRec()
      endif


      ZZC->(DbSkip())
    End Do

    oMark:Refresh(.T.)
Return

User Function Desmarcar()
  DbSelectArea("ZZC")

    ZZC->(DbGoTop())

    While !ZZC->(EoF())
      if oMark:IsMark()
        oMark:MarkRec()
      endif


      ZZC->(DbSkip())
    End Do

    oMark:Refresh(.T.)
Return

User Function Inverter()
  DbSelectArea("ZZC")

    ZZC->(DbGoTop())

    While !ZZC->(EoF())
        oMark:MarkRec()

      ZZC->(DbSkip())
    End Do

    oMark:Refresh(.T.)
Return

User Function Deletar()
  If MsgYesNo("Confirma a exclusão?", "Tem certeza?")
    DbSelectArea("ZZC")

      ZZC->(DbGoTop())

      While !ZZC->(EoF())
          if oMark:IsMark()
              RecLock("ZZC", .F.)
                ZZC->(DbDelete())
              ZZC->(MsUnlock())
          endif

          ZZC->(DbSkip())
      End Do

      oMark:Refresh(.T.)
  endif
Return

/* User Function MyMVC_4()
  Local cAlias  := 'ZZC'
  Local cTitle  := 'Cursos'
  Local oBrowse := FwMBrowse():New()

  oBrowse:SetAlias(cAlias)
  oBrowse:SetDescription(cTitle)
  oBrowse:DisableDetails()
  oBrowse:DisableReport()
  oBrowse:Activate()
Return */
