import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TasksList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'My Tasks',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.bars,
            color: Colors.grey[700],
          ),
          onPressed: () => {},
        ),
        actions: <Widget>[
          PopupMenuButton<int>(

            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                height: 40,
                enabled: false,
                child: Text(
                  'Sort by',
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 18),
                ),
              ),
              PopupMenuItem(
                value: 1,
                height: 40,
                child: Text(
                  'Name',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18),
                ),
              ),
              PopupMenuItem(
                value: 2,
                height: 40,
                child: Text(
                  'Priority',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18),
                ),
              ),
              PopupMenuItem(
                value: 3,
                height: 40,
                child: Text(
                  'Date',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18),
                ),
              )
            ],
            icon: Icon(
              FontAwesomeIcons.listUl,
              color: Colors.grey[700],
            ),
            offset: Offset(0, 100),
//            elevation: 16,
            padding: EdgeInsets.only(top: 5),
            onSelected: (item)
            {
              if (item == 1)
              {

              }
              else if (item == 2)
              {

              }
            },
          ),
//          IconButton(
//            icon: Icon(
//              FontAwesomeIcons.listUl,
//              color: Colors.grey[700],
//            ),
//            onPressed: () => {},
//          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.sortAmountDown,
              color: Colors.grey[700],
            ),
            onPressed: () => {},
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text('TaskList'),
        ),
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        tooltip: 'Add task',
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 45,
        ),
      ),
    );
  }
}
