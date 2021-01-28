import 'package:flutter/material.dart';

class SearchScreenBody extends StatefulWidget {
  @override
  _SearchScreenBodyState createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<SearchScreenBody> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: deviceWidth*0.01, vertical: deviceHeight*0.01),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shadowColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  SizedBox(
                    width: deviceWidth*0.02,
                  ),
                  Icon(Icons.search,color: Theme.of(context).primaryColor,),
                  SizedBox(
                    width: deviceWidth*0.02,
                  ),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(fontSize: 18,),
                      cursorColor:  Theme.of(context).primaryColor,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Searching...",
                        hintStyle: TextStyle(color: Colors.grey,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: Column(),
            ),
          ],
        ),
      ),
    );
  }
}
