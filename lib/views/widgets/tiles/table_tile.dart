import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:research_buddy/models/project.dart';

class RecordTableFieldTile extends StatelessWidget {
  final ProjectField field;
  final List<String> columnNames;
  final dynamic value;

  const RecordTableFieldTile(
      {Key? key,
      required this.field,
      required this.columnNames,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! String) {
      return ListTile(
        title: const Text("Data Not Set"),
        subtitle: Text(field.name),
      );
    }

    final data = value.split(",").map((e) => e.split("|")).toList();

    return ListTile(
      title: Text(field.name),
      subtitle: const Text("Press to view"),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordSeriesDataTable(
              field: field,
              columnNames: columnNames,
              data: data,
            ),
          ),
        );
      },
    );
  }
}

class RecordSeriesDataTable extends StatelessWidget {
  final ProjectField field;
  final List<String> columnNames;
  final List<List<String>> data;

  const RecordSeriesDataTable(
      {Key? key,
      required this.field,
      required this.columnNames,
      required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(field.name),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    for (int i = 0; i < columnNames.length; i++)
                      DataColumn(label: Text(columnNames[i]))
                  ],
                  rows: [
                    for (int i = 0; i < data.length; i++)
                      DataRow(cells: [
                        DataCell(
                            Text(extractTime(DateTime.tryParse(data[i][0])))),
                        for (int j = 1; j < columnNames.length; j++)
                          if (data[i].length < j + 1)
                            const DataCell(Text("N/A"))
                          else
                            DataCell(Text(data[i][j]))
                      ])
                  ],
                ),
              ),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  child: const Text("Close"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String extractTime(DateTime? timestamp) {
    final timestampVal = timestamp;
    if (timestampVal == null) return "";
    return DateFormat('kk:mm:ss').format(timestampVal);
  }
}
