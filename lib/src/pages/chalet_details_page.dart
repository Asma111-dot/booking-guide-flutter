import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/room/room_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/view_widget.dart';
import '../models/room.dart';

class ChaletDetailsPage extends ConsumerStatefulWidget {
  final int facilityId;

  const ChaletDetailsPage({Key? key, required this.facilityId})
      : super(key: key);

  @override
  ConsumerState<ChaletDetailsPage> createState() => _ChaletDetailsPageState();
}

class _ChaletDetailsPageState extends ConsumerState<ChaletDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(roomsProvider.notifier).fetch(facilityId: widget.facilityId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomsState = ref.watch(roomsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          trans().chalet,
          style: TextStyle(color: CustomTheme.placeholderColor),
        ),
        backgroundColor: CustomTheme.primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ViewWidget<List<Room>>(
              meta: roomsState.meta,
              data: roomsState.data,
              onLoaded: (rooms) {
                if (rooms.isEmpty) {
                  return const Center(
                      child: Text(
                        // trans().noChalet,
                        '',
                        style: TextStyle(color: CustomTheme.placeholderColor),
                      ));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return buildRoomCard(context, room);
                  },
                );
              },
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onEmpty: () => const Center(
                  child: Text(
                    // trans().noChalet,
                    "",
                    style: TextStyle(color: CustomTheme.placeholderColor),
                  )),
              showError: true,
              showEmpty: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoomCard(BuildContext context, Room room) {
    return DefaultTabController(
      length: 3,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(CustomTheme.radius),
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
                width: 80,
                height: 80,
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
            TabBar(
              labelColor: CustomTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: CustomTheme.primaryColor,
              tabs: [
                Tab(text: 'الوصف'),
                Tab(text: 'الشروط'),
                Tab(text: 'السعر'),
              ],
            ),

            SizedBox(
              height: 100,
              child: TabBarView(
                children: [
                  // الوصف
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      room.desc,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  // الشروط
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                    "الحالة: ${room.status}",
                    style: TextStyle(
                     color:  CustomTheme.secondaryColor,
                      fontSize: 16,
                    ),
                  ),
                  ),
                  // السعر
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'السعر: ${room.price_per_night.toStringAsFixed(2)} ر.س',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              onPressed: () {
              },
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
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../helpers/general_helper.dart';
// import '../providers/room/room_provider.dart';
// import '../utils/assets.dart';
// import '../utils/theme.dart';
// import '../widgets/view_widget.dart';
// import '../models/room.dart';
//
// class ChaletDetailsPage extends ConsumerStatefulWidget {
//   final int roomId;
//   final int facilityId;
//
//   const ChaletDetailsPage(
//       {required this.facilityId, Key? key, required this.roomId})
//       : super(key: key);
//
//   @override
//   ConsumerState<ChaletDetailsPage> createState() => _ChaletDetailsPageState();
// }
//
// class _ChaletDetailsPageState extends ConsumerState<ChaletDetailsPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       if (widget.facilityId != null && widget.roomId != null) {
//         ref
//             .read(roomsProvider.notifier)
//             .fetch(roomId: widget.roomId, facilityId: widget.facilityId);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final roomsState = ref.watch(roomsProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           trans().chalet,
//           style: TextStyle(color: CustomTheme.placeholderColor),
//         ),
//         backgroundColor: CustomTheme.primaryColor,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ViewWidget<List<Room>>(
//               meta: roomsState.meta,
//               data: roomsState.data,
//               onLoaded: (rooms) {
//                 if (rooms.isEmpty) {
//                   return const Center(
//                       child: Text(
//                     'لا توجد غرف متاحة',
//                     style: TextStyle(color: CustomTheme.placeholderColor),
//                   ));
//                 }
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: rooms.length,
//                   itemBuilder: (context, index) {
//                     final room = rooms[index];
//                     return buildRoomCard(context, room);
//                   },
//                 );
//               },
//               onLoading: () => const Center(child: CircularProgressIndicator()),
//               onEmpty: () => const Center(
//                   child: Text(
//                 'لا توجد غرف متاحة',
//                 style: TextStyle(color: CustomTheme.placeholderColor),
//               )),
//               showError: true,
//               showEmpty: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildRoomCard(BuildContext context, Room room) {
//     return DefaultTabController(
//       length: 3,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26.withOpacity(0.15),
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.asset(
//                 chaletImage,
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               room.name,
//               style: TextStyle(
//                 color: CustomTheme.primaryColor,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "السعة: ${room.capacity}",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               "الحالة: ${room.status}",
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 16),
//             TabBar(
//               labelColor: CustomTheme.primaryColor,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: CustomTheme.primaryColor,
//               tabs: [
//                 Tab(text: 'الوصف'),
//                 Tab(text: 'السعر'),
//                 Tab(text: 'الشروط'),
//               ],
//             ),
//             SizedBox(
//               height: 100,
//               child: TabBarView(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       room.desc,
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'السعر: ${room.price_per_night.toStringAsFixed(2)} ر.س',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: CustomTheme.primaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 12),
//               ),
//               onPressed: () {},
//               child: Center(
//                 child: Text(
//                   'احجز الآن',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

