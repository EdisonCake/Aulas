#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function DelPasta
    Fun��o para fazer a exclus�o de pastas e/ou arquivos no sistema.
    @type  Function
    @author Edison Cake
    @since 24/04/2023
    /*/
User Function DelPasta()
    local cPath     := "C:\Users\ediso\Desktop\teste\"
    local aFiles    := Directory(cPath + "*.*", "D", /* Compatibilidade */, /* ChangeCase */, 1)
    local nCount     := 0

    //! Verifica se a pasta existe para poder excluir.
    if ExistDir(cPath)

        //! Pede uma confirma��o do usu�rio se realmente deseja fazer a exclus�o da pasta.
        if MsgYesNo("Deseja realmente excluir a pasta?", "Aten��o")
            
            //! Verifica se existem arquivos dentro da pasta a ser exclu�da.
            if Len(aFiles) > 0
                For nCount := 3 to Len(aFiles)
                    
                    //! Verifica se deu certo a exclus�o do arquivo.
                    if FErase(cPath + aFiles[nCount][1]) == -1
                        MsgStop("Houve um erro ao apagar o arquivo " + aFiles[nCount][1])

                    endif
                Next
            endif


            //! Informa se o diret�rio foi exclu�do ou n�o.
            if DirRemove(cPath)
                FwAlertSuccess("Diret�rio exclu�do com sucesso.", "Conclu�do")

            else
                FwAlertError("N�o foi poss�vel excluir o diret�rio informado.", "Aten��o")
            endif
        endif
        
    endif

Return 
