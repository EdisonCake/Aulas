#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function TesteXLS
    Função de usuário para gerar um XLS de teste com base em informações chumbadas no sistema.
    @type  Function
    @author Edison Cake
    @since 19/04/2023
    /*/
User Function TesteXLS()
    local oExcel := FwMsExcelEx():New()
    local cAlias := "SB1"
    local aArea := GetArea()

    local aInfo := {}

    oExcel:AddWorkSheet("Produtos")
    oExcel:AddTable("Produtos", "Cadastro de Produtos")

    oExcel:AddColumn("Produtos", "Cadastro de Produtos", "Código", 1, 1, .F.)
    oExcel:AddColumn("Produtos", "Cadastro de Produtos", "Descrição", 1, 1, .F.)

    DbSelectArea(cAlias)
    (cAlias)->(DbGoTop())

    While (cAlias)->(!Eof())

        aAdd(aInfo, alltrim((cAlias)->(B1_COD)))
        aAdd(aInfo, alltrim((cAlias)->(B1_DESC)))

        oExcel:AddRow("Produtos", "Cadastro de Produtos", aInfo)

        (cAlias)->(DbSkip())
        aInfo := {}
    End do

    RestArea(aArea)

    oExcel:Activate()
    oExcel:GetXMLFile("Teste.xls")
Return 
