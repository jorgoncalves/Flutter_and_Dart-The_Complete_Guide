import 'package:app/provider/great_places.dart';
import 'package:app/screens/add_place_screen.dart';
import 'package:app/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesListScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fecthAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                  child: const Text('Got not places yet, start adding some!'),
                ),
                builder: (
                  context,
                  greatPlaces,
                  child,
                ) =>
                    greatPlaces.items.length <= 0
                        ? child
                        : ListView.builder(
                            itemCount: greatPlaces.items.length,
                            itemBuilder: (context, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[i].image),
                              ),
                              title: Text(greatPlaces.items[i].title),
                              subtitle:
                                  Text(greatPlaces.items[i].location.address),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    PlaceDetailScreen.routeName,
                                    arguments: greatPlaces.items[i].id);
                              },
                            ),
                          ),
              ),
      ),
    );
  }
}
