#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function PSAY
    Criação de relatório com a função PSAY.
    @type  Function
    @author Edison Cake
    @since 03/04/2023
    /*/
User Function PSAY()
    local cTitle        := "Cadastros de Clientes"

    private cAlias      := "SA1"
    private cProgram    := "PSAY" 
    private cDesc1      := "Esse é um exemplo"
    private cDesc2      := "de relatório"
    private cDesc3      := "utilizando PSAY."
    private cSize       := "M"

    //! aReturn[1]    C            Tipo do formulário
    //! aReturn[2]    N            Opção de margem
    //! aReturn[3]    C            Destinatário
    //! aReturn[4]    N            Formato da impressão
    //! aReturn[5]    N            Dispositivo de impressão
    //! aReturn[6]    reservado
    //! aReturn[7]    reservado
    //! aReturn[8]    N            Ordem
    private aReturn     := {"Zebrado", 1, "Administração", 1, 2, "", "", 1}

    //! (cAlias, cProgram, [cPergunte], [cTitle], [cDesc1], [cDesc2], [cDesc3], [lDic], [aOrd], [lCompres], [cSize], [uParm12], [lFilter])
    private cNomeRel    := SetPrint(cAlias, cProgram, "", @cTitle, cDesc1, cDesc2, cDesc3, .F.,, .T., cSize,, .F.)
    
    //!SetDefault(aReturn, cAlias, [uParm3], [lNoAsk], [cSize], [nFormat])
    SetDefault(aReturn, cAlias)
    
    RptStatus({|| Imprime()}, cTitle, "Gerando relatório...")

Return 

/*/{Protheus.doc} Imprime
    Função para a impressão do relatório.
    @type  Function
    @author user
    @since 03/04/2023
/*/
Static Function Imprime()
    local nLinha    := 2
    local nColuna   := 2

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())

    While !EOF()
        @ ++nLinha,   nColuna PSAY PADR("Código: ", 10) + AllTrim(SA1->A1_COD)

        @ ++nLinha,   nColuna PSAY PADR("Nome: ", 10) + AllTrim(SA1->A1_NOME)
        
        @ ++nLinha,   nColuna PSAY PADR("Endereço: ", 10) + AllTrim(SA1->A1_END)

        if !Empty(SA1->A1_BAIRRO)
            @ ++nLinha, nColuna PSAY PADR("Bairro: ", 10) + AllTrim(SA1->A1_BAIRRO)
        endif 

        if !Empty(SA1->A1_MUN)
            @ ++nLinha, nColuna PSAY PADR("Cidade: ", 10) + AllTrim(SA1->A1_MUN)
        endif 

        if !Empty(SA1->A1_EST)
            @ ++nLinha, nColuna PSAY PADR("UF: ", 10) + AllTrim(SA1->A1_EST)
        endif

        if !Empty(SA1->A1_CEP)
            @ ++nLinha, nColuna PSAY PADR("CEP: ", 10) + AllTrim(SA1->A1_CEP)
        endif

        @ ++nLinha, nColuna PSAY Replicate("-", 50)

        SA1->(DbSkip())
    End do

    SET DEVICE TO SCREEN

    if aReturn[5] == 1
        SET PRINTER TO DbCommitAll()
        OurSpool(cNomeRel)
    endif

    MS_FLUSH()

Return 
