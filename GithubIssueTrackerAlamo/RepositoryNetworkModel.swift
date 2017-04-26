//
//  RepositoryNetworkModel.swift
//  GithubIssueTrackerAlamo
//
//  Created by Michael Le on 14/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import RxAlamofire
import Alamofire

struct RepositoryNetworkModel {
  lazy public var rx_repositories: Driver<[Repository]> = self.fetchRepositories()
  private var repositoryName: Observable<String>
  
  init(withNameObservable nameObservable: Observable<String>) {
    repositoryName = nameObservable
  }
  
  private func fetchRepositories() -> Driver<[Repository]> {
    return repositoryName
      .subscribeOn(MainScheduler.instance)
      .do(onNext: { _ in UIApplication.shared.isNetworkActivityIndicatorVisible = true })
      .map { name in URL(string: "https://api.github.com/users/\(name)/repos")! }
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .flatMapLatest { url in RxAlamofire.requestJSON(.get, url).catchError { _ in Observable.never() } }
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .map { (response, json) in Mapper<Repository>().mapArray(JSONObject: json) ?? [] }
      .observeOn(MainScheduler.instance)
      .do(onNext: { _ in UIApplication.shared.isNetworkActivityIndicatorVisible = false })
      .asDriver(onErrorJustReturn: [])
  }
}
