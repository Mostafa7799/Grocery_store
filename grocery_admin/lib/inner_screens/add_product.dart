import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/controllers/MenuController.dart';
import 'package:grocery_admin_panel/responsive.dart';
import 'package:grocery_admin_panel/screens/loading_screen.dart';
import 'package:grocery_admin_panel/widgets/buttons.dart';
import 'package:grocery_admin_panel/widgets/header.dart';
import 'package:grocery_admin_panel/widgets/side_menu.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase/firebase.dart' as fb;

import '../services/global_method.dart';
import '../services/utils.dart';

class AddProducts extends StatefulWidget {
  static const routeName = '/AddProducts';

  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _formKey = GlobalKey<FormState>();

  String catValue = 'Vegetables';
  late final TextEditingController _titleController, _priceController;

  int groupValue = 1;
  bool isPiece = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    // TODO: implement initState
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _clearForm() {
    isPiece = false;
    groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  bool isLoading = false;

  void _uploadFormValidate() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
          context: context,
          supTitle: 'Please pick up an image',
        );
      }
      final _uuid = Uuid().v4();
      try {
        setState(() {
          isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('productsImages')
            .child('$_uuid.jpg');
        if (kIsWeb) /* if web */ {
          // putData() accepts Uint8List type argument
          await ref.putData(webImage).whenComplete(() async {
            final imageUri = await ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection('products')
                .doc(_uuid)
                .set({
              'id': _uuid,
              'title': _titleController.text,
              'price': _priceController.text,
              'salePrice': 0.1,
              'imageUrl': imageUri.toString(),
              'productCategoryName': catValue,
              'isOnSale': false,
              'isPiece': isPiece,
              'createdAt': Timestamp.now(),
            });
          });
        } else /* if mobile */ {
          // putFile() accepts File type argument
          await ref.putFile(_pickedImage!).whenComplete(() async {
            final imageUri = await ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection('products')
                .doc(_uuid)
                .set({
              'id': _uuid,
              'title': _titleController.text,
              'price': _priceController.text,
              'salePrice': 0.1,
              'imageUrl': imageUri.toString(),
              'productCategoryName': catValue,
              'isOnSale': false,
              'isPiece': isPiece,
              'createdAt': Timestamp.now(),
            });
          });
        }
        _clearForm();
        Fluttertoast.showToast(
            msg: "Product uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
          context: context,
          supTitle: '${error.message}',
        );
        setState(() {
          isLoading = false;
        });
        print(error);
      } catch (error) {
        GlobalMethods.errorDialog(supTitle: '$error', context: context);
        setState(() {
          isLoading = false;
        });
        print(error);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final themeState = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
        color: color,
        width: 1.0,
      )),
    );

    return Scaffold(
      key: context.read<MenuController>().getAddProductscaffoldKey,
      drawer: SideMenu(),
      body: LoadingScreen(
        isLoading: isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Header(
                        showText: false,
                        title: 'Add Products',
                        fct: () {
                          context
                              .read<MenuController>()
                              .getAddProductscaffoldKey;
                        }),
                    Container(
                      width: size.width > 650 ? 650 : size.width,
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              text: 'Product title',
                              color: color,
                              isTitle: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _titleController,
                              key: ValueKey('Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please inter product title';
                                } else {
                                  return null;
                                }
                              },
                              decoration: inputDecoration,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: 'Price is \$',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                            controller: _priceController,
                                            key: ValueKey('Price \$'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please inter product price';
                                              } else {
                                                return null;
                                              }
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              ),
                                            ],
                                            decoration: inputDecoration,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: 'Product categories',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            color: _scaffoldColor,
                                            child: _categoryDropDown()),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: "Measure unit",
                                          color: color,
                                          isTitle: true,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            TextWidget(
                                              text: 'Kg',
                                              color: color,
                                            ),
                                            Radio(
                                              value: 1,
                                              groupValue: groupValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  groupValue = 1;
                                                  isPiece = false;
                                                  print(groupValue);
                                                });
                                              },
                                              activeColor: Colors.green,
                                            ),
                                            TextWidget(
                                              text: 'Piece',
                                              color: color,
                                            ),
                                            Radio(
                                              value: 2,
                                              groupValue: groupValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  groupValue = 2;
                                                  isPiece = true;
                                                  print(groupValue);
                                                });
                                              },
                                              activeColor: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: size.width > 650
                                          ? 350
                                          : size.width * .45,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: _pickedImage == null
                                          ? dottedBorder(color: color)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: kIsWeb
                                                  ? Image.memory(webImage,
                                                      fit: BoxFit.fill)
                                                  : Image.file(_pickedImage!,
                                                      fit: BoxFit.fill),
                                            ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pickedImage = null;
                                              webImage = Uint8List(8);
                                            });
                                          },
                                          child: TextWidget(
                                            text: 'Clear',
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: TextWidget(
                                            text: 'Update image',
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonsWidget(
                                    onPressed: () {
                                      _clearForm();
                                    },
                                    text: 'Clear form',
                                    icon: IconlyLight.danger,
                                    backgroundColor: Colors.red,
                                  ),
                                  ButtonsWidget(
                                    onPressed: () {
                                     _uploadFormValidate();
                                    },
                                    text: 'Upload form',
                                    icon: IconlyLight.upload,
                                    backgroundColor: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({required Color color}) {
    return DottedBorder(
      dashPattern: [6.7],
      borderType: BorderType.RRect,
      color: color,
      radius: Radius.circular(12),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: color,
              size: 50,
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                _pickImage();
                //_imgFromGallery() ;
              },
              child: TextWidget(
                text: 'Choose a image',
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
          value: catValue,
          onChanged: (value) {
            setState(() {
              catValue = value!;
            });
            print(catValue);
          },
          hint: Text('Select a category'),
          items: const [
            DropdownMenuItem(
              child: Text(
                'Vegetables',
              ),
              value: 'Vegetables',
            ),
            DropdownMenuItem(
              child: Text(
                'Fruits',
              ),
              value: 'Fruits',
            ),
            DropdownMenuItem(
              child: Text(
                'Grains',
              ),
              value: 'Grains',
            ),
            DropdownMenuItem(
              child: Text(
                'Nuts',
              ),
              value: 'Nuts',
            ),
            DropdownMenuItem(
              child: Text(
                'Herbs',
              ),
              value: 'Herbs',
            ),
            DropdownMenuItem(
              child: Text(
                'Spices',
              ),
              value: 'Spices',
            ),
          ],
        ),
      ),
    );
  }

}
