//
//  FoodInfoViewController.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 11/22/21.
//

import UIKit

class FoodInfoViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var mealName = ""
    var nutritionResults = [FoodNutrients]()
    weak var delegate: FoodInfoViewController?
    var dataTask: URLSessionDataTask?
    
    init(with mealName: String) {
        self.mealName = mealName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct TableView {
        struct CellIdentifiers {
          static let nutritionCell = "NutritionCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()

        //Disable large titles
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = .none
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Meals"
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.nutritionCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nutritionCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        //print("FoodInfoController mealName =", mealName)
        getFoodNutrition()
    }
    
    // MARK: - Helper Methods
    func FoodsdataCentralURL(searchText: String) -> URL {
      let encodedText = searchText.addingPercentEncoding(
          withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let API_KEY = "gotUqapLVp8iesREkuZAFXqCuSPuQZsONKkRvs7C"
        let urlString = String(format: "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=\(API_KEY)&query=%@", encodedText)
      let url = URL(string: urlString)
      return url!
    }

    func performStoreRequest(with url: URL) -> Data? {
      do {
          return try Data(contentsOf:url)
      } catch {
       print("Download Error: \(error.localizedDescription)")
       showNetworkError()
       return nil
      }
    }
    
    func parse(data: Data) -> [FoodNutrients] {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(
          Food.self, from: data)
          if result.foods.count == 0 {
              return []
          }
          return result.foods[0].foodNutrients
      } catch {
        print("JSON Error: \(error)")
        return []
      }
    }
    
    func showNetworkError() {
      let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing FoodAPI Central." + " Please try again.", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
}

extension FoodInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func getFoodNutrition() {
        dataTask?.cancel()
        nutritionResults = []
        let nameOfMeal = mealName
        print("Search meal:", nameOfMeal)
        
        let url = FoodsdataCentralURL(searchText: nameOfMeal)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url) {data, response, error in
                if let error = error as NSError?, error.code == -999 {
                    return
                } else if let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 {
                    if let data = data {
                      self.nutritionResults = self.parse(data: data)
                      DispatchQueue.main.async {
                          self.tableView.reloadData()
                      }
                        return
                    }
                } else {
                  print("Failure! \(response!)")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
            }
        dataTask?.resume()
        title = nameOfMeal
    }

    
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
      if nutritionResults.count == 0 {
        return 1
      } else {
        return nutritionResults.count
      }
    }

    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if nutritionResults.count == 0{
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nutritionCell, for: indexPath) as! NutritionCell
        let foodResult = nutritionResults[indexPath.row]
        cell.amountLabel.text = String(foodResult.value)
        cell.nutrientLabel.text = foodResult.nutrientName
        
        return cell
    }

    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
}
