#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function LerCSV
    Função para realizar a leitura de um arquivo em .csv
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

    //! Verificando se foi possível abrir o arquivo para fazer a leitura.
    if oFile:Open()

        //! Verificando se o arquivo está vazio ou não.
        if !oFile:EoF()

            //! Pegando todas as linhas do arquivo.
            aContent := oFile:GetAllLines()
        endif

        //! Concatenando o conteúdo do array em uma variável de string.
        For nCount := 1 to Len(aContent)
            
            if nCount == 1
                cTxtLine := aContent[nCount] + CRLF
            else
                aLinha      := StrTokArr(aContent[nCount], ";")
                cTxtLine    += aLinha[1] + " - " + aLinha[2] + CRLF 
            endif


        Next


        //! Após fazer toda a leitura, deve-se fechar o arquivo com o método Close().
        oFile:Close()

    endif


    FwAlertInfo(cTxtLine, "Conteúdo do Arquivo: ")

Return 
