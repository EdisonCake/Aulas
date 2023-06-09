#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function PSAY
    Cria��o de relat�rio com a fun��o PSAY.
    @type  Function
    @author Edison Cake
    @since 03/04/2023
    /*/
User Function PSAY()
    local cTitle        := "Cadastros de Clientes"

    private cAlias      := "SA1"
    private cProgram    := "PSAY" 
    private cDesc1      := "Esse � um exemplo"
    private cDesc2      := "de relat�rio"
    private cDesc3      := "utilizando PSAY."
    private cSize       := "M"

    //! aReturn[1]    C            Tipo do formul�rio
    //! aReturn[2]    N            Op��o de margem
    //! aReturn[3]    C            Destinat�rio
    //! aReturn[4]    N            Formato da impress�o
    //! aReturn[5]    N            Dispositivo de impress�o
    //! aReturn[6]    reservado
    //! aReturn[7]    reservado
    //! aReturn[8]    N            Ordem
    private aReturn     := {"Zebrado", 1, "Administra��o", 1, 2, "", "", 1}

    //! (cAlias, cProgram, [cPergunte], [cTitle], [cDesc1], [cDesc2], [cDesc3], [lDic], [aOrd], [lCompres], [cSize], [uParm12], [lFilter])
    private cNomeRel    := SetPrint(cAlias, cProgram, "", @cTitle, cDesc1, cDesc2, cDesc3, .F.,, .T., cSize,, .F.)
    
    //!SetDefault(aReturn, cAlias, [uParm3], [lNoAsk], [cSize], [nFormat])
    SetDefault(aReturn, cAlias)
    
    RptStatus({|| Imprime()}, cTitle, "Gerando relat�rio...")

Return 

/*/{Protheus.doc} Imprime
    Fun��o para a impress�o do relat�rio.
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
        @ ++nLinha,   nColuna PSAY PADR("C�digo: ", 10) + AllTrim(SA1->A1_COD)

        @ ++nLinha,   nColuna PSAY PADR("Nome: ", 10) + AllTrim(SA1->A1_NOME)
        
        @ ++nLinha,   nColuna PSAY PADR("Endere�o: ", 10) + AllTrim(SA1->A1_END)

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
