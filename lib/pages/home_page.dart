// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //accessing the firestoreservice for contact details
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phnumController = TextEditingController();
  final TextEditingController emailController = TextEditingController();


  // box to register details
  void openRegisterDetailsBox({String? docID}){
    showGeneralDialog(
      context: context, 
      barrierDismissible: false,
      // barrierColor: Colors.blue,
      // barrierLabel: ' Full Screen Dialog',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          body: Container(
            color: Colors.grey[400],
            child: Center(
              child: Column(
                children: [
                  // Name textfield
                  SizedBox(height: 150,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
          
                  // Phone number textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: phnumController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
          
                  // Email textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
          
                  // Register Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: (){
                      if (docID == null){
                        firestoreService.addContact(
                        nameController.text.trim(), phnumController.text.trim(), emailController.text.trim());
                      }else{
                        firestoreService.updateContact(docID, nameController.text.trim(), phnumController.text.trim(), emailController.text.trim());
                      }
                      firestoreService.addContact(
                        nameController.text.trim(), phnumController.text.trim(), emailController.text.trim());
                      nameController.clear();
                      phnumController.clear();
                      emailController.clear();
                      // close box
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Add',
                        style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ],
              )
            ),
          ),
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contacts List App',
          style: GoogleFonts.chakraPetch(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {openRegisterDetailsBox();},
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getContactStream(),
        builder: (context, snapshot) {
          // if we have details, get the details or docs
          if (snapshot.hasData) {
            List contactsList = snapshot.data!.docs;
            // display the details as list
            return ListView.builder(
              itemCount: contactsList.length,
              itemBuilder: (
                (context, index) {
                  DocumentSnapshot document = contactsList[index];
                  String docID = document.id;
      
                  // get details from each doc
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String nameText = data['name'];
                  String phnumText = data['phone_number'];
                  String emailText = data['email'];
      
                  // display as list tile
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(

                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        tileColor: Colors.grey[200],
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[400],
                          child: Text(
                            data['name'][0],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(nameText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(phnumText, style: GoogleFonts.poppins(),),
                            SizedBox(width: 7,),
                            Text(emailText, style: GoogleFonts.poppins(),),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: (){
                                openRegisterDetailsBox();
                              }, 
                              icon: Icon(Icons.settings)
                            ),
                            IconButton(
                              onPressed: (){
                                firestoreService.deleteContact(docID);
                              }, 
                              icon: Icon(Icons.delete)
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
      
                }
              ),
            );
          }else{
            return const Text("No Contact Details...");
          }
        },
      ),
    );
  }
}