import 'package:flutter/material.dart';
class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5),
                width: double.infinity,
                //color: Theme.of(context).primaryColor.withOpacity(0.5),
                child: Text('product name',),//textAlign: TextAlign.left
              ),
              background: Hero(
                tag: 'product id',
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30),),
                      image: DecorationImage(image: NetworkImage(
                        'https://pbs.twimg.com/media/C8aGSu2UMAA982U?format=jpg&name=small',
                      ),fit: BoxFit.cover,),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '100\$',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  'here we can put description',
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
