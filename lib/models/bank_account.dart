class BankAccount {
  late int accountNumber;
  final String holderName;
  final double balance;
  String? bankBranch;
  bool _isInitialized=false;
BankAccount({required this.holderName,this.balance=0.0,this.bankBranch});

 void initializeaccountNumber(int  number)
 {accountNumber =number ; _isInitialized=true;}
 bool isAccountInitialized(){
  return _isInitialized;
 } 

}