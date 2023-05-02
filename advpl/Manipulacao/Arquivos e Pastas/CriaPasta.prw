#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function CriaPasta
    Função para a criação de pastas (meio obvio, né..).
    @type  Function
    @author Edison Cake
    @since 24/04/2023
    /*/
User Function CriaPasta()
    local cPath     := "C:\Users\ediso\Desktop\"
    local cFolder   := "Teste\"
    
    //! Verificando se a pasta existe ou não.
    if !ExistDir(cPath + cFolder)

        //! Verifcica se a pasta foi criada com sucesso.
        if MakeDir(cPath + cFolder) == 0

            if ExistBlock("EscreveTXT")
                ExecBlock("EscreveTXT", .F., .F., cPath + cFolder)
            endif

            if ExistBlock("EscreveCSV")
                ExecBlock("EscreveCSV", .F., .F., cPath + cFolder)
            endif
        
        else
            FwAlertError("houve um erro ao criar a pasta!", "Erro!")

        endif

    else

        if ExistBlock("EscreveTXT")
            ExecBlock("EscreveTXT", .F., .F., cPath + cFolder)
        endif

        if ExistBlock("EscreveCSV")
            ExecBlock("EscreveCSV", .F., .F., cPath + cFolder)
        endif
    endif
    
Return 
