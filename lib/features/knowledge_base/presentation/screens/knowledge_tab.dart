import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/knowledge_unit_view.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/knowledge_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/providers/knowledge_provider.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/update_knowledge_dialog.dart';
import 'package:provider/provider.dart';

class KnowledgeTab extends StatefulWidget {
  const KnowledgeTab({super.key});

  @override
  State<KnowledgeTab> createState() => _KnowledgeTabState();
}

class _KnowledgeTabState extends State<KnowledgeTab> {
  List<KnowledgeResDto>? knowledges;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final knowledgeProvider =
          Provider.of<KnowledgeProvider>(context, listen: false);
      knowledgeProvider.getKnowledges();
    });
  }

  @override
  Widget build(BuildContext context) {
    KnowledgeProvider knowledgeProvider =
        Provider.of<KnowledgeProvider>(context);

    knowledges = knowledgeProvider.filteredKnowledges;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(knowledgeProvider),
          SizedBox(height: 20),
          _buildToolKnowledgeSection(knowledgeProvider),
          SizedBox(height: 20),
          knowledges == null
              ? Center(child: CircularProgressIndicator())
              : _buildKnowledgeTableSection(knowledgeProvider),
        ],
      ),
    );
  }

  Widget _buildToolKnowledgeSection(KnowledgeProvider knowledgeProvider) {
    return Row(
      children: [
        _buildCreateKnowledgeButton(knowledgeProvider),
      ],
    );
  }

  Widget _buildKnowledgeTableSection(KnowledgeProvider knowledgeProvider) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: DataTable(
              columnSpacing: 5.0,
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text('Knowledge')),
                DataColumn(label: Text('Units')),
                DataColumn(label: Text('Size')),
                DataColumn(label: Text('Edit time')),
                DataColumn(label: Text('Action')),
              ],
              rows: knowledges!.map((knowledge) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          const Icon(
                            Icons.storage,
                            size: 24,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  knowledge.knowledgeName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  knowledge.description,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(knowledge.numUnits.toString())),
                    DataCell(Text(knowledge.totalSize.toString())),
                    DataCell(Text(knowledge.updatedAt)),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await knowledgeProvider.deleteKnowledge(
                                id: knowledge.id);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showUpdateKnowledgeDialog(
                                context, knowledgeProvider, knowledge);
                          },
                        ),
                      ],
                    )),
                  ],
                  onSelectChanged: (selected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeUnitView(
                          knowledge: knowledge,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        Text('1'),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCreateKnowledgeButton(KnowledgeProvider knowledgeProvider) {
    return ElevatedButton.icon(
      onPressed: () {
        showCreateKnowledgeDialog(context, knowledgeProvider);
      },
      label: Text(
        "Create Knowledge",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  void showCreateKnowledgeDialog(
      BuildContext context, KnowledgeProvider knowledgeProvider) {
    showDialog(
      context: context,
      builder: (builder) {
        return CreateKnowledgeDialog(
          onCreatedKnowledgeBase: (String name, String description) async {
            try {
              await knowledgeProvider.createKnowledge(
                knowledgeName: name,
                description: description,
              );
            } catch (e) {
              print('Failed to create knowledge: $e');
            }
          },
        );
      },
    );
  }

  Widget _buildSearchBar(KnowledgeProvider knowledgeProvider) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: "Search Knowledge",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              searchQuery = searchController.text;
              knowledgeProvider.filterKnowledges(searchQuery);
            });
          },
        ),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
          knowledgeProvider.filterKnowledges(searchQuery);
        });
      },
    );
  }

  void showUpdateKnowledgeDialog(BuildContext context,
      KnowledgeProvider knowledgeProvider, KnowledgeResDto knowledge) {
    showDialog(
      context: context,
      builder: (builder) {
        return UpdateKnowledgeDialog(
          onUpdateKnowledgeBase: (String name, String description) async {
            try {
              await knowledgeProvider.updateKnowledge(
                id: knowledge.id,
                knowledgeName: name,
                description: description,
              );
            } catch (e) {
              print('Failed to create knowledge: $e');
            }
          },
          knowledgeName: knowledge.knowledgeName,
          knowledgeDescription: knowledge.description,
        );
      },
    );
  }
}
