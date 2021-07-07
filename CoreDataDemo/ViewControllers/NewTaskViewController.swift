//
//  NewTaskViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

final class NewTaskViewController: UIViewController {
    // MARK: - Public properties
    var task: Task?
    
    var action: ViewActions = ViewActions.add
    
    // MARK: - Private properties
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = UIButton.customSetting(
        buttonColor: UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 1
        ),
        title: "Save Task",
        font: .boldSystemFont(ofSize: 18),
        titleColor: .white,
        radius: 4,
        target: self,
        action: #selector(save)
    )
    
    private lazy var cancelButton: UIButton = UIButton.customSetting(
        buttonColor: UIColor(
            red: 240 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 1
        ),
        title: "Cancel Task",
        font: .boldSystemFont(ofSize: 18),
        titleColor: .white,
        radius: 4,
        target: self,
        action: #selector(cancel)
    )
    
    /* New properties for new action */
    private lazy var updateButton: UIButton = UIButton.customSetting(
        buttonColor: UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 1
        ),
        title: "Update Task",
        font: .boldSystemFont(ofSize: 18),
        titleColor: .white,
        radius: 4,
        target: self,
        action: #selector(update)
    )
    
    private lazy var setupedAction: UIView = setupAction(action)
    
    // MARK: - Override UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        taskTextField.text = task?.title
        
        setupViews([taskTextField, cancelButton, setupedAction])
        setConstraints()
    }
    
    // MARK: - Private methods
    private func setupAction(_ action: ViewActions) -> UIView {
        switch action {
        case .add:
            return saveButton
        case .update:
            return updateButton
        }
    }
    
    private func setupViews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        taskTextField.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            paddingTop: 80,
            paddingLeft: 40,
            paddingBottom: 0,
            paddingRight: -40,
            width: 0,
            height: 0,
            enableInsets: false
        )
        
        setupedAction.anchor(
            top:  taskTextField.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            paddingTop: 20,
            paddingLeft: 40,
            paddingBottom: 0,
            paddingRight: -40,
            width: 0,
            height: 0,
            enableInsets: false
        )
        
        cancelButton.anchor(
            top:  setupedAction.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            paddingTop: 20,
            paddingLeft: 40,
            paddingBottom: 0,
            paddingRight: -40,
            width: 0,
            height: 0,
            enableInsets: false
        )
    }
    
    @objc private func save() {
        guard let text = taskTextField.text else { return }
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: DataManager.shared.viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto:  DataManager.shared.viewContext) as? Task else { return }
        
        task.title = text
        
        DataManager.shared.saveContext()
        
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func update() {
        guard let task = task else { return }
        guard let newText = taskTextField.text else { return }
        
        task.title = newText
        
        DataManager.shared.saveContext()
        
        dismiss(animated: true)
    }
}
