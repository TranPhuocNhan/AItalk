import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatefulWidget{
  final Function(String updateData) onUpdate;
  SearchGroup({required this.onUpdate});
  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchGroup>{
  late Function(String updateData) onUpdate;
  TextEditingController searchControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.onUpdate = widget.onUpdate;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:Container(
            margin: const EdgeInsets.only(top: 4),
            height: 40,
            child: TextField(
              maxLines: 1,
              controller: searchControler,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      searchControler.clear();
                    });
                  }, 
                  icon: const Icon(Icons.close),
                ),
                hintText: "Search bots...",
                border:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  )
                ),
              ),
              onChanged: (data){
                onUpdate(data);
              },
            ),
          ), 
        ),
        const SizedBox(width: 10,),
      ],
    );
  }

}