import 'package:flutter/material.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ContactScreen extends StatefulWidget {
  Contact? contact;

  //construtor que inicia o contato.
  //Entre chaves porque é opcional.
  ContactScreen({this.contact});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Contact? _editedContact;
  bool _userEdited = false;

  //para garantir o foco no nome
  final _nomeFocus = FocusNode();

  //controladores
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //acessando o contato definido no widget(ContactScreen)
    //mostrar se ela for privada
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = widget.contact;

      nameController.text = _editedContact!.name;
      emailController.text = _editedContact!.email;
      phoneController.text = _editedContact!.phone;
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Abandonar alteração?"),
              content: const Text("Os dados serão perdidos."),
              actions: <Widget>[
                TextButton(
                    child: const Text("cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                TextButton(
                  child: const Text("sim"),
                  onPressed: () {
                    //desempilha 2x
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    //com popup de confirmação
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.lightBlue, title: Text(_editedContact!.name), centerTitle: true),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact!.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact!.img != ''
                                ? FileImage(File(_editedContact!.img))
                                : const AssetImage('assets/images/person.png') as ImageProvider))),
                onTap: () {
                  ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50).then((file) {
                    if (file == null) {
                      return;
                    } else {
                      setState(() {
                        _editedContact!.img = file.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                controller: nameController,
                focusNode: _nomeFocus,
                decoration: const InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact!.name = text;
                  });
                },
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "E-mail"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact!.email = text;
                },
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact!.phone = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
