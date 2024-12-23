import 'package:flutter/material.dart';
import 'package:loanmanagmentapp/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/provider/auth_provider.dart';
import 'package:loanmanagmentapp/screens/detail/detail_screen.dart';
import 'package:loanmanagmentapp/screens/useronboaard/useronboarding_screen.dart';
import 'package:loanmanagmentapp/provider/get_details_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final clientState = ref.watch(fetchDataNotifierProvider);
    final clientNotifier = ref.read(fetchDataNotifierProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final clients = clientNotifier.clients;
    final userName = clientNotifier.name;
    final userEmail = clientNotifier.email;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clientNotifier.clients.isEmpty) {
        clientNotifier.fetchClientsId();
        clientNotifier.getUserDetails();
      }

        if (clientNotifier.name.isEmpty || clientNotifier.email.isEmpty) {
          clientNotifier.getUserDetails();
        }

    });
    
    return Scaffold(

      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await authNotifier.logOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: clientState == FetchState.loading ? const Center(child: CircularProgressIndicator(),) 
            : clientState == FetchState.error ? const Center(child: Text("Error in fetching data"),) :
       Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () {
                return ref.read(fetchDataNotifierProvider.notifier).getUserDetails();
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 200,
                child: Card(
                  color: appTheme,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: CircleAvatar(radius: 40,child: Icon(Icons.person),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        //child: Text(userName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                        child: clientState == FetchState.loading
                                ? const CircularProgressIndicator()
                                : Text(
                                    userName.isNotEmpty ? userName : "Loading...",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      ),
                      // Text(userEmail, style: const TextStyle(color: Colors.white),),
                      Text(
                        userEmail.isNotEmpty ? userEmail : "Loading...",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

      clients.isEmpty 
        ? const Center(child: Text("No clients available"))
        : Expanded(
              child: FutureBuilder<Map<String, Map<String, String>>>(
                future: _fetchAllClientData(clientNotifier, clients),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                      return const Center(child: Text("Error fetching client data"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No clients available"));
                  }
       
                  final clientDetails = snapshot.data!;
       
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(fetchDataNotifierProvider.notifier).fetchClientsId(); 
                    },
                    child: ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                    
                        final id = clients[index];
                        final client = clientDetails[clients[index]]!;
                        final profilePicUrl = client["profileImage"] ?? "";
                              
                    
                        return Card(
                          child: GestureDetector(
                            onTap: ()  {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(clientId: id,)));
                            },
                            child: ListTile(
                              title: Text(clientDetails[clients[index]]!["name"]!),
                              leading: CircleAvatar(
                                // ignore: unnecessary_null_comparison
                                child: profilePicUrl.isEmpty ? const Icon(Icons.person) : Image(image: NetworkImage(profilePicUrl), fit: BoxFit.cover,),
                              ),
                              subtitle: Text(clientDetails[clients[index]]!["email"]!),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              ),
            )
          ],
        ),
             ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) {
              return const UseronboardingScreen();
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            }
           ),
          );
        },
        backgroundColor: appTheme,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }


Future<Map<String, Map<String, String>>> _fetchAllClientData(
  FetchNotifier clientNotifier, List<String> clients) async {
  final Map<String, Map<String, String>> clientData = {};

    for (final id in clients) {
      try {
        await clientNotifier.fetchData(id);

        clientData[id] = {
          "name": clientNotifier.clientName,
          "email": clientNotifier.clientEmail,
          "profileImage": clientNotifier.imageUrl,
        };
      } catch (e) {
        throw Exception("Error fetching client data");
      }
    }

    return clientData;
  }

}



