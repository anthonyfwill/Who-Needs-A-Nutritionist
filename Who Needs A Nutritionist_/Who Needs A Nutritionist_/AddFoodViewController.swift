//
//  AddFoodViewController.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 11/17/21.
//

import UIKit
import CoreData

protocol AddFoodViewControllerDelegate: AnyObject {
  func addFoodViewControllerDidCancel(
    _ controller: AddFoodViewController)
  func addFoodViewController(
    _ controller: AddFoodViewController,
    didFinishAdding item: ListMeals
  )
}

class AddFoodViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
        
    //MARK: - Instance Variable(s)
    var dateStr = ""
    
    var managedObjectContext: NSManagedObjectContext!
    
    weak var delegate: AddFoodViewControllerDelegate?
        
    override func viewDidLoad() {
      super.viewDidLoad()
        //Disable large titles
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.addFoodViewControllerDidCancel(self)
    }

    @IBAction func done() {
        let item = ListMeals(context: managedObjectContext)
        item.text = textField.text!
        item.checked = false
        item.date = dateStr
        print("AddController dateStr =", dateStr)
        item.id = UUID()
        do {
            try managedObjectContext.save()
            print(item.text, item.date)
            delegate?.addFoodViewController(self, didFinishAdding: item)
        } catch {
            fatalError("Error: \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        textField.becomeFirstResponder()
    }
    
    // MARK: - Text Field Delegates
    
    //Invoked every time the user changes the text, whether by tapping on the keyboard or via cut/paste
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
      if newText.isEmpty {
        doneBarButton.isEnabled = false
      } else {
        doneBarButton.isEnabled = true
      }
      return true
    }
}
