import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';
import 'models/library_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADMD Lab 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ADMD Lab 2 - Dart & Null Safety'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Task I: Utilizatori
  late List<User> users;

  // Task II: Conturi Bancare
  late List<BankAccount> accounts;

  // Task III: Biblioteca
  final Library library = Library();

  @override
  void initState() {
    super.initState();

    // 1. Initalizare Utilizatori (Task I)
    final user1 = User(name: 'Ion', age: 32, email: 'ion@yahoo.com');
    final user2 = User(name: 'Elena'); // Optionals null
    final user3 = User(name: 'Razvan', email: 'razvan@yahoo.com');
    users = [user1, user2, user3];

    // 2. Initializare Conturi Bancare (Task II)
    BankAccount account1 = BankAccount(
      holderName: 'Ion',
      balance: 1500.0,
      bankBranch: 'Bucharest',
    );
    account1.initializeaccountNumber(1001);

    BankAccount acc2 = BankAccount(
      holderName: 'Elena',
      balance: 2500.50,
    );
    acc2.initializeaccountNumber(1002);

    BankAccount acc3 = BankAccount(
      holderName: 'Razvan',
    ); // Neinitializat intentionat

    accounts = [account1, acc2, acc3];

    // 3. Initializare Biblioteca (Task III)
    Book book1 = Book(
      title: 'Amintiri din copilarie',
      author: 'Ion Creanga',
      pagecount: 180,
      isbn: '978-1234567890',
      publishDate: DateTime(1892, 1, 1),
    );

    Magazine mag1 = Magazine(
      title: 'National Geographic',
      issueNumber: 204,
      publisher: 'NG Media',
      publishDate: DateTime(2024, 5, 15),
    );

    library.addItem(book1);
    library.addItem(mag1);

    // Testare Imprumut (borrowItem)
    library.borrowItem(book1, user1, DateTime(2026, 11, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECŢIUNEA 1: UTILIZATORI (Task I)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Task I: Users',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final u = users[index];
                return ListTile(
                  dense: true,
                  title: Text(u.name),
                  subtitle: Text(
                    'Age: ${u.getDisplayAge()} | Email: ${u.email ?? "Not provided"}',
                  ),
                );
              },
            ),
            const Divider(),

            // SECŢIUNEA 2: CONTURI BANCARE (Task II)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Task II: Bank Accounts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  dense: true,
                  title: Text(account.holderName),
                  subtitle: Text(
                    'Branch: ${account.bankBranch ?? "N/A"}\n'
                    '${account.isAccountInitialized() ? "Account #: ${account.accountNumber}" : "Account number not initialized!"}',
                  ),
                  trailing: Text('\$${account.balance}'),
                );
              },
            ),
            const Divider(),

            // SECŢIUNEA 3: BIBLIOTECĂ (Task III)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Task III: Library Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: library.items.length,
              itemBuilder: (context, index) {
                final LibraryItem item = library.items[index];
                final String itemType = item is Book ? 'Book' : 'Magazine';

                return ListTile(
                  dense: true,
                  title: Text('${item.title} ($itemType)'),
                  subtitle: Text(
                    'Author: ${item.author ?? "Not provided"}\n'
                    'Status: ${item.borrower != null ? "Borrowed by ${item.borrower!.name} (Due: ${item.dueDate.toString().split(' ')[0]})" : "Available"}',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}