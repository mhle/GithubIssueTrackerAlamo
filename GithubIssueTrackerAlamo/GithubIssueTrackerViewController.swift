//
//  ViewController.swift
//  GithubIssueTrackerAlamo
//
//  Created by Michael Le on 13/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GithubIssueTrackerViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  let disposeBag = DisposeBag()
  var repositoryNetworkModel: RepositoryNetworkModel!
  
  var searchBarText: Observable<String> {
    return searchBar.rx.text
      .orEmpty
      .filter { $0.characters.count > 0 }
      .debounce(0.3, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
  }

  func setupRx() {
    repositoryNetworkModel = RepositoryNetworkModel(withNameObservable: searchBarText)
    
    repositoryNetworkModel.rx_repositories
      .drive(tableView.rx.items(cellIdentifier: "IssueCell")) { (_, result, cell) in
        cell.textLabel?.text = result.name
      }
      .addDisposableTo(disposeBag)
    
    repositoryNetworkModel.rx_repositories
      .filter { $0.count == 0 }
      .drive(onNext: { repositories in
        let alert = UIAlertController(title: ":(", message: "No repositories found for this user", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
          self.present(alert, animated: true, completion: nil)
        }
        
      })
      .addDisposableTo(disposeBag)
  
  }


}

