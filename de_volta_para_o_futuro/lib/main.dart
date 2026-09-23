import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'modelos.dart';

void main() {
  runApp(const Aplicativo());
}

// O arquivo é lido uma vez. Seus dados viram objetos da classe Filme.
Future<Filme> carregarFilme() async {
  final texto = await rootBundle.loadString('assets/dados/filme.json');
  return Filme.fromJson(jsonDecode(texto));
}

Future<void> abrirLink(BuildContext context, String endereco) async {
  try {
    final abriu = await launchUrl(Uri.parse(endereco),
        mode: LaunchMode.externalApplication);
    if (!abriu) throw Exception('Não foi possível abrir o link.');
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Não foi possível abrir o site. Tente novamente.')),
    );
  }
}

class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'De Volta para o Futuro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFAE420F)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      home: const Carregamento(),
    );
  }
}

class Carregamento extends StatefulWidget {
  const Carregamento({super.key});

  @override
  State<Carregamento> createState() => _CarregamentoState();
}

class _CarregamentoState extends State<Carregamento> {
  late Future<Filme> dados;

  @override
  void initState() {
    super.initState();
    dados = carregarFilme();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Filme>(
      future: dados,
      builder: (context, resultado) {
        if (resultado.hasData) return TelaInicio(filme: resultado.data!);
        return Scaffold(
          body: Center(
            child: resultado.hasError
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('Não foi possível carregar os dados do filme.'),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            dados = carregarFilme();
                          });
                        },
                        child: const Text('Tentar novamente')),
                  ])
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class TelaInicio extends StatelessWidget {
  final Filme filme;
  const TelaInicio({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('De Volta para o Futuro')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Image.asset(filme.capa,
                    width: 90, semanticLabel: 'Cartaz do filme'),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(filme.titulo,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('Ano: ${filme.ano}'),
                    const SizedBox(height: 8),
                    Text('Diretor: ${filme.diretor}'),
                  ],
                )),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Sinopse',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(filme.sinopse,
              style: const TextStyle(fontSize: 16, height: 1.4)),
          const SizedBox(height: 24),
          const Text('Explorar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Wrap permite que os botões se acomodem em telas pequenas.
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 12,
            runSpacing: 16,
            children: filme.secoes.map((secao) {
              return SizedBox(
                width: 140,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (secao.id == 'elenco') {
                      // Navegação para a tela de elenco.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TelaElenco(filme: filme),
                          ));
                    } else {
                      // A seção escolhida é enviada como parâmetro.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TelaConteudo(secao: secao),
                          ));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      ClipOval(
                          child: Image.asset(secao.imagem,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              excludeFromSemantics: true)),
                      const SizedBox(height: 8),
                      Text(secao.titulo,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => abrirLink(context, filme.site),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Site oficial do filme'),
          ),
        ],
      ),
    );
  }
}

// A mesma classe monta Enredo, Detalhes ou Curiosidades usando o parâmetro.
class TelaConteudo extends StatelessWidget {
  final Secao secao;
  const TelaConteudo({super.key, required this.secao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(secao.titulo)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
              child: ClipOval(
                  child: Image.asset(secao.imagem,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      excludeFromSemantics: true))),
          const SizedBox(height: 20),
          ...secao.itens.map((item) => Card(
                color: const Color(0xFFFFF7EF),
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.titulo,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(item.texto,
                            style: const TextStyle(fontSize: 16, height: 1.5)),
                      ]),
                ),
              )),
        ],
      ),
    );
  }
}

class TelaElenco extends StatelessWidget {
  final Filme filme;
  const TelaElenco({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elenco')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...filme.elenco.map((ator) => Card(
                color: Colors.white,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(ator.imagem,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        excludeFromSemantics: true),
                  ),
                  title: Text(ator.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Papel: ${ator.personagem}\n${ator.tipoLink}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => abrirLink(context, ator.link),
                ),
              )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => abrirLink(context, filme.siteElenco),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Veja mais sobre o elenco'),
          ),
        ],
      ),
    );
  }
}
