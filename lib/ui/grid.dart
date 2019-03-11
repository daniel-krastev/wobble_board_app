//import 'package:flutter/material.dart';
//
//
//class Grid extends StatelessWidget {
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Game World'),
//      ),
//      body: _buildGrid(),
//    );
//  }
//
//}







//
//List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
//  const StaggeredTile.count(2, 1),
//  const StaggeredTile.count(1, 2),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(2, 2),
//  const StaggeredTile.count(1, 2),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(3, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(4, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//  const StaggeredTile.count(1, 1),
//];
//
//List<Widget> _tiles = const <Widget>[
//  const _GridTile(Colors.green, Icons.widgets),
//  const _GridTile(Colors.lightBlue, Icons.wifi),
//  const _GridTile(Colors.amber, Icons.panorama_wide_angle),
//  const _GridTile(Colors.blue, Icons.radio),
//  const _GridTile(Colors.green, Icons.widgets),
//  const _GridTile(Colors.lightBlue, Icons.wifi),
//  const _GridTile(Colors.amber, Icons.panorama_wide_angle),
//  const _GridTile(Colors.blue, Icons.radio),
//  const _GridTile(Colors.green, Icons.widgets),
//  const _GridTile(Colors.lightBlue, Icons.wifi),
//  const _GridTile(Colors.amber, Icons.panorama_wide_angle),
//  const _GridTile(Colors.blue, Icons.radio),
//  const _GridTile(Colors.green, Icons.widgets),
//  const _GridTile(Colors.lightBlue, Icons.wifi),
//  const _GridTile(Colors.amber, Icons.panorama_wide_angle),
//  const _GridTile(null, null),
//  const _GridTile(Colors.blue, Icons.radio),
//  const _GridTile(null, null),
//];
//
//class Grid extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Example 01'),
//        ),
//        body: new Padding(
//            padding: const EdgeInsets.only(top: 12.0),
//            child: new StaggeredGridView.count(
//              crossAxisCount: 5,
//              staggeredTiles: _staggeredTiles,
//              children: _tiles,
//              mainAxisSpacing: 4.0,
//              crossAxisSpacing: 4.0,
//              padding: const EdgeInsets.all(4.0),
//            )));
//  }
//}
//
//class _GridTile extends StatelessWidget {
//  const _GridTile(this.backgroundColor, this.iconData);
//
//  final Color backgroundColor;
//  final IconData iconData;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Card(
//      color: backgroundColor,
//      child: new InkWell(
//        onTap: () {},
//        child: new Center(
//          child: new Padding(
//            padding: const EdgeInsets.all(4.0),
//            child: new Icon(
//              iconData,
//              color: Colors.white,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}