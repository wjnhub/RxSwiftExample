//
//  SchedulersViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

/**

 `MainScheduler `代表主线程。如果你需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler 运行。

 `SerialDispatchQueueScheduler` 抽象了串行 DispatchQueue。如果你需要执行一些串行任务，可以切换到这个 Scheduler 运行。

 `ConcurrentDispatchQueueScheduler `抽象了并行 DispatchQueue。如果你需要执行一些并发任务，可以切换到这个 Scheduler 运行。

 `OperationQueueScheduler `抽象了 NSOperationQueue。

 它具备 NSOperationQueue 的一些特点，例如，你可以通过设置 `maxConcurrentOperationCount`，来控制同时执行并发任务的最大数量
 */

import UIKit
import RxCocoa
import RxSwift

class SchedulersViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gcdExample()
    }
    
    func gcdExample() {
        let rxData: Observable<Data> = Observable.create { (observer) -> Disposable in
            
            guard let data = try? Data(contentsOf: URL(string: "http://www.baidu.com")!) else {
                observer.onError(DataError.cantParseJSON)
                return Disposables.create{}
            }
            observer.onNext(data)
            observer.onCompleted()
            return Disposables.create{}
        }
        
        rxData.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))//切换到后台Scheduler获得Data
            .observeOn(MainScheduler.instance) // 切换到主线程来监听结果
            .subscribe(onNext: { (data) in
                print(data)
            }).disposed(by: disposeBag)
    }

    

}
