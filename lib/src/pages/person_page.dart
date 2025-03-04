import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/mune_item_widget.dart';

class PersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().persons,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: CustomTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(logoCoverImage,
                  height: 100,
                  width: 100,),
                ),
              ),
              const SizedBox(height: 10),
              Text('Asmaa', style: Theme.of(context).textTheme.bodyLarge),
              Text('asma@booing.com', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text('تعديل البيانات',
                      style: TextStyle(
                        color: CustomTheme.primaryColor,
                      )),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  MenuItem(
                    title: 'الإعدادات',
                    onPressed: () {},
                    icon: LineAwesomeIcons.cog_solid,
                  ),
                  MenuItem(
                    title: 'السياسات والاسئلة الشائعة',
                    onPressed: () {},
                    icon: LineAwesomeIcons.question_circle,
                  ),
                  MenuItem(
                    title: 'قنوات التواصل والدعم الفني',
                    onPressed: () {},
                    icon: LineAwesomeIcons.phone_volume_solid,
                  ),
                  MenuItem(
                    title: 'تسجيل الخروج',
                    onPressed: () {},
                    icon: LineAwesomeIcons.life_ring,

                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
