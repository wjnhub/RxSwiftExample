//
//  ObservableViewController.swift
//  WjnHub
//
//  Created by wjn on 2020/6/12.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
 Observable 可监听的序列
 再RXSwift里，Observable存在一些特征序列，利用语法糖简化序列
 Single
 Completable
 Maybe
 Driver
 Signal
 ControlEvent
 */

import UIKit
import RxSwift
import RxCocoa

enum DataError: Error {
    case cantParseJSON
}

class ObservableViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        json.subscribe(onNext: { (json) in
            print("请求成功的json数据： \(json)")
        }, onError: { (error) in
            print("error: \(error)")
        }, onCompleted: {
            print("请求json完成")
        }).disposed(by: disposeBag)
    }
    
    typealias JSON = Any
    
       
       let json: Observable<JSON> = Observable.create { (observer) -> Disposable in
           let url = URL(string: "http://www.baidu.com")
           let task = URLSession.shared.dataTask(with: url!) { (data, _, error) in
               guard error == nil else {
                   observer.onError(error!)
                   return
               }
            
               guard let data = data,
                     let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
                        observer.onError(DataError.cantParseJSON)
                       return
               }
               
               observer.onNext(data)
               observer.onCompleted()
           }
           task.resume()
           return Disposables.create {
               task.cancel()
           }
       }

}
