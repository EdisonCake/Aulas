#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function EscreveCSV
    Fun��o de usu�rio para a cria��o de arquivo .csv
    @type  Function
    @author Edison Cake
    @since 24/04/2023
    /*/
User Function EscreveCSV()
    local cPath     := PARAMIXB
    local cFile     := "Dados.csv"
    local cTexto    := ""

    //? FwFileWriter():New(<cFileName>, <lBuffer>, [<nBufferSize>])
    local oWritter := FwFileWriter():New(cPath + cFile, .T.)

    //! Verifica se existe a pasta e o arquivo que ser� criado.
    if File(cPath + cFile)
        FwAlertInfo("O arquivo j� existe!", "Aten��o")
    else
        //! Verifica se houve ou n�o algum erro na cria��o do arquivo.
        if !oWritter:Create()
            FwAlertError("Houve um erro ao gerar o arquivo!" + CRLF + "Erro: " + oWritter:Error():Message, "Erro")
        else
            //! Informando o que ser� gravado no nosso arquivo CSV.
            cTexto := "Cadastro de Pessoas" + CRLF
            cTexto += "Nome;Idade" + CRLF
            cTexto += "Edison Cake;25" + CRLF
            cTexto += "Stefani Germanotta;37" + CRLF
            cTexto += "Billie Eilish;21" + CRLF

            //! Fazendo a escrita das informa��es no arquivo.
            oWritter:Write(cTexto)

            //! M�todo para fechar e gravar o arquivo.
            oWritter:Close()

            //! Perguntando ao usu�rio se deseja abrir o arquivo de texto gerado.
            if  MsgYesNo("Arquivo gerado com sucesso!" + CRLF + "Deseja abrir?", "Deseja visualizar o arquivo?")
                
                //! Fun��o para executar o arquivo gerado.
                //? ShellExecute(<cAcao>, <cArquivo>, <cParam>, <cDirTrabalho>, [nOpc])
                ShellExecute('OPEN', cFile, "", cPath, 1)
            endif

        endif
    endif

Return 
