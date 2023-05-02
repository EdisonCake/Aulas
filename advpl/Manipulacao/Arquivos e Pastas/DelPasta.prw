#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function DelPasta
    Função para fazer a exclusão de pastas e/ou arquivos no sistema.
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

        //! Pede uma confirmação do usuário se realmente deseja fazer a exclusão da pasta.
        if MsgYesNo("Deseja realmente excluir a pasta?", "Atenção")
            
            //! Verifica se existem arquivos dentro da pasta a ser excluída.
            if Len(aFiles) > 0
                For nCount := 3 to Len(aFiles)
                    
                    //! Verifica se deu certo a exclusão do arquivo.
                    if FErase(cPath + aFiles[nCount][1]) == -1
                        MsgStop("Houve um erro ao apagar o arquivo " + aFiles[nCount][1])

                    endif
                Next
            endif


            //! Informa se o diretório foi excluído ou não.
            if DirRemove(cPath)
                FwAlertSuccess("Diretório excluído com sucesso.", "Concluído")

            else
                FwAlertError("Não foi possível excluir o diretório informado.", "Atenção")
            endif
        endif
        
    endif

Return 
