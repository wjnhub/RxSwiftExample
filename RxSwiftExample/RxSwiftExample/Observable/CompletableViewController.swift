//
//  CompletableViewController.swift
//  WjnHub
//
//  Created by wjn on 2020/6/12.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
Completable特征
* 发出零个元素
* 发出一个completed事件或error事件
* 不会共享附加作用

适用：只关心完成情况，不关心返回值的情况
*/

import UIKit
import RxSwift
import RxCocoa

enum CacheError: Error {
    case failedCaching
    case successCached
}

class CompletableViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        cacheLocally().subscribe(onCompleted: {
            print("已完成")
        }) { (error) in
            print("未完成:\(error)")
        }.disposed(by: disposeBag)
    }
    
    func cacheLocally() -> Completable {
        return Completable.create { completable in
            // 需要完成的事
            // .....
            let success = true
            
            guard success else {
                completable(.error(CacheError.failedCaching))
                return Disposables.create {}
            }
            
            completable(.completed)
            return Disposables.create {}
        }
    }

}
