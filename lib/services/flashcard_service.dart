import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/flashcard.dart';

class FlashCardService {
  Future<List<FlashCard>> cargarCartasDesdeJson() async {
    final String respuesta = await rootBundle.loadString('assets/flashcards.json');
    final List<dynamic> datos = json.decode(respuesta);

    return datos.map((item) => FlashCard.fromJson(item)).toList();
  }
}
