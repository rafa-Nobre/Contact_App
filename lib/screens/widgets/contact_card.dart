import 'package:flutter/material.dart';
import 'dart:io';

Widget contactCard(BuildContext context, int index, List<dynamic> contatos, Function showOptions) {
  return GestureDetector(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: contatos[index].img != ''
                        ? FileImage(File(contatos[index].img))
                        : const AssetImage("assets/images/person.png") as ImageProvider),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //se não existe nome, joga vazio
                  Text(
                    contatos[index].name,
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    contatos[index].email,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    contatos[index].phone,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      showOptions(context, index);
    },
  );
}
