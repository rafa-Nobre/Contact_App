import 'package:contact_app/screens/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/controller/contact_controller.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/screens/contact_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import './widgets/empty_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContactController controller = ContactController();
  List<Contact> contactList = [];

  @override
  void initState() {
    fetchContacts();
    super.initState();
  }

  void fetchContacts() {
    controller.getAllContact().then((list) {
      setState(() {
        contactList = list.cast<Contact>();
      });
    });
  }

  void _goToContact({Contact? contact}) async {
    Contact contatoRet =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen(contact: contact)));

    if (contatoRet.id == 0) {
      await controller.saveContact(contatoRet);
    } else {
      await controller.updateContact(contatoRet);
    }

    fetchContacts();
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      child: const Text("Ligar", style: TextStyle(color: Colors.lightBlue, fontSize: 20.0)),
                      onPressed: () {
                        launchUrl(Uri(path: "tel:${contactList[index].phone}"));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      child: const Text("Editar", style: TextStyle(color: Colors.lightBlue, fontSize: 20.0)),
                      onPressed: () {
                        Navigator.pop(context);
                        _goToContact(contact: contactList[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      child: const Text("Excluir", style: TextStyle(color: Colors.lightBlue, fontSize: 20.0)),
                      onPressed: () {
                        controller.deleteContact(contactList[index].id);
                        fetchContacts();
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: const Text(
          "Meus Contatos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: contactList.isEmpty
          ? emptyList(context)
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                return contactCard(context, index, contactList, _showOptions);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToContact(),
        tooltip: 'Novo Contato',
        backgroundColor: Colors.green[800],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
