class AgentInfo {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String loanDisbursed;
  final int noOfClients;

  AgentInfo(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.loanDisbursed,
      required this.noOfClients});
}

List<AgentInfo> agent = [
  AgentInfo(
      id: 1,
      name: "John Doe",
      email: "jhonexample@123",
      phone: "+91 1234567890",
      loanDisbursed: "100000",
      noOfClients: 12
  ),
];


class AgentData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String state;
  final String pincode;
  final double loanAmount;
  final int emiDurationInMonths;
  final double emiAmount;
  final String loanStartDate;

  AgentData(
    {
      required this.id,
      required this.name, 
      required this.email, 
      required this.phone, 
      required this.address, 
      required this.state,
      required this.pincode,
      required this.loanAmount, 
      required this.emiDurationInMonths,
      this.emiAmount = 0.0,
      this.loanStartDate = "01-01-2021"
    }
  );
  
}

List<AgentData> agentData = [
  AgentData(
    id: 1,
    name: "John Doe",
    email: "jhonexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),
  AgentData(
    id: 2,
    name: "Jane Doe",
    email: "janeexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 3,
    name: "John Doe",
    email: "jhonexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 4,
    name: "Jane Doe",
    email: "janeexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 5,
    name: "John Doe",
    email: "jhonexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 6,
    name: "Jane Doe",
    email: "janeexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 7,
    name: "John Doe",
    email: "jhonexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 8,
    name: "Jane Doe",
    email: "janeexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 9,
    name: "John Doe",
    email: "jhonexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

  AgentData(
    id: 10,
    name: "Jane Doe",
    email: "janeexample@123",
    phone: "+91 1234567890",
    address: "123, Example Street, Example City, Example State, Example Country",
    state: "Example State",
    pincode: "123456",
    loanAmount: 100000,
    emiDurationInMonths: 12
  ),

 
  
];