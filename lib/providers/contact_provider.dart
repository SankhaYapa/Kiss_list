import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiss_list/controllers/contact_controller.dart';
import 'package:kiss_list/model/contact_model.dart';
import 'package:logger/logger.dart';

import 'dart:io';

class ContactProvider extends ChangeNotifier {
  //resturent controller
  final ContactController _contactController = ContactController();
//image picker
  final ImagePicker _picker = ImagePicker();

  File _image = File("");

  var _isObscure = true;
  final _name = TextEditingController();
  final _gender = TextEditingController();
  final _age = TextEditingController();
  final _date = TextEditingController();
  final _notices = TextEditingController();
  final _about = TextEditingController();
  final _rating = TextEditingController();
  bool _isLoading = false;

//get obscure state
  bool get isObscure => _isObscure;

//get loading state
  bool get isLoading => _isLoading;

  //get firstname controller
  TextEditingController get nameController => _name;

  //get lastname controller
  TextEditingController get genderController => _gender;

  //get email controller
  TextEditingController get ageController => _age;

  //get password controller
  TextEditingController get dateController => _date;

  //get lastname controller
  TextEditingController get noticesController => _notices;

  //get email controller
  TextEditingController get aboutController => _about;

  //get password controller
  TextEditingController get ratingController => _rating;

  //change obscure state
  void changeObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  //get image file
  File get getImg => _image;

  //validation function

  bool inputValidation() {
    var isValid = false;
    if (_name.text.isEmpty) {
      isValid = false;
    } else {
      isValid = true;
    }
    return isValid;
  }

  Future<void> startAddContactDetails(BuildContext context) async {
    try {
      if (inputValidation()) {
        setLoading(true);
        await _contactController.saveContactDetails(
          _name.text,
          _gender.text,
          _age.text,
          _date.text,
          _notices.text,
          _about.text,
          _rating.text,
          _image,
        );
        setLoading();

        // DialogBox().dialogBox(
        //     context, DialogType.SUCCES, "SUCCESS", "resturent added");
      } else {
        // DialogBox().dialogBox(
        //     context,
        //     DialogType.ERROR,
        //     'Incorrect Information',
        //     'Please Enter Please Enter correct Information');
      }
    } catch (e) {
      setLoading();
      Logger().e(e);
    }
  }

  //change loading state
  void setLoading([bool val = false]) {
    _isLoading = val;
    notifyListeners();
  }

//function to pick image from gallery
  Future<void> selectImage() async {
    try {
      // Pick an image
      final XFile? pickFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickFile != null) {
        _image = File(pickFile.path);
        Logger().w(_image.path);
        notifyListeners();
      } else {
        Logger().e("No Image Selected");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  // ///resturent details screen
  // //defining single resurent model
  late ContactModel _resturentModel;
  // //getter for res model
  ContactModel get singleRes => _resturentModel;

  // //set the resturent model
  void setSingleRes(ContactModel model) {
    _resturentModel = model;
    notifyListeners();
  }

  // //change loading state
  // void setLoading([bool val = false]) {
  //   _isLoading = val;
  //   notifyListeners();
  // }

/////////////,,,,,,,,,,Single resturent screen
  ///list to single resturent products///
  List<ContactModel> _contacts = [];

  //List to store single resturent 3 products
  List<ContactModel> _mincontacts = [];

  //geter for single resturent product list
  List<ContactModel> get products => _contacts;
  //geter for single resturent 3 product list
  List<ContactModel> get minProducts {
    List<ContactModel> list = [];
    for (var i = 0; i < _contacts.length; i++) {
      list.add(_contacts[i]);
      if (i == 2) break;
    }
    return list;
  }

  //fetch product by resturent id
  Future<void> fetchProdutsResById(String resid) async {
    try {
      _mincontacts.clear();
      _contacts.clear();
      setLoading(true);
      await _contactController.getContactDetails(resid).then((value) {
        // _contacts = value;

        // for (var i = 0; i < value.length; i++) {
        //   _minproductsList.add(value[i]);
        //   if (i == 2) break;
        // }

        Logger().w(_contacts.length);

        setLoading();
        notifyListeners();
      });
    } catch (e) {
      Logger().e(e);
      setLoading();
    }
  }
}
