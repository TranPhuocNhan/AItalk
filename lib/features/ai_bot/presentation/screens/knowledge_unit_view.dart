import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/widgets/unit_knowledge_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_unit_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/providers/knowledge_provider.dart';
import 'package:provider/provider.dart';

class KnowledgeUnitView extends StatefulWidget {
  const KnowledgeUnitView({super.key, required this.knowledge});

  final KnowledgeResDto knowledge;

  @override
  State<KnowledgeUnitView> createState() => _KnowledgeUnitViewState();
}

class _KnowledgeUnitViewState extends State<KnowledgeUnitView> {
  List<KnowledgeUnitDto> units = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch data from API
      await Provider.of<KnowledgeProvider>(context, listen: false)
          .getUnitsOfKnowledge(widget.knowledge.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final knowledgeProvider =
        Provider.of<KnowledgeProvider>(context, listen: true);
    units = knowledgeProvider.units;
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      UnitKnowledgeDialog(knowledge: widget.knowledge));
            },
            label: Text(
              "Add Unit",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildUnitTable(),
            Spacer(),
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  // Widget Header: Hiển thị tên KB và thông tin về số đơn vị và kích thước
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.storage, color: Colors.orange, size: 40),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KB Development',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    _buildInfoChip(
                        widget.knowledge.numUnits.toString(), Colors.blue),
                    SizedBox(width: 5),
                    _buildInfoChip(
                        widget.knowledge.totalSize.toString(), Colors.red),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget Info Chip (hiển thị số đơn vị và kích thước)
  Widget _buildInfoChip(String label, Color color) {
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  // Widget for Unit Table
  Widget _buildUnitTable() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Unit')),
            DataColumn(label: Text('Source')),
            DataColumn(label: Text('Size')),
            DataColumn(label: Text('Create Time')),
            DataColumn(label: Text('Latest Update')),
            DataColumn(label: Text('Enable')),
            DataColumn(label: Text('Action')),
          ],
          rows: units.map((unit) {
            return _buildUnitRow(unit.name, unit.type, unit.size.toString(),
                unit.createdAt, unit.updatedAt, unit.status);
          }).toList(),
        ),
      ),
    );
  }

  // Widget to build each row in the table
  DataRow _buildUnitRow(String unit, String source, String size,
      String createTime, String latestUpdate, bool isEnabled) {
    String displayUnit =
        unit.length > 20 ? unit.substring(0, 20) + "..." : unit;
    return DataRow(
      cells: [
        DataCell(Row(
          children: [
            Icon(Icons.insert_drive_file, color: Colors.blue),
            SizedBox(width: 10),
            Container(
              child: Text(
                displayUnit,
                overflow: TextOverflow.ellipsis,
              ),
              constraints: BoxConstraints(maxWidth: 150),
            ),
          ],
        )),
        DataCell(Text(source)),
        DataCell(Text(size)),
        DataCell(Text(createTime)),
        DataCell(Text(latestUpdate)),
        DataCell(Switch(
          value: isEnabled,
          onChanged: (value) {
            // Toggle switch
          },
        )),
        DataCell(IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Action to delete unit
          },
        )),
      ],
    );
  }

  // Pagination Controls (if needed)
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Go to previous page
          },
        ),
        Text('1'),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            // Go to next page
          },
        ),
      ],
    );
  }
}
