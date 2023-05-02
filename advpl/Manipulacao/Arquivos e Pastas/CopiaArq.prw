#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function CopiaArq
    Programa para copiar arquivos ao diretorio do servidor
    @type  Function
    @author user
    @since 24/04/2023
    /*/
User Function CopiaArq()
    local cOrigin   := "C:\Users\ediso\Desktop\teste\"
    local cDestino  := "\Cake\"
    local aFiles    := Directory(cOrigin + "*.*", "D",,, 1)
    local nCount    := 0
    local nSize     := Len(aFiles)

    if nSize > 0
        For nCount := 3 to nSize
            if !CPYT2S(cOrigin + aFiles[nCount][1], cDestino)
                FwAlertError("Houve um erro ao copiar o arquivo " + aFiles[nCount, 1])
            endif
        Next

        FwAlertSuccess("Arquivo(s) copiado(s) com sucesso!", "Concluído.")
    else
        FwAlertError("Não existem arquivos ou subpastas no diretório informado.", "Atenção!")
    endif

Return 
