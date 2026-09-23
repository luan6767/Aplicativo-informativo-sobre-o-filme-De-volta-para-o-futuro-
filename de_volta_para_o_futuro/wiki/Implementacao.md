# Estrutura e implementação

## Orientação a objetos e JSON

`Filme` possui título, ano, diretor, sinopse, capa, links, uma lista de `Ator` e uma lista de `Secao`. Cada `Secao` possui identificador, título, imagem e uma lista de `ItemTexto`. Cada ator possui nome, personagem, imagem, link e descrição do destino. `ItemTexto` possui título e texto.

Os construtores `fromJson` convertem mapas do JSON em objetos. `carregarFilme` lê o arquivo com `rootBundle.loadString`, converte com `jsonDecode` e chama `Filme.fromJson`. `FutureBuilder` mostra o carregamento, o resultado ou uma mensagem de erro com botão para tentar novamente.

## Estrutura do arquivo

```text
filme.json
  titulo, ano, diretor, sinopse, capa, site, siteElenco
  elenco[]
    nome, personagem, imagem, link, tipoLink
  secoes[]
    id, titulo, imagem
    itens[]
      titulo, texto
```

## Funcionalidades exigidas

| Requisito | Implementação |
| --- | --- |
| Orientação a objetos | Classes de domínio em modelos.dart |
| Navegação simples | Navigator.push para Elenco e botão de voltar |
| Navegação com parâmetros | Objeto Secao passado ao construtor de TelaConteudo |
| Listas com JSON | Filme.elenco, Filme.secoes e Secao.itens |
| Navegação externa | abrirLink usa launchUrl de url_launcher |
| Assets locais | JSON e imagens declarados no pubspec.yaml |

Não há downloads de conteúdo durante a abertura do app. O acesso à internet acontece quando o usuário abre um link no navegador externo. Falhas ao abrir são tratadas com `SnackBar`.

## Fluxo

```text
Carregamento → Início → Enredo → Voltar
                     → Elenco → Site externo
                     → Detalhes → Voltar
                     → Curiosidades → Voltar
                     → Site oficial
```
