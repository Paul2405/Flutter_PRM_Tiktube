// import 'package:flutter/material.dart';
//
// class userProfile extends StatefulWidget {
//   @override
//   _userProfile createState() => _userProfile();
// }
//
// class _userProfile extends State<userProfile> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   static const double _imageHeight = 256.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           "Trang cá nhân",
//           style: TextStyle(color: Colors.black),
//         ),
//         iconTheme: new IconThemeData(color: Colors.black),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<UserResponse>(
//           stream: userBloc.userProfile,
//           builder: (context, AsyncSnapshot<UserResponse> response) {
//             if (response.hasData) {
//               User user = response.data.user;
//               List<String> ListRowIfo = [
//                 checkNull(user.email),
//                 checkNull(user.facebook),
//                 checkNull(user.phone),
//                 checkNull(user.joinDate),
//                 checkNull(user.provider)
//               ];
//               List<String> ListRowTitle = [
//                 "Email",
//                 "Facebook",
//                 "Phone",
//                 "Join date",
//                 "Provider"
//               ];
//               return Stack(
//                 children: <Widget>[
//                   _buildTimeline(),
//                   _buildImage(),
//                   _buildProfileRow(checkNull(user.name), checkNull(user.bio),
//                       checkNull(user.avatarUrl)),
//                   _buildBottomPart(ListRowIfo, ListRowTitle),
//                 ],
//               );
//             } else if (response.hasError) {
//               return _buildErrorWidget(response.error);
//             } else {
//               return _buildLoadingWidget();
//             }
//           }),
//     );
//     ;
//   }
//
//   Widget _buildLoadingWidget() {
//     return Center(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 25.0,
//           width: 25.0,
//           child: CircularProgressIndicator(
//             valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//             strokeWidth: 4.0,
//           ),
//         )
//       ],
//     ));
//   }
//
//   Widget _buildErrorWidget(String error) {
//     return Center(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text("Error occured: $error"),
//       ],
//     ));
//   }
//
//   Widget _buildImage() => ClipPath(
//         clipper: DialogonalClipper(),
//         child: Container(
//           width: double.infinity,
//           child: Image.network(
//             'https://image.freepik.com/free-photo/copy-space-table-with-office-supplies-workspace_35674-973.jpg',
//             fit: BoxFit.cover,
//             height: _imageHeight,
//             colorBlendMode: BlendMode.srcOver,
//             color: Color.fromARGB(80, 20, 10, 40),
//           ),
//         ),
//       );
//
//   Widget _buildProfileRow(String userName, String bio, String imgSrc) =>
//       Padding(
//         padding: const EdgeInsets.only(top: _imageHeight / 2.5, left: 16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             CircleAvatar(
//               minRadius: 28.0,
//               maxRadius: 28.0,
//               backgroundImage: NetworkImage(imgSrc),
//             ),
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Text(
//                       userName,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w300),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         bio,
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.w200),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//
//   Widget _buildBottomPart(List<String> userInfo, List<String> title) => Padding(
//         padding: const EdgeInsets.only(top: _imageHeight),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             _buildMyTaskHeader(),
//             _buildTaskList(userInfo, title),
//           ],
//         ),
//       );
//
//   Widget _buildTaskList(List<String> userInfo, List<String> title) => Expanded(
//       child: AnimatedList(
//           initialItemCount: 5,
//           itemBuilder: (context, index, animation) => TaskRow(
//                 title: title[index],
//                 userInfo: userInfo[index],
//                 animation: animation,
//               )));
//
//   Widget _buildMyTaskHeader() => Padding(
//         padding: const EdgeInsets.only(left: 64.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'Thông Tin',
//               style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w400),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//           ],
//         ),
//       );
//
//   Widget _buildTimeline() => Positioned(
//         top: 0.0,
//         bottom: 0.0,
//         left: 32.0,
//         child: Container(
//           width: 1.0,
//           color: Colors.grey[300],
//         ),
//       );
// }
//
// class TaskRow extends StatelessWidget {
//   final String userInfo;
//   final String title;
//   final Animation<double> animation;
//
//   const TaskRow({Key key, this.animation, this.userInfo, this.title})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: animation,
//       child: SizeTransition(
//         sizeFactor: animation,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 26.5),
//                 child: Container(
//                   width: 12.0,
//                   height: 12.0,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle, color: Colors.orange),
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       title,
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                     Text(
//                       checkNull(userInfo),
//                       style: TextStyle(
//                           fontSize: 12.0, fontWeight: FontWeight.w300),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Icon(
//                   Icons.edit,
//                   size: 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DialogonalClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) => Path()
//     ..lineTo(0.0, size.height - 60.0)
//     ..lineTo(size.width, size.height)
//     ..lineTo(size.width, 0.0)
//     ..close();
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }
//
// String checkNull(String temp) {
//   if (temp == null) {
//     return "";
//   }
//   return temp;
// }
