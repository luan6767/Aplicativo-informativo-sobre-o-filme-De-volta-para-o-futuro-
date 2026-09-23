# De Volta para o Futuro

## 1. Nomes dos alunos

- Aluno(a) 1: **PREENCHER**
- Aluno(a) 2: **PREENCHER**
- Turma: **PREENCHER**

## 2. Identificação do tema do aplicativo

Aplicativo mobile escolar sobre **De Volta para o Futuro (1985)**, feito com Flutter e Dart. Apresenta sinopse, enredo, elenco, ficha técnica, detalhes e curiosidades, seguindo os protótipos fornecidos.

## 3. Sumário da Wiki

- [Página inicial](wiki/Home.md)
- [Dados do filme](wiki/Dados-do-filme.md)
- [Protótipo e elementos](wiki/Prototipo.md)
- [Tela inicial](wiki/Tela-inicial.md)
- [Tela de enredo](wiki/Tela-enredo.md)
- [Tela de elenco](wiki/Tela-elenco.md)
- [Tela de detalhes](wiki/Tela-detalhes.md)
- [Tela de curiosidades](wiki/Tela-curiosidades.md)
- [Estrutura e implementação](wiki/Implementacao.md)
- [Referências](wiki/Referencias.md)
- [Roteiro de apresentação e entrega](wiki/Entrega.md)

## Executar no VS Code

Use **Visual Studio Code**, com as extensões **Flutter** e **Dart**, o Flutter SDK atualizado e instalado e um emulador Android ou celular com depuração USB. O editor Visual Studio é outro programa.

1. Extraia o ZIP e abra a pasta `de_volta_para_o_futuro` no VS Code.
2. No terminal dessa pasta, execute:

```sh
flutter pub get
flutter devices
flutter run
```

Selecione o celular/emulador quando solicitado. Também é possível usar F5 no VS Code. Na primeira execução, as dependências precisam de internet. Depois, o conteúdo e as imagens são locais; apenas os links externos precisam de conexão.

Para conferir a configuração do computador, use `flutter doctor`. O Android Studio pode ser usado somente para instalar o SDK Android e criar um emulador; o código pode ser editado no VS Code.

## Entendendo o código

- `lib/main.dart`: carregamento do JSON, telas e navegação.
- `lib/modelos.dart`: classes `Filme`, `Ator`, `Secao` e `ItemTexto`.
- `assets/dados/filme.json`: informações do filme, listas e links.
- `assets/imagens/`: recortes das imagens enviadas como referência.
- `wiki/`: documentação em Markdown, separada em páginas.

O aplicativo usa `Navigator.push`, `MaterialPageRoute`, `ListView`, `Wrap`, `Card`, `Text` e `Image.asset`. A única dependência adicional de execução é `url_launcher`, para abrir sites. Não há banco de dados, login ou gerenciamento de estado adicional.

As cinco telas visuais são montadas por três classes: `TelaInicio`, `TelaElenco` e `TelaConteudo`. Esta última recebe um objeto `Secao` para mostrar Enredo, Detalhes ou Curiosidades. Os textos sobre o filme vêm do JSON; somente rótulos da interface e mensagens de erro ficam no código.

## Antes de entregar

Preencha os nomes, execute o app no seu aparelho e siga [o roteiro de entrega](wiki/Entrega.md). Os arquivos da pasta `wiki` devem ser publicados como páginas na aba Wiki do seu repositório. Estar nesta pasta não os publica automaticamente na Wiki do GitHub.

Os protótipos originais estão identificados como protótipos. Não substituem as capturas da implementação nem o vídeo de navegação pedidos pela atividade.

## Validação

Análise Dart sem problemas e dois testes de widgets aprovados: carregamento/navegação/rolagem e layout em 320 × 700 com texto ampliado em 1,5 vez. As capturas em `wiki/capturas` foram renderizadas pelo motor Flutter em teste, com fonte Arial de apoio. Não foi gerado APK nem executado em emulador ou aparelho Android neste ambiente; confirme também a abertura de sites no seu celular.

Para repetir as verificações:

```sh
flutter analyze
flutter test
```
