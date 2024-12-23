import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/provider/get_details_provider.dart';

final currentStatusProvider = StateProvider.family<bool, int>((ref, index) => false);

class LoanCard extends ConsumerWidget {
  final String clientId;
  final double emiAmount;
  final String emiDate;
  final int index;
  final bool serverStatus;
  const LoanCard({super.key, required this.clientId, required this.emiAmount, required this.emiDate, required this.index,required  this.serverStatus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final emiStatusProvider = ref.watch(fetchDataNotifierProvider.notifier);
    final currentStatus = ref.watch(currentStatusProvider(index));

    ref.listen(currentStatusProvider(index), (previous, next) {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentStatus == false) {
        ref.read(currentStatusProvider(index).notifier).state = serverStatus;
      }
    });

    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 80,
        child: Card(
          child: ListView(
            children:  [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(radius: 30,child: Icon(Icons.person),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Emi Amount: RS. $emiAmount", style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                      Text("Emi Date: $emiDate", style: const TextStyle(color: Colors.black),),
                    ],
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: currentStatus ? Colors.green : Colors.red, 
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ref.read(currentStatusProvider(index).notifier).state = !currentStatus;

                        emiStatusProvider.updateEmiStatus(clientId, index, !currentStatus);
                      }, 
                      child: Text(currentStatus ? "Paid" : "Unpaid")
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class LoanCard extends StatefulWidget {
//   final double emiAmount;
//   final String emiDate;
//   bool paid;
//   LoanCard({super.key, required this.emiAmount, required this.emiDate, this.paid = false});

//   @override
//   State<LoanCard> createState() => _LoanCardState();
// }

// class _LoanCardState extends State<LoanCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.95,
//         height: 80,
//         child: Card(
//           child: ListView(
//             children:  [
//               Row(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: CircleAvatar(radius: 30,child: Icon(Icons.person),),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Emi Amount: RS. ${widget.emiAmount}", style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
//                       Text("Emi Date: ${widget.emiDate}", style: const TextStyle(color: Colors.black),),
//                     ],
//                   ),

//                   const Spacer(),

//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: widget.paid ? Colors.green : Colors.red, 
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           widget.paid = !widget.paid;
//                         });
//                       }, 
//                       child: Text(widget.paid ? "Paid" : "Unpaid")
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }