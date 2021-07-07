//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

final class TaskListViewController: UITableViewController {
    // MARK: - Public properties
    var alertAction: ViewActions = .add
    
    // MARK: - Private properties
    private static let cellId = "cell"
    private var tasks: [Task] = []
    
    // MARK: - Override UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellId)
        tableView.dataSource = self
        setupNavigationBar()
        fetchData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    private func setupNavigationBar() {
        title = "Task List"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appeareance
        let navBarAppereance = UINavigationBarAppearance()
        navBarAppereance.configureWithOpaqueBackground()
        
        navBarAppereance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppereance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppereance.backgroundColor = UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 194 / 255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppereance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppereance
        
        // Add button to nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
//        let newTaskVC = NewTaskViewController()
//        newTaskVC.action = ViewActions.add
//        newTaskVC.modalPresentationStyle = .fullScreen
//        present(newTaskVC, animated: true)
        
        showAlert(with: "New Task", message: "What do you want to enter?", indexPath: nil)
    }
    
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        tasks = DataManager.shared.fetchTask(fetchRequest)
    }
}

// MARK: - Extension: Data Source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellId, for: indexPath)
        let task = tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            
            DataManager.shared.viewContext.delete(task)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            DataManager.shared.saveContext()
        }
    }
    
    // MARK: - Extension: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        //let task = tasks[indexPath.row]
        /* Раскоментировать 2 строки для показа через алерт, закоментировать для показа через VC */
        alertAction = .update
        showAlert(with: "New Task", message: "What do you want to enter?", indexPath: indexPath)
        
        /* Раскоментировать остальные строки для показа через VC, закоментировать для показа через алерт */
//        let newTaskVC = NewTaskViewController()
//
//        newTaskVC.task = task
//        newTaskVC.action = ViewActions.update
//
//        newTaskVC.modalPresentationStyle = .fullScreen
//        present(newTaskVC, animated: true)
    }

}

// MARK: - Extension: Alerts
extension TaskListViewController {
    private func showAlert(with title: String, message: String, indexPath: IndexPath?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(
            title: "Save",
            style: .default) { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            self.save(text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        let updateAction = UIAlertAction(
            title: "Update",
            style: .default) { _ in
            guard let indexPath = indexPath else { return }
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            self.update(indexPath: indexPath, text: text)
        }
        
        alert.addTextField()
        
        switch alertAction {
        case .add:
            alert.addAction(saveAction)
        case .update:
            guard let indexPath = indexPath else { return }
            let task = self.tasks[indexPath.row]
            alert.textFields?.first?.text = task.title
            alert.addAction(updateAction)
        }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func save(_ text: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: DataManager.shared.viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: DataManager.shared.viewContext) as? Task else { return }
        
        task.title = text
        
        DataManager.shared.saveContext()
        
        tasks.append(task)
        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
        
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
    }
    
    private func update(indexPath: IndexPath, text: String) {
        alertAction = .update
        
        guard !text.isEmpty else { return }
        
        let task = self.tasks[indexPath.row]
        
        task.title = text
        
        DataManager.shared.saveContext()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
