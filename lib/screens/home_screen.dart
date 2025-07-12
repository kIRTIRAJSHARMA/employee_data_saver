import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/hive_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final positionController = TextEditingController();

  void _addEmployee() {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text.trim());
    final position = positionController.text.trim();

    if (name.isNotEmpty && age != null && position.isNotEmpty) {
      final employee = Employee(name: name, age: age, position: position);
      HiveService.addEmployee(employee);
      nameController.clear();
      ageController.clear();
      positionController.clear();
      setState(() {});
    }
  }

  void _showEditDialog(int index, Employee emp) {
    final editNameController = TextEditingController(text: emp.name);
    final editAgeController = TextEditingController(text: emp.age.toString());
    final editPositionController = TextEditingController(text: emp.position);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: editAgeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: editPositionController,
                decoration: InputDecoration(labelText: 'Position'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editNameController.text.trim();
                final newAge = int.tryParse(editAgeController.text.trim());
                final newPosition = editPositionController.text.trim();

                if (newName.isNotEmpty && newAge != null && newPosition.isNotEmpty) {
                  HiveService.updateEmployee(index, Employee(name: newName, age: newAge, position: newPosition));
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employees = HiveService.getAllEmployees();

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Data Saver'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: positionController,
              decoration: InputDecoration(
                labelText: 'Position',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addEmployee,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: Text('Add Employee'),
            ),
            Divider(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return Card(
                    child: ListTile(
                      title: Text('${emp.name} (${emp.age})'),
                      subtitle: Text(emp.position),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(index, emp),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              HiveService.deleteEmployee(index);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}