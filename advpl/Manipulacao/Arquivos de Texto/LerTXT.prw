#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function LerTXT
    Função para realizar a leitura de um arquivo em .txt
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

    //! Verificando se foi possível abrir o arquivo para fazer a leitura.
    if oFile:Open()

        //! Verificando se o arquivo está vazio ou não.
        if !oFile:EoF()

            //! Enquanto "houverem linhas" a serem lidas, o programa executará.
            while oFile:HasLine()
                cTxtLine += "Linha " + cvaltochar(nCount) + ": " + oFile:GetLine(.T.)
                nCount++ 
            end do
        endif
    endif

    //! Após fazer toda a leitura, deve-se fechar o arquivo com o método Close().
    oFile:Close()

    FwAlertInfo(cTxtLine, "Conteúdo do Arquivo: ")

Return 
