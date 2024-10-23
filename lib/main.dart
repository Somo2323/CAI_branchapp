import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlertHomePage(),
    );
  }
}

class AlertHomePage extends StatefulWidget {
  @override
  _AlertHomePageState createState() => _AlertHomePageState();
}

class _AlertHomePageState extends State<AlertHomePage> {
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  TextEditingController _productCodeController = TextEditingController();

  // สมมติข้อมูลสินค้าเพิ่มเติม
  List<Map<String, dynamic>> products = [
    {
      'productCode': '9400000',
      'alertDate': '12/10/2024',
      'isError': true,
      'branch': '1',
      'docDate': '23/7/2567',
      'docNo': '0613800346',
      'transType': '1',
      'cvCode': '00101',
      'vendorName': 'Cash Purchases',
      'recType': 'CP',
      'refDocNo': '6',
      'refDocDate': '31/7/2567',
      'c2': '720.00'
    },
    {
      'productCode': '5001577',
      'alertDate': '10/10/2024',
      'isError': false,
      'branch': '2',
      'docDate': '12/10/2024',
      'docNo': '0613800345',
      'transType': '2',
      'cvCode': '00102',
      'vendorName': 'Credit Purchases',
      'recType': 'CP',
      'refDocNo': '7',
      'refDocDate': '11/10/2567',
      'c2': '500.00'
    },
    {
      'productCode': '9400001',
      'alertDate': '15/10/2024',
      'isError': true,
      'branch': '3',
      'docDate': '24/7/2567',
      'docNo': '0613800347',
      'transType': '1',
      'cvCode': '00103',
      'vendorName': 'Wholesale Purchases',
      'recType': 'CP',
      'refDocNo': '8',
      'refDocDate': '30/7/2567',
      'c2': '1000.00'
    },
    {
      'productCode': '9400002',
      'alertDate': '16/10/2024',
      'isError': false,
      'branch': '4',
      'docDate': '17/10/2567',
      'docNo': '0613800348',
      'transType': '3',
      'cvCode': '00104',
      'vendorName': 'Retail Purchases',
      'recType': 'CP',
      'refDocNo': '9',
      'refDocDate': '18/10/2567',
      'c2': '1500.00'
    },
    {
      'productCode': '9400003',
      'alertDate': '17/10/2024',
      'isError': true,
      'branch': '5',
      'docDate': '18/10/2567',
      'docNo': '0613800349',
      'transType': '2',
      'cvCode': '00105',
      'vendorName': 'Cash Purchases',
      'recType': 'CP',
      'refDocNo': '10',
      'refDocDate': '19/10/2567',
      'c2': '800.00'
    },
    {
      'productCode': '9400004',
      'alertDate': '18/10/2024',
      'isError': false,
      'branch': '6',
      'docDate': '19/10/2567',
      'docNo': '0613800350',
      'transType': '1',
      'cvCode': '00106',
      'vendorName': 'Credit Purchases',
      'recType': 'CP',
      'refDocNo': '11',
      'refDocDate': '20/10/2567',
      'c2': '400.00'
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    _sortProducts();
  }

  void _sortProducts() {
    setState(() {
      filteredProducts.sort((a, b) {
        if (a['isError'] && !b['isError']) return -1;
        if (!a['isError'] && b['isError']) return 1;

        // ถ้า isError เหมือนกัน ให้เรียงตามวันที่ alertDate (ล่าสุดก่อน)
        DateTime dateA = DateFormat('dd/MM/yyyy').parse(a['alertDate']);
        DateTime dateB = DateFormat('dd/MM/yyyy').parse(b['alertDate']);
        return dateB.compareTo(dateA);
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
        _filterProductsByDate(_dateController.text); // กรองสินค้าตามวันที่เลือก
      });
    }
  }

  void _filterProductsByDate(String selectedDate) {
    setState(() {
      filteredProducts = products
          .where((product) => product['alertDate'] == selectedDate)
          .toList();
      _sortProducts(); // จัดเรียงใหม่หลังการกรอง
    });
  }

  void _filterProducts(String searchCode) {
    setState(() {
      if (searchCode.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((product) =>
                product['productCode'].toString().contains(searchCode))
            .toList();
      }
      _sortProducts(); // จัดเรียงใหม่หลังการกรอง
    });

      void updateProduct(int index, Map<String, dynamic> updatedProduct) {
    setState(() {
      products[index] = updatedProduct; // Update the product at the given index
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ce00aca9cb774dbb1c13a664bdfb90da.png',
                width: 100),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.png'),
            ),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _productCodeController,
              decoration: InputDecoration(
                hintText: 'Search by Product Code',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                _filterProducts(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
                  isError: product['isError'],
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ErrorDetailPage(productData: product),
                      ),
                    );

                    if (result != null && result == 'updated') {
                      setState(() {
                        product['isError'] = false;
                      });
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

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isError;
  final VoidCallback onPressed;

  ProductCard(
      {required this.product, required this.isError, required this.onPressed});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isError = true;

  @override
  void initState() {
    super.initState();
    isError = widget.isError;
  }

  @override
  Widget build(BuildContext context) {
    bool nowstate = widget.product['isError'];
    return Card(
      color: nowstate ? Colors.red : Colors.white,
      child: ListTile(
        leading: isError
            ? Icon(Icons.error, color: Colors.white)
            : Icon(Icons.check_circle_outline, color: Colors.green),
        title: Text(widget.product['productCode']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date of alert: ${widget.product['alertDate']}'),
            if (isError)
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'This Product Data got an error',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ErrorDetailPage(productData: widget.product),
              ),
            );

            if (result != null && result == true) {
              setState(() {
                isError = false;
                widget.product['isError'] = false;
              });
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: isError ? Colors.red : Colors.white,
            backgroundColor: isError ? Colors.white : Colors.blue,
          ),
          child: Text('Details'),
        ),
      ),
    );
  }
}

class ErrorDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData;

  ErrorDetailPage({required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Detail'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: productData['isError'] ? Colors.red : Colors.green,
                child: ListTile(
                  title: Text(
                    productData['productCode'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date of alert: ${productData['alertDate']}',
                          style: TextStyle(color: Colors.white)),
                      if (productData['isError'])
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
              _buildNonEditableText('BRANCH', productData['branch']),
              _buildNonEditableText('PRODUCT_CODE', productData['productCode']),
              _buildNonEditableText('DOC_DATE', productData['docDate']),
              _buildNonEditableText('DOC_NO', productData['docNo']),
              _buildNonEditableText('TRANS_TYPE', productData['transType']),
              _buildNonEditableText('CV_CODE', productData['cvCode']),
              _buildNonEditableText('VENDOR_NAME', productData['vendorName']),
              _buildNonEditableText('REC_TYPE', productData['recType']),
              _buildNonEditableText('REF_DOC_NO', productData['refDocNo']),
              _buildNonEditableText('REF_DOC_DATE', productData['refDocDate']),
              _buildNonEditableText('C2', productData['c2']),
              SizedBox(height: 20),
              if (productData['isError']) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackPage(
                            productData: productData,
                            onFeedbackSubmit: (bool hasError) {
                              productData['isError'] = false;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlertHomePage(),
                                ),
                              ); // Pop the feedback page
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Feedback'),
                  ),
                ),
              ] else ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      productData['isError'] = false;
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlertHomePage(),
                                ),
                              );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Back'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNonEditableText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  final Map<String, dynamic> productData;
  final ValueChanged<bool> onFeedbackSubmit; // Callback for feedback

  FeedbackPage({required this.productData, required this.onFeedbackSubmit});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  bool isCheckedYes = false;
  bool isCheckedNo = false;
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color:
                    widget.productData['isError'] ? Colors.red : Colors.green,
                child: ListTile(
                  title: Text(
                    widget.productData['productCode'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date of alert: ${widget.productData['alertDate']}',
                          style: TextStyle(color: Colors.white)),
                      if (widget.productData['isError'])
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 5),
                            Text('This Product Data got an error',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      if (!widget.productData['isError'])
                        Text('No Error', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Does this mistake actually occur?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isCheckedYes,
                    onChanged: (value) {
                      setState(() {
                        isCheckedYes = value!;
                        isCheckedNo = false;
                      });
                    },
                  ),
                  Text('Yes'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isCheckedNo,
                    onChanged: (value) {
                      setState(() {
                        isCheckedNo = value!;
                        isCheckedYes = false;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (isCheckedYes) {
                   
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditingDetailPage(
                              productData: widget.productData),
                        ),
                      );
                    } else {
                      widget.productData['isError'] = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlertHomePage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditingDetailPage extends StatefulWidget {
  final Map<String, dynamic> productData;

  EditingDetailPage({required this.productData});

  @override
  _EditingDetailPageState createState() => _EditingDetailPageState();
}

class _EditingDetailPageState extends State<EditingDetailPage> {
  late TextEditingController docNoController;
  late TextEditingController transTypeController;
  late TextEditingController cvCodeController;
  late TextEditingController vendorNameController;
  late TextEditingController recTypeController;
  late TextEditingController refDocNoController;
  late TextEditingController refDocDateController;
  late TextEditingController c2Controller;

  late Map<String, String> initialValues;

  @override
  void initState() {
    super.initState();

    initialValues = {
      'DOC_NO': widget.productData['docNo'],
      'TRANS_TYPE': widget.productData['transType'],
      'CV_CODE': widget.productData['cvCode'],
      'VENDOR_NAME': widget.productData['vendorName'],
      'REC_TYPE': widget.productData['recType'],
      'REF_DOC_NO': widget.productData['refDocNo'],
      'REF_DOC_DATE': widget.productData['refDocDate'],
      'C2': widget.productData['c2'],
    };

    docNoController = TextEditingController(text: initialValues['DOC_NO']);
    transTypeController =
        TextEditingController(text: initialValues['TRANS_TYPE']);
    cvCodeController = TextEditingController(text: initialValues['CV_CODE']);
    vendorNameController =
        TextEditingController(text: initialValues['VENDOR_NAME']);
    recTypeController = TextEditingController(text: initialValues['REC_TYPE']);
    refDocNoController =
        TextEditingController(text: initialValues['REF_DOC_NO']);
    refDocDateController =
        TextEditingController(text: initialValues['REF_DOC_DATE']);
    c2Controller = TextEditingController(text: initialValues['C2']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editing Detail'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color:
                    widget.productData['isError'] ? Colors.red : Colors.green,
                child: ListTile(
                  title: Text(
                    widget.productData['productCode'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of alert: ${widget.productData['alertDate']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      if (widget.productData['isError'])
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'This Product Data got an error',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      if (!widget.productData['isError'])
                        Text('No Error', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildEditableField('DOC_NO', docNoController),
              _buildEditableField('TRANS_TYPE', transTypeController),
              _buildEditableField('CV_CODE', cvCodeController),
              _buildEditableField('VENDOR_NAME', vendorNameController),
              _buildEditableField('REC_TYPE', recTypeController),
              _buildEditableField('REF_DOC_NO', refDocNoController),
              _buildEditableField('REF_DOC_DATE', refDocDateController),
              _buildEditableField('C2', c2Controller),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.productData['docNo'] = docNoController.text;
                    widget.productData['transType'] = transTypeController.text;
                    widget.productData['cvCode'] = cvCodeController.text;
                    widget.productData['vendorName'] =
                        vendorNameController.text;
                    widget.productData['recType'] = recTypeController.text;
                    widget.productData['refDocNo'] = refDocNoController.text;
                    widget.productData['refDocDate'] =
                        refDocDateController.text;
                    widget.productData['c2'] = c2Controller.text;

                    widget.productData['isError'] = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ErrorDetailPage(productData: widget.productData),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isFieldModified(label, controller.text)
                ? Colors.red
                : Colors.black,
          ),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[400]!,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  bool isFieldModified(String fieldName, String currentValue) {
    return initialValues[fieldName] != currentValue;
  }
}
