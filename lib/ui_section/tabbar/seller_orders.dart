import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/order_repository.dart';
import 'package:imart/api/payment_repository.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/models/all_order_response_model.dart';
import 'package:imart/models/all_payments_response_model.dart';
import 'package:imart/ui_section/drawer/seller_drawer.dart';
import 'package:imart/ui_section/tabbar/order_details.dart';

class SellerOrderPage extends StatefulWidget {
  @override
  _SellerOrderPageState createState() => _SellerOrderPageState();
}

class _SellerOrderPageState extends State<SellerOrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController pageController = PageController();
  int currentIndex = 0;
  List<GetOrderResponseData>? getOrderResponseData = [];
  List<AllPaymentsResponseData>? allPaymentsResponseData = [];
  List<String>? paymentDoneOrderIds = [];
  List<GetOrderResponseData>? getOrderResponseDelivered = [];
  List<GetOrderResponseData>? getOrderResponseOrdered = [];
  List<GetOrderResponseData>? getOrderResponseShipped = [];

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  getOrders() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetOrderResponseModel getOrderResponseModel =
          await orderRepository().allOrders();

      AllPaymentsResponseModel allPaymentsResponseModel =
          await PaymentRepository().getAllPayments();

      await EasyLoading.dismiss();

      if (getOrderResponseModel.status == 1) {
        getOrderResponseData = getOrderResponseModel.data;
        ordersDivisionStatus(getOrderResponseModel.data);
      } else {
        print("No orders fetched");
      }

      if (allPaymentsResponseModel.status == 1) {
        allPaymentsResponseData = allPaymentsResponseModel.data;
        paymentDoneOrderIds?.clear();
        for (var i = 0; i < allPaymentsResponseData!.length; i++) {
          paymentDoneOrderIds?.add(allPaymentsResponseData?[i].orderId ?? "");
        }
      } else {
        print("No Payments fetched");
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  ordersDivisionStatus(List<GetOrderResponseData>? getOrderResponseData) {
    getOrderResponseDelivered?.clear();
    getOrderResponseShipped?.clear();
    getOrderResponseOrdered?.clear();
    for (int i = 0; i < getOrderResponseData!.length; i++) {
      if (getOrderResponseData[i].status == "delivered") {
        getOrderResponseDelivered?.add(getOrderResponseData[i]);
      } else if (getOrderResponseData[i].status == "shipped") {
        getOrderResponseShipped?.add(getOrderResponseData[i]);
      } else if (getOrderResponseData[i].status == "ordered") {
        getOrderResponseOrdered?.add(getOrderResponseData[i]);
      }
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
                    'My Orders',
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
            tabBar(),
            _pageView(),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget tabBar() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              currentIndex = 0;
              pageController.jumpToPage(0);
              setState(() {});
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 4.0,
                    color: currentIndex == 0
                        ? MyTheme.accent_color
                        : Colors.transparent,
                  ),
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'Ordered',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        currentIndex == 0 ? MyTheme.accent_color : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              currentIndex = 1;
              pageController.jumpToPage(1); // for regular jump
              setState(() {});
            },
            child: Container(
              height: 50,
              // width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 4.0,
                    color: currentIndex == 1
                        ? MyTheme.accent_color
                        : Colors.transparent,
                  ),
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'Shipped',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        currentIndex == 1 ? MyTheme.accent_color : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              currentIndex = 2;
              pageController.jumpToPage(2);
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 4.0,
                    color: currentIndex == 2
                        ? MyTheme.accent_color
                        : Colors.transparent,
                  ),
                ),
                color: Colors.white,
              ),
              height: 50,
              // width: MediaQuery.of(context).size.width * 0.5,
              child: Center(
                child: Text(
                  'Delivered',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        currentIndex == 2 ? MyTheme.accent_color : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pageView() {
    return Expanded(
      child: PageView(
        controller: pageController,
        onPageChanged: (t) {
          setState(() {
            currentIndex = t;
          });
        },
        // physics: NeverScrollableScrollPhysics(),
        children: [
          getOrderResponseOrdered?.length != 0
              ? orderedOrderListWidget()
              : const Center(
                  child: Text("No Orders"),
                ),
          getOrderResponseShipped?.length != 0
              ? shippedOrderListWidget()
              : const Center(
                  child: Text("No Orders"),
                ),
          getOrderResponseDelivered?.length != 0
              ? completedOrderListWidget()
              : const Center(
                  child: Text("No Orders"),
                ),
        ],
      ),
    );
  }

  Widget orderedOrderListWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: getOrderResponseOrdered?.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => OrderDetailPage(
                    getOrderResponseData: getOrderResponseOrdered?[index],
                  ),
                ),
              );
            },
            child: Container(
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
                    width: 80,
                    height: 90,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/snacks.png'),
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
                          getOrderResponseOrdered?[index].name ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Price: ${getOrderResponseOrdered?[index].grandTotal}  ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Order Date: ${getOrderResponseOrdered?[index].date}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'Order Id: ${getOrderResponseOrdered?[index].id}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              // decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var res =
                                    await orderRepository().orderedtoShipped(
                                  getOrderResponseOrdered?[index].id ?? "",
                                );
                                if (res['status'] == 1) {
                                  EasyLoading.showToast(res['message']);
                                  getOrders();
                                } else {
                                  EasyLoading.showToast(res['message']);
                                  print("Not Updated");
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: MyTheme.accent_color,
                                ),
                                child: const Text(
                                  'Shipped',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: MyTheme.accent_color,
                                ),
                              ),
                              child: Text(
                                'Cancelled',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget shippedOrderListWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: getOrderResponseShipped?.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => OrderDetailPage(
                    getOrderResponseData: getOrderResponseShipped?[index],
                  ),
                ),
              );
            },
            child: Container(
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
                    width: 80,
                    height: 90,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/snacks.png'),
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
                          getOrderResponseShipped?[index].name ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Price: ${getOrderResponseShipped?[index].grandTotal}  ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Order Date: ${getOrderResponseShipped?[index].date}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'Order Id: ${getOrderResponseShipped?[index].id}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status: ${getOrderResponseShipped?[index].status}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var res = await orderRepository()
                                      .shippedToDelivered(
                                    getOrderResponseShipped?[index].id ?? "",
                                  );
                                  if (res['status'] == 1) {
                                    EasyLoading.showToast(res['message']);
                                    getOrders();
                                  } else {
                                    EasyLoading.showToast(res['message']);
                                    print("Not Updated");
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: MyTheme.accent_color,
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Delived ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget completedOrderListWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: getOrderResponseDelivered?.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          bool paymentDone = false;
          if (paymentDoneOrderIds!
              .contains(getOrderResponseDelivered?[index].id)) {
            paymentDone = true;
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => OrderDetailPage(
                    getOrderResponseData: getOrderResponseDelivered?[index],
                  ),
                ),
              );
            },
            child: Container(
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
                    width: 80,
                    height: 90,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/snacks.png'),
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
                          "${getOrderResponseDelivered?[index].name}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Price: ${getOrderResponseDelivered?[index].grandTotal}  ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Order Date: ${getOrderResponseDelivered?[index].date}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'Order Id: ${getOrderResponseDelivered?[index].id}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Deliverd Date: ${getOrderResponseDelivered?[index].delivereddate}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status: ${getOrderResponseDelivered?[index].status}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (paymentDone == false) {
                                    try {
                                      // await EasyLoading.show(
                                      //   status: 'loading...',
                                      //   maskType: EasyLoadingMaskType.black,
                                      // );
                                      var order =
                                          getOrderResponseDelivered?[index];
                                      var res =
                                          await PaymentRepository().addPayment(
                                        order?.userId ?? "",
                                        order?.id ?? "",
                                        order?.name ?? "",
                                        order?.grandTotal ?? "",
                                        order?.paymentMethod ?? "",
                                        order?.mobile ?? "0",
                                      );
                                      EasyLoading.dismiss();
                                      if (res['status'] == 1) {
                                        EasyLoading.showToast("Payment Done");
                                        getOrders();
                                      } else {
                                        EasyLoading.showToast("Payment Failed");
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                },
                                child: paymentDone == false
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: MyTheme.accent_color,
                                        ),
                                        child: const Row(
                                          children: [
                                            Text(
                                              'Payment ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: MyTheme.accent_color,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Payment ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: MyTheme.accent_color,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Icon(
                                              Icons.thumb_up,
                                              size: 14,
                                              color: MyTheme.accent_color,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
