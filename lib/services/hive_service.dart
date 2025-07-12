import 'package:hive/hive.dart';
import '../models/employee.dart';

class HiveService {
  static Box<Employee> get employeeBox => Hive.box<Employee>('employees');

  static List<Employee> getAllEmployees() => employeeBox.values.toList();

  static void addEmployee(Employee employee) => employeeBox.add(employee);

  static void deleteEmployee(int index) => employeeBox.deleteAt(index);

  static void updateEmployee(int index, Employee employee) => employeeBox.putAt(index, employee);
}