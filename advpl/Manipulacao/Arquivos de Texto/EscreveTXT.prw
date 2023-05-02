#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function EscreveTXT
    Função de usuário para a criação de arquivo .txt
    @type  Function
    @author Edison Cake
    @since 24/04/2023
    /*/
User Function EscreveTXT()
    local cPath := PARAMIXB
    local cFile := "Arquivo_Texto.txt"

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

            //! Se não houveram erros, iniciamos a escrita do novo arquivo com o método Write().
            oWritter:Write("Olá!" + CRLF + "Esse é um teste para ver se o programa funciona.")

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
