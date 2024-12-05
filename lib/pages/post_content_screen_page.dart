// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:moto_kent/Models/post_model.dart';
//
//
// class PostContentScreenPage extends StatefulWidget {
//   PostModel? postModel;
//   PostContentScreenPage({super.key, required PostModel this.postModel});
//   @override
//   State<PostContentScreenPage> createState() => _PostContentScreenPageState();
// }
//
// class AppData {
//   //bu sınıftan başka bir nesne oluşturulmasını engellemek adına yapılabilir.
//   AppData._();
//
//   static  List<List<String>> categories = [
//     ["assets/svg/volleyball.svg", "Voleybol"],
//     ["assets/svg/paw.svg", "Patiler"],
//     ["assets/svg/megaphone.svg", "Duyuru"]
//   ];
// }
//
// class _PostContentScreenPageState extends State<PostContentScreenPage> {
//
//   bool? _isLike;
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(width * 0.05),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                       decoration: BoxDecoration(border: Border.all()),
//                       height: 100,
//                       width: 80,
//                       child: Padding(
//                         padding: const EdgeInsets.all(1.0),
//                         child: ClipRRect(
//                             child: Image.network(
//                               widget.postModel!.userPhoto!,
//                               fit: BoxFit.fill,
//                             )),
//                       )),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             widget.postModel!.userData!,
//                             style: Theme.of(context).textTheme.headlineLarge,
//                           ),
//                           SizedBox(
//                             width: width * 0.2,
//                           ),
//                           ...List.generate(
//                             5,
//                                 (index) => Icon(
//                               Icons.star,
//                               size: 12,
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           _buildPostContentButton(
//                               width: width, content: "Profile Git"),
//                           SizedBox(
//                             width: width * 0.05,
//                           ),
//                           _buildPostContentButton(
//                               width: width, content: "Mesaj At"),
//                         ],
//                       )
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: Colors.grey[200]),
//                 child: Padding(
//                   padding: EdgeInsets.all(width * 0.05),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               maxLines: 4,
//                               widget.postModel!.postContentTitle!,
//                               style: Theme.of(context).textTheme.titleLarge,
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 SvgPicture.asset(
//                                   AppData.categories[
//                                   widget.postModel!.postCategory!][0],
//                                   height: 50,
//                                   color: Colors.black,
//                                 ),
//                                 Text(
//                                     AppData.categories[
//                                     widget.postModel!.postCategory!][1],
//                                     style:
//                                     Theme.of(context).textTheme.headlineLarge)
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildButton(
//                               icon: Icon(Icons.star_outlined),
//                               content: "Favorile"),
//                           _buildButton(
//                               icon: Icon(Icons.send), content: "Paylaş"),
//                           _buildButton(
//                               icon: Icon(Icons.report_outlined),
//                               content: "Şikayet Et")
//                         ],
//                       ),
//                       Text(
//                         widget.postModel!.postContent!,
//                         style: Theme.of(context).textTheme.headlineSmall,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(widget.postModel!.postDate!,
//                               style:Theme.of(context).textTheme.titleSmall),
//                           Row(
//                             children: [
//                               _buildButton(
//                                   onTap: () {
//                                     setState(() {
//                                       _isLike = true;
//                                     });
//                                   },
//                                   icon: SvgPicture.asset("assets/svg/like.svg"),
//                                   content: "",
//                                   color: _isLike == true
//                                       ? Colors.green.withOpacity(0.7)
//                                       : Colors.green.withOpacity(0.2)),
//                               _buildButton(
//                                   onTap: () {
//                                     setState(() {
//                                       _isLike = false;
//                                     });
//                                   },
//                                   icon: SvgPicture.asset(
//                                       "assets/svg/dislike.svg"),
//                                   content: "",
//                                   color: _isLike == false
//                                       ? Colors.red.withOpacity(0.7)
//                                       : Colors.red.withOpacity(0.2)),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.location_pin,
//                                 color: Colors.black54,
//                                 size: 16,
//                               ),
//                               const SizedBox(width: 3),
//                               Text(widget.postModel!.postLocation!,
//                                   style: Theme.of(context).textTheme.labelSmall),
//                             ],
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   GestureDetector _buildButton(
//       {required Widget icon,
//         required String content,
//         Color color = const Color(0xFFf7d6c7),
//         VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             child: icon,
//             backgroundColor: color,
//           ),
//           Text(content)
//         ],
//       ),
//     );
//   }
//
//   Container _buildPostContentButton(
//       {required double width, required String content}) {
//     return Container(
//       width: width * 0.3,
//       decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primary,
//           borderRadius: BorderRadius.circular(90)),
//       child: Padding(
//         padding: EdgeInsets.all(width * 0.01),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(content),
//             SizedBox(
//               width: width * 0.05,
//             ),
//             Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(90),
//                     color: Colors.white),
//                 child: Icon(Icons.keyboard_arrow_right))
//           ],
//         ),
//       ),
//     );
//   }
// }