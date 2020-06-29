import 'dart:io';

import 'package:flutter/material.dart';
import '../providers/category_provider.dart' as CP;
import 'package:provider/provider.dart';
import 'package:shop_mangement/widgets/image_input.dart';
// import 'package:intl/intl.dart';

class Newtransaction extends StatefulWidget {
  final Function addNewTransaction;

  Newtransaction(this.addNewTransaction);

  @override
  _NewtransactionState createState() => _NewtransactionState();
}

class _NewtransactionState extends State<Newtransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _pPriceController = TextEditingController();
  final _sPriceController = TextEditingController();
  final _unitController = TextEditingController();
  // DateTime _selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  File _pickedImage;

  void _selectImage(File pickedIamge) {
    _pickedImage = pickedIamge;
  }

  Future<void> _submitData() async {
    final enteredTitle = _titleController.text;
    final enteredAmouont = double.parse(_amountController.text);
    final enteredPPrice = double.parse(_pPriceController.text);
    final enteredSPrice = double.parse(_sPriceController.text);
    final enteredUnit = _unitController.text;

    String storageResult;

    if (_formKey.currentState.validate()) {
      try {
        storageResult = await Provider.of<CP.CategoryProvider>(context,
                listen: false)
            .uploadImage(imageToUpload: _pickedImage, imageCategory: 'product');
      } catch (error) {
        print(error.toString());
        throw error;
      }
      if (enteredTitle.isEmpty || storageResult == null) {
        return;
      } else {
        widget.addNewTransaction(
          enteredTitle,
          enteredAmouont,
          enteredPPrice,
          enteredSPrice,
          enteredUnit,
          storageResult,
        );
      }
      _formKey.currentState.save();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            child: formUi(context),
            key: _formKey,
            autovalidate: _autoValidate,
          ),
        ),
      ),
    );
  }

  Column formUi(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ImageInput(_selectImage),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Product Name'),
          controller: _titleController,
          validator: (arg) {
            if (arg.length == 0) {
              return 'This field is required';
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Amount'),
          controller: _amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Unit'),
          controller: _unitController,
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Purchase price(per unit)'),
          controller: _pPriceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Sell price (per unit'),
          controller: _sPriceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('Add Transaction'),
          textColor: Theme.of(context).textTheme.button.color,
          onPressed: _submitData,
        ),
      ],
    );
  }
}
