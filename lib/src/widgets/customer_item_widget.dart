import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../services/shere_service.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import 'chip_widget.dart';
import 'icon_text_widget.dart';

class CustomerItemWidget extends StatelessWidget {

  final Customer customer;
  final bool canNavigate;
  final bool? selected;

  const CustomerItemWidget({super.key,
    required this.customer,
    required this.canNavigate,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(context),
      child: ListTile(
        onTap: () {
          if(canNavigate) {
            Navigator.pushNamed(context, Routes.customer,
              arguments: customer,
            );
          }
        },
        leading: selected != null
            ?
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 16.0),
          child: Icon(selected! ? radioOnIcon : radioOffIcon),
        )
            :
        null,
      ),
    );
  }
}
