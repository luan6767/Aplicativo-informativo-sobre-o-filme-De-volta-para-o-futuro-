// Cada classe representa um tipo de informação do arquivo JSON.
class ItemTexto {
  final String titulo;
  final String texto;

  ItemTexto({required this.titulo, required this.texto});

  factory ItemTexto.fromJson(Map<String, dynamic> json) {
    return ItemTexto(titulo: json['titulo'], texto: json['texto']);
  }
}

class Ator {
  final String nome;
  final String personagem;
  final String imagem;
  final String link;
  final String tipoLink;

  Ator(
      {required this.nome,
      required this.personagem,
      required this.imagem,
      required this.link,
      required this.tipoLink});

  factory Ator.fromJson(Map<String, dynamic> json) {
    return Ator(
        nome: json['nome'],
        personagem: json['personagem'],
        imagem: json['imagem'],
        link: json['link'],
        tipoLink: json['tipoLink']);
  }
}

class Secao {
  final String id;
  final String titulo;
  final String imagem;
  final List<ItemTexto> itens;

  Secao(
      {required this.id,
      required this.titulo,
      required this.imagem,
      required this.itens});

  factory Secao.fromJson(Map<String, dynamic> json) {
    return Secao(
        id: json['id'],
        titulo: json['titulo'],
        imagem: json['imagem'],
        itens: (json['itens'] as List)
            .map((item) => ItemTexto.fromJson(item))
            .toList());
  }
}

class Filme {
  final String titulo;
  final String ano;
  final String diretor;
  final String sinopse;
  final String capa;
  final String site;
  final String siteElenco;
  final List<Ator> elenco;
  final List<Secao> secoes;

  Filme(
      {required this.titulo,
      required this.ano,
      required this.diretor,
      required this.sinopse,
      required this.capa,
      required this.site,
      required this.siteElenco,
      required this.elenco,
      required this.secoes});

  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
        titulo: json['titulo'],
        ano: json['ano'],
        diretor: json['diretor'],
        sinopse: json['sinopse'],
        capa: json['capa'],
        site: json['site'],
        siteElenco: json['siteElenco'],
        elenco: (json['elenco'] as List)
            .map((item) => Ator.fromJson(item))
            .toList(),
        secoes: (json['secoes'] as List)
            .map((item) => Secao.fromJson(item))
            .toList());
  }
}
