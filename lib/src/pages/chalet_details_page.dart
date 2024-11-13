import 'package:booking_guide/src/providers/room/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/back_button.dart';
import '../widgets/view_widget.dart';
import '../models/room.dart' as r;

class ChaletDetailsPage extends ConsumerStatefulWidget {
  final int facilityId;

  const ChaletDetailsPage({Key? key, required this.facilityId}) : super(key: key);

  @override
  _ChaletDetailsPageState createState() => _ChaletDetailsPageState();
}

class _ChaletDetailsPageState extends ConsumerState<ChaletDetailsPage> {
    final roomFormKey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    ref.read(roomProvider.notifier).fetch(facilityId: widget.facilityId);
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(
          trans().chalet,
          style: TextStyle(color: CustomTheme.placeholderColor),
        ),
        backgroundColor: CustomTheme.primaryColor,
        centerTitle: true,
      ),
      body: ViewWidget<r.Room>(
        meta: roomState.meta,
        data: roomState.data,
        refresh: () async => await ref.read(roomProvider.notifier).fetch(facilityId: widget.facilityId),
        forceShowLoaded: roomState.data != null,
        onLoaded: (room) {
          return Form(
            key: roomFormKey,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: RefreshIndicator(
              onRefresh: () async =>
              await ref.read(roomProvider.notifier).fetch(facilityId: widget.facilityId),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26.withOpacity(0.15),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              chaletImage,
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            room.name,
                            style: TextStyle(
                              color: CustomTheme.primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "السعة: ${room.capacity}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "الحالة: ${room.status}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          TabBar(
                            labelColor: CustomTheme.primaryColor,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: CustomTheme.primaryColor,
                            tabs: [
                              Tab(text: 'الوصف'),
                              Tab(text: 'السعر'),
                              Tab(text: 'الشروط'),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    room.desc,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'السعر: ${room.price_per_night.toStringAsFixed(2)} ر.س',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    room.type,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {},
                            child: Center(
                              child: Text(
                                'احجز الآن',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     final roomState = ref.watch(roomProvider);  // استلام حالة الغرفة من المزود
//     // بناء الواجهة باستخدام بيانات الغرفة أو الشاليه
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تفاصيل الشاليه'),
//       ),
//       body: roomState.when(
//         data: (room) {
//           // التحقق من وجود بيانات الشاليه
//           if (room != null) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'اسم الشاليه: ${room.name}',
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'وصف الشاليه: ${room.description}',
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     SizedBox(height: 16),
//                     room.images.isNotEmpty
//                         ? GridView.builder(
//                       shrinkWrap: true,
//                       itemCount: room.images.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 8,
//                         mainAxisSpacing: 8,
//                       ),
//                       itemBuilder: (context, index) {
//                         return Image.network(room.images[index]);
//                       },
//                     )
//                         : Text('لا توجد صور متاحة'),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Center(child: Text('لم يتم العثور على تفاصيل الشاليه.'));
//           }
//         },
//         loading: () => Center(child: CircularProgressIndicator()),
//         error: (err, stack) {
//           return Center(child: Text('حدث خطأ: $err'));
//         },
//       ),
//     );
//   }
// }

// class ChaletDetailsPage extends ConsumerStatefulWidget {
//   final r.Room room;
//
//   const ChaletDetailsPage({Key? key, required this.room}) : super(key: key);
//
//   @override
//   ConsumerState createState() => _ChaletDetailsPageState();
// }

// class _ChaletDetailsPageState extends ConsumerState<ChaletDetailsPage> {
//   final roomFormKey = GlobalKey<FormState>();
//   bool autoValidate = false;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(roomProvider.notifier).fetch(roomId: widget.room.id);
//     });
//   }
//
