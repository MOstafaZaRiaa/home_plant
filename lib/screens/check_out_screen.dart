
import 'package:flutter/material.dart';

enum stateOfBuy {onDelivery,byVisa}
stateOfBuy valueOfStateBuy = stateOfBuy.onDelivery;

class CheckOutScreen extends StatefulWidget {
  @override

  final double totalPrice;
  final user;
  final snapshot;
  const CheckOutScreen({
    this.totalPrice,
    this.user,
    this.snapshot,
  });

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addressController = new TextEditingController();
  void pay(BuildContext context){
    if(valueOfStateBuy == stateOfBuy.byVisa){
      final isValid = _formKey.currentState.validate();
      if(isValid){
        _formKey.currentState.save();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Your is placing now...'),),);
      }
    }

  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.height;
    final products = widget.snapshot.data.docs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check out'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 130 + (products.length * 50.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: const Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.all(12),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Text(
                        '${products[index]['productName']} :',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      title: Text(
                          '${products[index]['productPrice']} X ${products[index]['productAmount']}'),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      'Total :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    title: Text(
                      '${widget.totalPrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
            RadioListTile(
              title: Text('Pay when it deliverd.'),
              value: stateOfBuy.onDelivery,
              groupValue: valueOfStateBuy,
              onChanged: (value){
                setState(() {
                  valueOfStateBuy = value;
                });
              },
            ),
            RadioListTile(
              title: Text('Pay with Visa/Master Card.'),
              value: stateOfBuy.byVisa,
              groupValue: valueOfStateBuy,
              onChanged: (value){
                setState(() {
                  valueOfStateBuy = value;
                });
              },
            ),
            Form(
              key: _formKey,
              child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(labelText: 'Card number',),
                    validator: (value){
                      if(int.tryParse(value)==null || int.tryParse(value)<16){
                        return 'Card number must be less 16 numbers';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: deviceWidth*0.15,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Expire date',),
                        maxLength: 4,
                        validator: (value){
                          if(int.tryParse(value)==null || int.tryParse(value)<4){
                            return 'Card number must be less 4 numbers';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: deviceWidth*0.1,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Cvv',),
                        maxLength: 3,
                        validator: (value){
                          if(int.tryParse(value)==null || int.tryParse(value)<3){
                            return 'Card number must be less 3 number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: TextFormField(
                minLines: 3,
                maxLines: 5,
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
            ),
            SizedBox(height: 25,),
            InkWell(
              child: Builder(builder:(context)=> FlatButton(
                  minWidth: double.infinity,
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.024),
                  child: Text(
                    'Pay ${widget.totalPrice}\$',
                    style: TextStyle(
                        color: Theme.of(context)
                            .accentTextTheme
                            .headline1
                            .color),
                  ),
                  onPressed:(){
                    pay(context);
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
