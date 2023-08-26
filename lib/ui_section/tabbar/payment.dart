import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/payment_repository.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/models/all_payments_response_model.dart';
import 'package:imart/ui_section/drawer/seller_drawer.dart';

class Payment extends StatefulWidget {
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AllPaymentsResponseData>? allPaymentsResponseData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPayments();
  }

  void getPayments() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      AllPaymentsResponseModel response =
          await PaymentRepository().getAllPayments();
      await EasyLoading.dismiss();

      if (response.status == 1) {
        allPaymentsResponseData = response.data;
      } else {
        EasyLoading.showToast(response.message.toString());
      }
    } catch (e) {
      EasyLoading.showToast(e.toString());
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SellerDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: MyTheme.accent_color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        ImagePath.icDrawer,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Payments',
                    style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: 15),
            searchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getPayments();
                },
                child: allPaymentsResponseData?.length == 0
                    ? const SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text("Loading..."),
                            ),
                            SizedBox(height: 90),
                          ],
                        ),
                      )
                    : _searchController.text.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                paymentsList(),
                                const SizedBox(height: 90),
                              ],
                            ),
                          )
                        : paymentsList2(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(right: 20, left: 20, top: 15),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          setState(() {});
        },
        onSubmitted: (txt) {},
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Search Product',
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
          ),
          prefixIcon: Icon(Icons.search, color: MyTheme.accent_color),
          suffixIcon: Icon(Icons.mic, color: MyTheme.accent_color),
          contentPadding: const EdgeInsets.only(left: 10),
        ),
      ),
    );
  }

  Widget paymentsList() {
    return ListView.builder(
      itemCount: allPaymentsResponseData?.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (allPaymentsResponseData?.length == 0) {
          return const Center(
            child: Text("No payments"),
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 8),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 70,
                  height: 70,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/iceCream.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${allPaymentsResponseData?[index].name}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Date: ${allPaymentsResponseData?[index].paymentdate}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Process: ${allPaymentsResponseData?[index].paymentMethod}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Phone: ${allPaymentsResponseData?[index].mobile}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    '₹ ${allPaymentsResponseData?[index].grandTotal}',
                    style: TextStyle(
                      fontSize: 15,
                      color: MyTheme.accent_color,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget paymentsList2() {
    return ListView.builder(
      itemCount: allPaymentsResponseData?.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (allPaymentsResponseData?.length == 0) {
          return const Center(
            child: Text("No payments"),
          );
        } else {
          return (allPaymentsResponseData?[index].name!.toLowerCase() ?? '')
                  .contains(_searchController.text.toLowerCase())
              ? Container(
                  padding: const EdgeInsets.only(bottom: 10, top: 10, left: 8),
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]!),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 70,
                        height: 70,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/image/iceCream.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${allPaymentsResponseData?[index].name}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Date: ${allPaymentsResponseData?[index].paymentdate}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Process: ${allPaymentsResponseData?[index].paymentMethod}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Phone: ${allPaymentsResponseData?[index].mobile}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          '₹ ${allPaymentsResponseData?[index].grandTotal}',
                          style: TextStyle(
                            fontSize: 15,
                            color: MyTheme.accent_color,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink();
        }
      },
    );
  }
}
