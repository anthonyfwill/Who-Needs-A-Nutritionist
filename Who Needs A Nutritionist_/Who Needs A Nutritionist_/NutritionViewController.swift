//
//  ViewController.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 11/17/21.
//

import UIKit
import CoreData

class NutritionistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddFoodViewControllerDelegate, UINavigationControllerDelegate, MealCellDelegate {
    
    struct TableView {
        struct CellIdentifiers {
          static let mealsCell = "MealCell"
        }
    }
    
    lazy var anthonysDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    func buttonPressed(sender: MealCell, buttonPressed: Bool, id: UUID) {
        print("\(buttonPressed)", "\(id)")
        if let indexPath = tableView.indexPath(for: sender) {
            if let cell = tableView.cellForRow(at: indexPath){
                let item = mealsList[indexPath.row]
                print(item.text)
                if item.id == id {
                    item.checked = !item.checked
                    print("Configuring Checkmark")
                    configureCheckmark(for: cell as! MealCell, with: item, with2: indexPath)
                }
            }
        }
        do {
            try managedObjectContext.save()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let recentUsedDate = UserDefaults.standard.string(forKey: "MostRecentDate") ?? ""
        if recentUsedDate != "" {
            dateStr = UserDefaults.standard.string(forKey: "MostRecentDate")!
            self.date.text = dateStr
            self.dateButton.setTitle(dateStr, for: .normal)
            
            let dateFrom = dateStr
            
            let fetchRequest = NSFetchRequest<DateEntity>()
            let predic = NSPredicate(format: "date == %@ ", dateFrom)
            fetchRequest.predicate = predic
            
            fetchRequest.sortDescriptors = [.dateSortDescriptor]
            
            let entity = DateEntity.entity()
            fetchRequest.entity = entity
            
            do {
                dateEntity = try managedObjectContext.fetch(fetchRequest)
                currentDateEntity = dateEntity.first
                tableView.reloadData()
                print("entity count:", "\(dateEntity.count)")
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
    
    //MARK: - Outlet
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var date: UITextField!
    
    //MARK: - Instance Variable(s)
    var dateStr = ""
    
    var managedObjectContext: NSManagedObjectContext!
    var dateEntity = [DateEntity]()
    var currentDateEntity: DateEntity?
    var mealsList: [ListMeals] {
        get {
            return currentDateEntity?.meals?.allObjects as? [ListMeals] ?? []
        }
    }
    
    
    //MARK: - Current Date
    func currentDate() {
        let formats = anthonysDateFormatter
        self.date.text = formats.string(from: datePicker.date)
        dateStr = formats.string(from: datePicker.date)
        self.dateButton.setTitle(dateStr, for: .normal)
        print("\(dateStr)")
    }
    
    //MARK: - Save Entity
    func saveData(reload: Bool) {
        do {
            try managedObjectContext.save()
            if reload {
                tableView.reloadData()
            }
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    // MARK: - Add FoodViewController Delegates
    func addFoodViewControllerDidCancel(
      _ controller: AddFoodViewController
    ) {
      navigationController?.popViewController(animated: true)
    }

    func addFoodViewController(
      _ controller: AddFoodViewController,
      didFinishAdding mealAdded: ListMeals
    ) {
        let formats = anthonysDateFormatter
        let dateFrom = dateStr
        
        let fetchRequest = NSFetchRequest<DateEntity>()
        let predic = NSPredicate(format: "date == %@ ", dateFrom)
        fetchRequest.predicate = predic
        
        fetchRequest.sortDescriptors = [.dateSortDescriptor]
        
        let entity = DateEntity.entity()
        fetchRequest.entity = entity
        
        do {
            dateEntity = try managedObjectContext.fetch(fetchRequest)
            if let currentDateEntity2 = dateEntity.first {
                currentDateEntity2.addToMeals(mealAdded)
                currentDateEntity = currentDateEntity2
            } else {
                let newDateEntity = DateEntity(context: managedObjectContext)
                newDateEntity.date = formats.string(from: datePicker.date)
                newDateEntity.addToMeals(mealAdded)
                currentDateEntity = newDateEntity
            }
            try managedObjectContext.save()
            tableView.reloadData()
            navigationController?.popViewController(animated: true)
            print("entity count:", "\(dateEntity.count)")
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let formats = anthonysDateFormatter
        let dateFrom = formats.string(from: datePicker.date)
        
        let fetchRequest = NSFetchRequest<DateEntity>()
        let predic = NSPredicate(format: "date == %@ ", dateFrom)
        fetchRequest.predicate = predic
        
        fetchRequest.sortDescriptors = [.dateSortDescriptor]
        
        let entity = DateEntity.entity()
        fetchRequest.entity = entity
        
        do {
            dateEntity = try managedObjectContext.fetch(fetchRequest)
            currentDateEntity = dateEntity.first
            print("entity count:", "\(dateEntity.count)")
        } catch {
            fatalCoreDataError(error)
        }
        createDatePicker()
        currentDate()
        let cellNib = UINib(nibName: TableView.CellIdentifiers.mealsCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.mealsCell)
    }
    
    
    // MARK: - Source1 - https://www.youtube.com/watch?v=8NngJrVFfUw&t=209s

    let datePicker = UIDatePicker()
    
    func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        return toolbar
    }
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        date.inputView = datePicker
        date.inputAccessoryView = createToolBar()
    }
    
    @objc func donePressed() {
        let dateFormatter = anthonysDateFormatter
        
        let dateFrom = dateFormatter.string(from: datePicker.date)
        
        let fetchRequest = NSFetchRequest<DateEntity>()
        let predic = NSPredicate(format: "date == %@ ", dateFrom)
        fetchRequest.predicate = predic
        
        fetchRequest.sortDescriptors = [.dateSortDescriptor]
        
        let entity = DateEntity.entity()
        fetchRequest.entity = entity
        
        do {
            dateEntity = try managedObjectContext.fetch(fetchRequest)
            currentDateEntity = dateEntity.first
            print("entity count:", "\(dateEntity.count)")
        } catch {
            fatalCoreDataError(error)
        }
        
        self.date.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        dateStr = date.text!
        self.dateButton.setTitle(dateStr, for: .normal)
        UserDefaults.standard.set(dateStr, forKey: "MostRecentDate")
        tableView.reloadData()
        print("\(dateStr)")
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.mealsCell, for: indexPath) as! MealCell
        let item = mealsList[indexPath.row]
        cell.id = item.id
        cell.checkLabel.text = ""
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item, with2: indexPath)
        cell.delegate = self
        saveData(reload: false)
        return cell
    }
    
    // MARK: - Table View Delegate
    func configureCheckmark(
      for cell: MealCell,
      with item: ListMeals, with2 indexPath: IndexPath
    ) {
        if item.checked {
            cell.checkLabel.text = "√"
            UIView.animate(withDuration: 1, delay: 0, options: [],
                         animations: {
            cell.backgroundColor = UIColor.green})
            tableView.reloadRows(at: [indexPath], with: .none)
      } else {
          cell.checkLabel.text = ""
          UIView.animate(withDuration: 1, delay: 0, options: [],
                             animations: {
                cell.backgroundColor = UIColor.clear})
          tableView.reloadRows(at: [indexPath], with: .none)
      }
    }

    func configureText(
      for cell: MealCell,
      with item: ListMeals
    ) {
        print(item.text)
        cell.foodLabel.text = item.text
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
      
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            let item = mealsList[indexPath.row]
            print("Clicked:", item.text)
            let foodInfoVC = FoodInfoViewController(with: item.text)
            navigationController?.pushViewController(foodInfoVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ) {
      if segue.identifier == "AddFood" {
          let controller = segue.destination as! AddFoodViewController
          controller.delegate = self
          controller.dateStr = dateStr
          controller.managedObjectContext = managedObjectContext
      }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = mealsList[indexPath.row]
        managedObjectContext.delete(item)
        saveData(reload: true)
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

extension NSSortDescriptor {
    static let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
}

    //MARK: - Save Items/Data Saving
let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
  return paths[0]
}()

let dataSaveFailedNotification = Notification.Name(
  rawValue: "DataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
  print("*** Fatal error: \(error)")
  NotificationCenter.default.post(
    name: dataSaveFailedNotification,
    object: nil)
}

