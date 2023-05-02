#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function LerCSV
    Fun��o para realizar a leitura de um arquivo em .csv
    @type  Function
    @author Edison Cake
    @since 24/04/2023
    /*/
User Function LerCSV()
    local cPath     := "C:\Users\ediso\Desktop\"
    local cFile     := "dados.csv"
    local cTxtLine  := ""
    local nCount    := 1
    local aContent  := {}
    local aLinha    := {}
    local oFile     := FwFileReader():New(cPath + cFile)

    //! Verificando se foi poss�vel abrir o arquivo para fazer a leitura.
    if oFile:Open()

        //! Verificando se o arquivo est� vazio ou n�o.
        if !oFile:EoF()

            //! Pegando todas as linhas do arquivo.
            aContent := oFile:GetAllLines()
        endif

        //! Concatenando o conte�do do array em uma vari�vel de string.
        For nCount := 1 to Len(aContent)
            
            if nCount == 1
                cTxtLine := aContent[nCount] + CRLF
            else
                aLinha      := StrTokArr(aContent[nCount], ";")
                cTxtLine    += aLinha[1] + " - " + aLinha[2] + CRLF 
            endif


        Next


        //! Ap�s fazer toda a leitura, deve-se fechar o arquivo com o m�todo Close().
        oFile:Close()

    endif


    FwAlertInfo(cTxtLine, "Conte�do do Arquivo: ")

Return 
