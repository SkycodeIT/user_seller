import 'package:flutter/material.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/const/my_theme.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromRGBO(247, 249, 250, 1.0),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: MyTheme.accent_color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          ImagePath.icAppbarIcon,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: 15,
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'About Us',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, top: 5, bottom: 5, right: 15),
                        child: Text(
                          'Green house Company was started in the year 2005. The app gives you everything you need to stay in touch with “Greenhouse” anytime, anywhere. Easily get in contact with us using real-time chat, and receive push notification with our latest offer so you never miss a thing. Vegetable and groceries directly purchased farmers to customers. This is Green House trade promise',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
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
