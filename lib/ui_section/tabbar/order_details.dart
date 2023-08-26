import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/order_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:imart/models/address_detail_response_model.dart';
import 'package:imart/models/all_order_response_model.dart';
import 'package:imart/models/get_order_items_specific_order.dart';

// ignore: must_be_immutable
class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({this.getOrderResponseData});
  GetOrderResponseData? getOrderResponseData;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with TickerProviderStateMixin {
  AddressDetailResponseData? addressDetailResponseData;
  GetOrderItemsOfSpecificOrderData? orderedItems;

  @override
  void initState() {
    super.initState();
    getOrderAddressAndItems();
  }

  getOrderAddressAndItems() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      AddressDetailResponseModel responseModel = await orderRepository()
          .getSpecificAddress(id: widget.getOrderResponseData?.addressId);

      GetOrderItemsOfSpecificOrder response = await orderRepository()
          .orderItemsOfSpecificOrder(orderId: widget.getOrderResponseData?.id);

      await EasyLoading.dismiss();

      if (responseModel.status == 1) {
        print(responseModel.data?.address);
        addressDetailResponseData = responseModel.data;
        print(addressDetailResponseData?.address);
      } else {
        EasyLoading.showToast(responseModel.message.toString());
      }

      if (response.status == 1) {
        orderedItems = response.data;
      } else {
        EasyLoading.showToast(response.message.toString());
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.left_chevron,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Order detail',
                    style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Order id: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${widget.getOrderResponseData?.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Payment Mode: ${widget.getOrderResponseData?.paymentMethod}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Divider(color: Colors.grey),
                      const Text(
                        'Product Detail',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.grey),
                                ),
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/image/apple.jpg'),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sold to: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        '${widget.getOrderResponseData?.name}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Order date ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        '${widget.getOrderResponseData?.date}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        '${widget.getOrderResponseData?.grandTotal} ₹',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Status',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        '${widget.getOrderResponseData?.status}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.grey),
                      const Text(
                        'Delivery Address:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${addressDetailResponseData?.address}, ${addressDetailResponseData?.city}, ${addressDetailResponseData?.state}, ${addressDetailResponseData?.zipCode}, ${widget.getOrderResponseData?.mobile}',
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      const Text(
                        'Ordered Items:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemCount: orderedItems?.productName?.length ?? 0,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              top: 10,
                              left: 5,
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width,
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
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            orderedItems?.image?[index] ?? ''),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            orderedItems?.productName?[index] ??
                                                '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey[200],
                                        ),
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Text(
                                            'Ordered: ${orderedItems?.quantity?[index]} ${orderedItems?.kgOrgm?[index]}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'MPR: ₹${int.parse(orderedItems?.mrpPrice?[index] ?? '0') * int.parse(orderedItems?.quantity?[index].toString() ?? '0')}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey[600],
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                '₹${int.parse(orderedItems?.sellPrice?[index] ?? '0') * int.parse(orderedItems?.quantity?[index].toString() ?? '0')}',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
