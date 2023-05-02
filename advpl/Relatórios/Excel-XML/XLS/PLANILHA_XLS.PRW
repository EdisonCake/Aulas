//! Include padrão do sistema (pode ser a Protheus.CH também).
#INCLUDE 'TOTVS.CH'

//! Constantes de alinhamento das colunas.
#DEFINE LEFT    1
#DEFINE CENTER  2
#DEFINE RIGHT   3

//! Constantes de formatação da coluna.
#DEFINE GENERAL     1
#DEFINE NUMERIC     2
#DEFINE MONEY       3
#DEFINE DATETIME    4

/*/{Protheus.doc} User Function PLANILHA_XLS
    -
    @type  Function
    @author Edison Cake
    @since 19/04/2023
    /*/
User Function PLANILHA_XLS()
    //! Definindo local e nome do arquivo.
    local cPath     := "C:\Users\ediso\Desktop\"
    local cFile     := "Teste_Excel.xls"

    local aDados    := {}

    //! Definindo meu objeto de planilha do Excel.
    local oExcel    := FwMsExcelEx():New()

    //! Definindo os nomes/títulos (opcional, pode ser feito direto no método.)
    local cWorkSheet    := "Pessoas"
    local cTable        := "Dados Pessoais"

    //! Criando nossa WorkSheet
    oExcel:AddWorkSheet(cWorkSheet)

    //! Criando nossa tabela, e vinculando-a à nossa WorkSheet.
    oExcel:AddTable(cWorkSheet, cTable, /* lShowTitle */)

    //! Criando as colunas que irão aparecer na planilha.
    //? FWMsExcelEx():AddColumn(<cWorkSheet>, <cTable>, <cColumn>, <nAlign>, <nFormat>, <lTotal>)
    oExcel:AddColumn(cWorkSheet, cTable, "Nome",        LEFT,   GENERAL)
    oExcel:AddColumn(cWorkSheet, cTable, "Sobrenome",   LEFT,   GENERAL)
    oExcel:AddColumn(cWorkSheet, cTable, "Dt. Nasc.",   CENTER, DATETIME)
    oExcel:AddColumn(cWorkSheet, cTable, "E-Mail",      LEFT,   GENERAL)
    oExcel:AddColumn(cWorkSheet, cTable, "WhatsApp",    CENTER, GENERAL)
    oExcel:AddColumn(cWorkSheet, cTable, "Salário",     CENTER, MONEY)

    //! Array a ser recebido/incluso na linha da planilha.
    //* Nome(1), Sobrenome(2), Data(3), E-Mail(4), WhatsApp(5), Salário(6)
    aDados := {"Edison", "Cake", StoD("20230419"), "email@totvs.com.br", "(19) 98888-4321", 11598.65}


    //! Alterando a fonte da linha.
        oExcel:SetLineFont("Fira Code")
    //! Alterando o tamanho da fonte da linha.
        oExcel:SetLineSizeFont(12)
    //! Alterando a cor do fundo da linha (deve ser hexadecimal).
        oExcel:SetLineBgColor("#00FFAA")
    //! Alterando a cor da fonta da linha (deve ser hexadecimal).
        oExcel:SetLineFrColor("#000000")


    //! Alterando a fonte da segunda linha.
        oExcel:Set2LineFont("Fira Code")
    //! Alterando o tamanho da fonte da segunda linha.
        oExcel:Set2LineSizeFont(12)
    //! Alterando a cor do fundo da segunda linha (deve ser hexadecimal).
        oExcel:Set2LineBgColor("#000000")
    //! Alterando a cor da fonta da segunda linha (deve ser hexadecimal).
        oExcel:Set2LineFrColor("#FF0000")


    //! Definindo a fonte no título da tabela.
        oExcel:SetTitleFont("Fira Code")
    //! Definindo o tamanho da fonte do título.
        oExcel:SetTitleSizeFont(16)
    //! Definindo o título como negrito.
        oExcel:SetTiTleBold(.T.)
    //! Definindo a cor do fundo do título (deve ser hexadecimal).
        oExcel:SetTitleBgColor("#FFFF00")
    //! Definindo a cor da fonte do título (deve ser hexadecimal).
        oExcel:SetTitleFrColor("#0000FF")


    //! Definindo a fonte do título de cada coluna.
        oExcel:SetHeaderFont("Fira Code")
    //! Definindo o tamanho da fonte do título de cada coluna.
        oExcel:SetHeaderSizeFont(14)
    //! Definindo se será em negrito.
        oExcel:SetHeaderBold(.T.)
    //! Definindo a cor do fundo do título de cada coluna (deve ser hexadecimal).
        oExcel:SetBgColorHeader("#550099")
    //! Definindo a cor da fonte do título de cada coluna (deve ser hexadecimal).
        oExcel:SetFrColorHeader("#FFFFFF")


    //! Preenchendo as linhas da planilha.
    //? FWMsExcelEx():AddRow(<cWorkSheet>, <cTable>, <aRow>, <aCelStyle>)
    oExcel:AddRow(cWorkSheet, cTable, aDados)

    //! ------------------------------------------------------------------------------------------------------
    //! Criação da segunda guia/folha no Excel

    oExcel:AddWorkSheet("Veiculos")
    oExcel:AddTable("Veiculos", "Carros no Brasil")

    oExcel:AddColumn("Veiculos", "Carros no Brasil", "Marca",       LEFT,   GENERAL)
    oExcel:AddColumn("Veiculos", "Carros no Brasil", "Modelo",      LEFT,   GENERAL)
    oExcel:AddColumn("Veiculos", "Carros no Brasil", "Ano Fab.",    CENTER, NUMERIC)
    oExcel:AddColumn("Veiculos", "Carros no Brasil", "Ano Modelo",  CENTER, NUMERIC)
    oExcel:AddColumn("Veiculos", "Carros no Brasil", "Valor FIPE",  CENTER, MONEY)

    oExcel:AddRow("Veiculos", "Carros no Brasil", {"Volkswagen", "Nivus", 2023, 2023, 127.900})

    //! ------------------------------------------------------------------------------------------------------
    //! Criando a planilha de Excel com as informações.
    oExcel:Activate()

    //! Definindo endereço e nome do arquivo a ser gerado.
    oExcel:GetXMLFile(cPath + cFile)

    //! Verifica se possui instalação do MS Excel na máquina.
    if ApOleClient("MsExcel")

        //? Cria a classe e um executável do Excel.
        oExec := MsExcel():New()

        //? Chama uma propriedade do objeto e abre o arquivo Excel criado.
        oExec:WorkBooks:Open(cPath + cFile)

        //? Torna "visível" o arquivo e abre na tela para visualização.
        oExec:SetVisible(.T.)

        //? Após a visualização o objeto é "destruído" para poupar memória.
        oExec:Destroy()
    else

        //? Se não achar o arquivo, informar a falta do mesmo (opcional)
        FwAlertError("Arquivo não encontrado no Windows", "Excel não encontrado!")
    endif

    //? Mensagem de sucesso na criação do arquivo (opcional).
    FwAlertSuccess("Arquivo gerado com sucesso.", "Concluído!")

    //! "Destruindo" o arquivo de Excel após exibição para poupar memória.
    oExcel:DeActivate()
Return 
