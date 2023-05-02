#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function LerTXT
    Fun��o para realizar a leitura de um arquivo em .txt
    @type  Function
    @author Edison Cake
    @since 24/04/2023
    /*/
User Function LerTXT()
    local cPath     := "C:\Users\ediso\Desktop\"
    local cFile     := "arquivo_texto.txt"
    local cTxtLine  := ""
    local nCount    := 1
    local oFile     := FwFileReader():New(cPath + cFile)

    //! Verificando se foi poss�vel abrir o arquivo para fazer a leitura.
    if oFile:Open()

        //! Verificando se o arquivo est� vazio ou n�o.
        if !oFile:EoF()

            //! Enquanto "houverem linhas" a serem lidas, o programa executar�.
            while oFile:HasLine()
                cTxtLine += "Linha " + cvaltochar(nCount) + ": " + oFile:GetLine(.T.)
                nCount++ 
            end do
        endif
    endif

    //! Ap�s fazer toda a leitura, deve-se fechar o arquivo com o m�todo Close().
    oFile:Close()

    FwAlertInfo(cTxtLine, "Conte�do do Arquivo: ")

Return 
