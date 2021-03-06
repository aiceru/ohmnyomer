import 'dart:io';

import 'package:dartnyom/protonyom_api_pet.pb.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';
import 'package:ohmnyomer/src/ui/widgets/bordered_circle_avatar.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:ohmnyomer/src/ui/widgets/image_picker.dart';
import 'package:sizer/sizer.dart';

class PetWithProfile {
  Pet pet;
  File? profile;
  PetWithProfile(this.pet, {this.profile});
}

class DialogPetDetail extends StatefulWidget {
  const DialogPetDetail(this._pet, this._familyMap, {Key? key}) :super(key: key);

  final Pet? _pet;
  final Map<String, Family> _familyMap;

  @override
  _DialogPetDetailState createState() => _DialogPetDetailState();
}

class _DialogPetDetailState extends State<DialogPetDetail> with ValidationMixin {
  String _id = '';
  String _photourl = '';
  String _name = '';
  String _familyKey = '';
  String _speciesKey = '';
  DateTime _adopted = DateTime.now();

  Map<String, Family> _familyMap = {};
  File? _localProfile;

  final TextEditingController _nameInputController = TextEditingController();

  @override
  void dispose() {
    _nameInputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var pet = widget._pet;
    if (pet != null) {
      _id = pet.id;
      _photourl = pet.photourl;
      _name = pet.name;
      _familyKey = pet.family;
      _speciesKey = pet.species;
      _adopted = dateTimeFromEpochSeconds(pet.adopted.toInt());
    }
    _familyMap = widget._familyMap;
    _nameInputController.text = _name;
    super.initState();
  }


  Widget _buildPetDetailTitleRow() {
    return GestureDetector(
      onTap: () => pickAndCropImage((image) => setState(() => { _localProfile = image })),
      child: BorderedCircleAvatar(avatarSizeLarge.w,
          file: _localProfile,
          networkSrc: _photourl,
          iconData: Icons.add_a_photo,
        ),
    );
  }

  Future<dynamic> selectListDialog(Map<String, String> kv, String title) async {
    var list = kv.keys.toList();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: infoTitleText(title),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: infoText(kv[list[index]]!),
                  onTap: () {
                    Navigator.of(context).pop(list[index]);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFamilyRow() {
    Map<String, String> familyMap = {};
    for (var entry in _familyMap.entries) {
      familyMap[entry.key] = entry.value.name;
    }
    return Container(
      decoration: kBoxDecorationStyle,
      height: 6.7.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.more_horiz, color: Colors.black54),
              TextButton(
                  onPressed: () {
                    selectListDialog(familyMap, S.of(context).selectPet).then((value) {
                      if (value != null) {
                        setState(() {
                          _familyKey = value;
                          _speciesKey = '';
                        });
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    textStyle: infoTextStyle(),
                    primary: Colors.black54,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(familyMap[_familyKey] ?? ''),
                  )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.category, color: Colors.black54),
              TextButton(
                  onPressed: () {
                    if (_familyMap[_familyKey] != null) {
                      selectListDialog(_familyMap[_familyKey]!.species, S.of(context).selectKind).then((value) {
                        setState(() => _speciesKey = value);
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                    textStyle: infoTextStyle(),
                    primary: Colors.black54,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_familyMap[_familyKey]?.species[_speciesKey] ?? ''),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdoptedDateRow() {
    return Container(
      decoration: kBoxDecorationStyle,
      height: 6.7.h,
      child: InkWell(
        child: Center(child: infoText(S.of(context).adoptedAt + ': ' + _adopted.formatDate())),
        onTap: () {
          Future<DateTime?> selectedDate = showDatePicker(
            context: context,
            initialDate: _adopted, // ?????????
            firstDate: DateTime(2000), // ?????????
            lastDate: DateTime.now().add(const Duration(days: 365)), // ????????????
          );
          selectedDate.then((dateTime) {
            if (dateTime != null) {
              setState(() {
                _adopted = dateTime;
              });
            }
          });
        },
      ),
    );
  }

  Widget _buildCancelButton() {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.cancel_outlined, color: Colors.black54),
    );
  }

  Widget _buildSaveButton() {
    return IconButton(
      onPressed: () {
        if (_nameInputController.text.isEmpty || _familyKey.isEmpty || _speciesKey.isEmpty) {
          ErrorDialog().showAlert(context,
            S.of(context).input_error_title,
            S.of(context).pet_detail_input_error,
          );
        } else {
          Pet pet = Pet()
            ..id = _id
            ..name = _nameInputController.text
            ..photourl = _photourl
            ..adopted = Int64(_adopted.toSecondsSinceEpoch())
            ..family = _familyKey
            ..species = _speciesKey;
          Navigator.of(context).pop(PetWithProfile(pet, profile: _localProfile));
        }
      },
      icon: const Icon(Icons.send, color: Colors.black54),
    );
  }

  Widget _buildActionsRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      height: 6.7.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCancelButton(),
          SizedBox(width: 5.w),
          _buildSaveButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        title: _buildPetDetailTitleRow(),
        children: [
          const Divider(),
          buildTextField(Icons.pets, S.of(context).name, TextInputType.name,
              validateNameFunc(context), _nameInputController),
          const Divider(),
          _buildFamilyRow(),
          const Divider(),
          _buildAdoptedDateRow(),
          const Divider(),
          _buildActionsRow(),
        ],
        elevation: 10.0,
        contentPadding: EdgeInsets.all(5.w),
      );
    });
  }
}
