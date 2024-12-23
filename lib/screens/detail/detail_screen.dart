import 'package:flutter/material.dart';
import 'package:loanmanagmentapp/components/loancard/loan_card.dart';
import 'package:loanmanagmentapp/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/provider/get_details_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends ConsumerWidget {
  final String? clientId;
  const DetailScreen({super.key, required this.clientId});


  Future<void> _makePhoneCall(String phoneNo) async {
    try {

      final Uri launchUri = Uri(scheme: "tel", path: phoneNo);

      if(await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $phoneNo';
     }
      
    } catch (e) {
      throw 'Could not launch $phoneNo';
    }
  }


  Future<void> _messageClient(String phoneNo) async {
    try {

      final Uri launchUri = Uri(scheme: "sms", path: phoneNo);

      if(await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $phoneNo';
      }
      
    } catch (e) {
      throw 'Could not launch $phoneNo';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientDataProvider = ref.watch(fetchDataNotifierProvider.notifier);
    clientDataProvider.fetchEmi(clientId);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: clientDataProvider.fetchData(clientId),
          builder: (context, snapshot) {

            final clientImage = clientDataProvider.imageUrl;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error fetching data');
            } else {
              return Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.95,
                        height: 200,
                        child: Card(
                          color: appTheme,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: CircleAvatar(
                                  radius: 50, 
                                  backgroundImage: clientImage.isEmpty ? null : NetworkImage(clientImage),
                                  child: clientImage.isEmpty ? const Icon(Icons.person) : null,
                                ),
                                ),

                              const SizedBox(width: 10),

                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(clientDataProvider.clientName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                    Text(clientDataProvider.clientEmail, style: const TextStyle(color: Colors.white)),
                                    Text(clientDataProvider.clientPhone, style: const TextStyle(color: Colors.white)),
                                    Text("Loan Amount: RS.${clientDataProvider.loanAmount}", style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              )
                              
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: clientDataProvider.emiDates.length,
                      itemBuilder: (context, index) {
                        return LoanCard(clientId: clientId! ,emiAmount: clientDataProvider.emiAmount, emiDate: clientDataProvider.emiDates[index], index: index, serverStatus: clientDataProvider.emiStatus[index]);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: appTheme,
        child: Center(
          child: Row(
            children: [
              Builder(
                builder: (context) {
                  return Container(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.red,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _makePhoneCall(clientDataProvider.clientPhone);
                      },
                      child: const Icon(Icons.call, color: Colors.white),
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return Container(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.blue,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        _messageClient(clientDataProvider.clientPhone);
                      },
                      child: const Icon(Icons.message, color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}