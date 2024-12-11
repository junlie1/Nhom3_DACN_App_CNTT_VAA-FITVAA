import 'package:flutter/material.dart';

class InnerHeaderWidget extends StatelessWidget {
  const InnerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
//Widget Stack cho phép chồng nhiều widget con lên nhau
      child: Stack(
        children: [
          Image.asset(
            "assets/icons/searchBanner.jpeg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          //Vị trí các Widget con trong stack

          //Back
          Positioned(
              left: 0,
              top: 30,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )
              )
          ),
          //Search
          Positioned(
            left: 30,
            top: 60,
            child: SizedBox(
              width: 260,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search here",
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16
                    ),
                    prefixIcon: Image.asset("assets/icons/searc1.png",width: 30,height: 30,),
                    suffixIcon: Image.asset("assets/icons/cam.png",width: 30,height: 30,),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                    )
                ),
              ),
            ),
          ),
          //Cái Chuông
          Positioned(
            left: 300,
            top: 68,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                child: Ink(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/bell.png")
                      )
                  ),
                ),
              ),
            ),
          ),
          //Message
          Positioned(
            left: 350,
            top: 68,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                child: Ink(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/message.png")
                      )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
