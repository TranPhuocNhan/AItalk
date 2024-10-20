import 'package:flutter/material.dart';

class KnowledgeUnitView extends StatefulWidget {
  const KnowledgeUnitView({super.key});

  @override
  State<KnowledgeUnitView> createState() => _KnowledgeUnitViewState();
}

class _KnowledgeUnitViewState extends State<KnowledgeUnitView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    _buildInfoChip('2 Units', Colors.blue),
                    SizedBox(width: 5),
                    _buildInfoChip('16.39 KB', Colors.red),
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
          rows: [
            _buildUnitRow('weekly process', 'Google drive', '13.97 KB',
                '7/13/2024 9:02:03 PM', '7/13/2024 9:02:03 PM', true),
            _buildUnitRow('Task Management', 'Jira', '2.42 KB',
                '7/13/2024 9:22:21 PM', '7/13/2024 9:22:21 PM', true),
          ],
        ),
      ),
    );
  }

  // Widget to build each row in the table
  DataRow _buildUnitRow(String unit, String source, String size,
      String createTime, String latestUpdate, bool isEnabled) {
    return DataRow(
      cells: [
        DataCell(Row(
          children: [
            Icon(Icons.insert_drive_file, color: Colors.blue),
            SizedBox(width: 10),
            Text(unit),
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
