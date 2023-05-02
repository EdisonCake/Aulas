#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function EscreveCSV
    Função de usuário para a criação de arquivo .csv
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

    //! Verifica se existe a pasta e o arquivo que será criado.
    if File(cPath + cFile)
        FwAlertInfo("O arquivo já existe!", "Atenção")
    else
        //! Verifica se houve ou não algum erro na criação do arquivo.
        if !oWritter:Create()
            FwAlertError("Houve um erro ao gerar o arquivo!" + CRLF + "Erro: " + oWritter:Error():Message, "Erro")
        else
            //! Informando o que será gravado no nosso arquivo CSV.
            cTexto := "Cadastro de Pessoas" + CRLF
            cTexto += "Nome;Idade" + CRLF
            cTexto += "Edison Cake;25" + CRLF
            cTexto += "Stefani Germanotta;37" + CRLF
            cTexto += "Billie Eilish;21" + CRLF

            //! Fazendo a escrita das informações no arquivo.
            oWritter:Write(cTexto)

            //! Método para fechar e gravar o arquivo.
            oWritter:Close()

            //! Perguntando ao usuário se deseja abrir o arquivo de texto gerado.
            if  MsgYesNo("Arquivo gerado com sucesso!" + CRLF + "Deseja abrir?", "Deseja visualizar o arquivo?")
                
                //! Função para executar o arquivo gerado.
                //? ShellExecute(<cAcao>, <cArquivo>, <cParam>, <cDirTrabalho>, [nOpc])
                ShellExecute('OPEN', cFile, "", cPath, 1)
            endif

        endif
    endif

Return 
