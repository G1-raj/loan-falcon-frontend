import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:loanmanagmentapp/components/collapsable/collapsable.dart';
import 'package:loanmanagmentapp/components/input_form_field/input_form_field.dart';
import 'package:loanmanagmentapp/constants.dart';
import 'package:loanmanagmentapp/screens/useronboaard/constants/onboarding_constants.dart';
import 'package:loanmanagmentapp/provider/client_provider.dart';





class UseronboardingScreen extends ConsumerStatefulWidget {
  const UseronboardingScreen({super.key});

  @override
  ConsumerState<UseronboardingScreen> createState() => _UseronboardingScreenState();
}

class _UseronboardingScreenState extends ConsumerState<UseronboardingScreen> {


  Future<void> _selectedDate(BuildContext context) async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101), 
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; 
      });
    }
  }

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = image.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loanAmountController.addListener(calculateEMI);
    loanTenureController.addListener(calculateEMI);
    interestController.addListener(calculateEMI);
  }


  void pickContact() async {
    final contactPicker = FlutterNativeContactPicker();
    final contact = await contactPicker.selectContact();
    if (contact != null) {
      nameController.text = contact.fullName!;
      phoneNoController.text = contact.phoneNumbers?.isNotEmpty == true ? contact.phoneNumbers!.first : '';
    }
  }


  

  void  calculateEMI() {

    if (loanAmountController.text.isEmpty || loanTenureController.text.isEmpty || interestController.text.isEmpty) {
      setState(() {
        monthlyEmiController.text = '0.0';
      });

      return;
    }

    final loanAmount = double.parse(loanAmountController.text);
    final loanTenure = double.parse(loanTenureController.text);
    final interest = double.parse(interestController.text);

    final interestAmout = loanAmount * (interest / 100);
    final amountPayble = interestAmout + loanAmount;


    setState(() {
      monthlyEmiController.text = (amountPayble / loanTenure).toStringAsFixed(2);
    });

  }


  @override
  Widget build(BuildContext context) {
    final dataNotifier = ref.watch(dataNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [

                const SizedBox(height: 35,),
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    child: profileImage == null
                        ? const Icon(Icons.person, size: 60,)
                        :  ClipOval(
                              child: Image.file(
                                        File(profileImage!),
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                  ),
                ),
            
                const SizedBox(height: 25,),
            
                InputFormField(title: "Name", controller: nameController, fieldIcon: const Icon(Icons.person),),
        
        
                InputFormField(title: "Email", controller: emailController, fieldIcon: const Icon(Icons.email), 
                  validator: validateEmail),
        
                GestureDetector(
                  onDoubleTap: pickContact, 
                    child: InputFormField(
                      title: "Mobile No", 
                      controller: phoneNoController, 
                      fieldIcon: 
                        const Icon(Icons.phone),
                        validator: validatePhoneNo,
                    )
                  ),

                  CollapsibleForm(
                    children: [
                        InputFormField(title: "Address", controller: addressController, fieldIcon: const Icon(Icons.location_on),),

                        InputFormField(title: "City", controller: cityController, fieldIcon: const Icon(Icons.location_city),),

                        InputFormField(title: "State", controller: stateController, fieldIcon: const Icon(Icons.location_city),),

                        InputFormField(title: "Pincode", controller: pincodeController, fieldIcon: const Icon(Icons.location_city),),
                    ],
                  ),



                InputFormField(title: "PAN No", controller: panNoController, fieldIcon: const Icon(Icons.credit_card), validator: validatePan,
                  onChanged: (value) {
                    panNoController.text = value.toUpperCase();
                  },),
        
                InputFormField(title: "Aadhar No", controller: aadharNoController, fieldIcon: const Icon(Icons.credit_card), validator: validateAdhaar,),
        
                InputFormField(title: "Loan amount", controller: loanAmountController, fieldIcon: const Icon(Icons.monetization_on),),

                InputFormField(title: "Loan tenure in months", controller: loanTenureController, fieldIcon: const Icon(Icons.calendar_today),),

                InputFormField(title: "Interest", controller: interestController, fieldIcon: const Icon(Icons.monetization_on),),

                Row(
                  children: [
                    Expanded(
                      child: InputFormField(title: "Date", controller: dateController, fieldIcon: const Icon(Icons.date_range), readOnly: true,),
                    ),
                    IconButton(
                      onPressed: () {
                        _selectedDate(context);
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
        
              ],
            ),
          ),
        ),
      ),


      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 60,
          decoration: BoxDecoration(
            color: appTheme,
            borderRadius: BorderRadius.circular(10),
          ),
        
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: monthlyEmiController.text.isEmpty ? const Text("") :  Column (
                children: [
                  const Text("Your monthly emi is:", style:TextStyle(color: Colors.white, fontSize: 12),),
                  Text(monthlyEmiController.text, style: const TextStyle(color: Colors.white, fontSize: 18),),
                ],
               ),
             ),

              ElevatedButton(
                onPressed: () {
                  onSave(dataNotifier);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
