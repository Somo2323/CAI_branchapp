import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '7-11 Branches',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BranchList(),
    );
  }
}

class Branch {
  final int id;
  final String name;
  bool hasIssue;

  Branch({required this.id, required this.name, this.hasIssue = false});
}

class BranchList extends StatefulWidget {
  @override
  _BranchListState createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
  List<Branch> branches = [
    Branch(id: 1, name: 'Branch 1', hasIssue: true),
    Branch(id: 2, name: 'Branch 2', hasIssue: false),
    Branch(id: 3, name: 'Branch 3', hasIssue: false),
    Branch(id: 4, name: 'Branch 4', hasIssue: true),
  ];

  void resolveIssue(int branchId) {
    setState(() {
      branches.firstWhere((branch) => branch.id == branchId).hasIssue = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    branches.sort((a, b) {
      if (a.hasIssue == b.hasIssue) {
        return a.id.compareTo(b.id);
      }
      return a.hasIssue ? -1 : 1;
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('assets/ce00aca9cb774dbb1c13a664bdfb90da.png', width: 110),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(''),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SearchBar(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                return BranchCard(
                  branch: branch,
                  onQuickAccess: () {
                    if (branch.hasIssue) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ErrorDetailPage(
                            productCode: '9400003',
                            dateOfAlert: '24/10/2567',
                            branchId: branch.id,
                            branchName: branch.name,
                            docDate: '23/7/2567',
                            docNo: '0613800346',
                            transType: '1',
                            cvCode: '00101',
                            vendorName: 'Cash Purchases',
                            recType: 'CP',
                            refDocNo: '6',
                            refDocDate: '31/7/2567',
                            c2: '720.00',
                            onSeeFeedback: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackScreen(
                                    productCode: '9400003',
                                    dateOfAlert: 'dd/mm/yy',
                                    branchId: branch.id, 
                                    branchName: branch.name,
                                    mistakeOccurred: true, 
                                    finalFeedback: 'The computer got stuck key on number 0',
                                    resolveIssue: resolveIssue, 
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search reported history',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

class BranchCard extends StatelessWidget {
  final Branch branch;
  final VoidCallback onQuickAccess;

  BranchCard({required this.branch, required this.onQuickAccess});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: branch.hasIssue ? Colors.red : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              'assets/pngegg.png',
              height: 80,
            ),
            Text(
              branch.name,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            if (branch.hasIssue)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: onQuickAccess,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.access_alarm, color: Colors.red),
                      SizedBox(width: 8
                      ),
                      Text('quick access', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ErrorDetailPage extends StatelessWidget {
  final String productCode;
  final String dateOfAlert;
  final int branchId;
  final String branchName;
  final String docDate;
  final String docNo;
  final String transType;
  final String cvCode;
  final String vendorName;
  final String recType;
  final String refDocNo;
  final String refDocDate;
  final String c2;
  final VoidCallback onSeeFeedback;

  ErrorDetailPage({
    required this.productCode,
    required this.dateOfAlert,
    required this.branchId,
    required this.branchName,
    required this.docDate,
    required this.docNo,
    required this.transType,
    required this.cvCode,
    required this.vendorName,
    required this.recType,
    required this.refDocNo,
    required this.refDocDate,
    required this.c2,
    required this.onSeeFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Detail'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.red,
              child: ListTile(
                title: Text(productCode, style: TextStyle(color: Colors.white)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date of alert: $dateOfAlert',
                        style: TextStyle(color: Colors.white)),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white),
                        SizedBox(width: 5),
                        Text('This Product Data got an error',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailText('BRANCH', branchName),
            _buildDetailText('PRODUCT_CODE', productCode),
            _buildDetailText('DOC_DATE', docDate),
            _buildDetailText('DOC_NO', docNo),
            _buildDetailText('TRANS_TYPE', transType),
            _buildDetailText('CV_CODE', cvCode),
            _buildDetailText('VENDOR_NAME', vendorName),
            _buildDetailText('REC_TYPE', recType),
            _buildDetailText('REF_DOC_NO', refDocNo),
            _buildDetailText('REF_DOC_DATE', refDocDate),
            _buildDetailText('C2', c2),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onSeeFeedback,
                child: Text('See Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  final String productCode;
  final String dateOfAlert;
  final int branchId;
  final String branchName;
  final bool mistakeOccurred;
  final String finalFeedback;
  final Function(int) resolveIssue;

  FeedbackScreen({
    required this.productCode,
    required this.dateOfAlert,
    required this.branchId,
    required this.branchName,
    required this.mistakeOccurred,
    required this.finalFeedback,
    required this.resolveIssue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback from retail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.red,
              child: ListTile(
                title: Text(productCode, style: TextStyle(color: Colors.white)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date of alert: $dateOfAlert',
                        style: TextStyle(color: Colors.white)),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white),
                        SizedBox(width: 5),
                        Text('This Product Data got an error',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailText('BRANCH', branchName),
            _buildDetailText('PRODUCT_CODE', productCode),
            _buildDetailText('Does this mistake actually occur?',
                mistakeOccurred ? 'YES' : 'NO'),
            SizedBox(height: 20),
            _buildDetailText('Final feedback:', finalFeedback),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  resolveIssue(branchId);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Clear'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}