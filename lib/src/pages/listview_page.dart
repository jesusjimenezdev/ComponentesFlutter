import 'dart:async';

import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {

  ScrollController _scrollController = new ScrollController();
  List<int> _listaNumeros = new List();
  int _ultimoItem = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    agregarDiezImagenes();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        //agregarDiezImagenes();
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView Page'),
      ),
      body: Stack(
        children: <Widget>[
          _crearLista(),
          _crearLogin(),
        ],
      ) 
    );
  }

  Widget _crearLista() {
    return RefreshIndicator(
        onRefresh: obtenerPaginaUno,
        child: ListView.builder(
        controller: _scrollController,
        itemCount: _listaNumeros.length,
        itemBuilder: (BuildContext context, int index) {
          final imagen = _listaNumeros[index];
          return FadeInImage(
            image: NetworkImage('https://picsum.photos/500/300/?$imagen'),
            placeholder: AssetImage('assets/imagen.gif'),
          );
        },
      ),
    );
  }

  Future<Null> obtenerPaginaUno() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      _listaNumeros.clear();
      _ultimoItem++;
      agregarDiezImagenes();
    });

    return Future.delayed(duration);
  }

  void agregarDiezImagenes() {
    for (var i = 0; i < 10; i++) {
      _ultimoItem++;
      _listaNumeros.add(_ultimoItem);
    }
    setState(() {
       
    });
  }

  Future<Null> fetchData() async {
    _isLoading = true;
    setState(() {
      final duration = new Duration(seconds: 2);
      return new Timer(duration, respuestaHTTP);  
    });
  }

  void respuestaHTTP() {
    _isLoading = false;
    _scrollController.animateTo(
      _scrollController.position.pixels + 100, 
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 250)
    );
    agregarDiezImagenes();
  }

  Widget _crearLogin() {
    if(_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator()
            ],
          ),
          SizedBox(height: 25.0)
        ],
      ); 
    } else {
      return Container();
    }
  }
}