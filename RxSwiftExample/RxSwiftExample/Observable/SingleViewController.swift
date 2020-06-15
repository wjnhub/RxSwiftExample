//
//  SingleViewController.swift
//  WjnHub
//
//  Created by wjn on 2020/6/12.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
 Single特征
 * 发出一个元素或者error事件
 * 不会共享附加作用
 
适用： 类似HTTP请求，返回一个结果或错误
 */

import UIKit
import RxCocoa
import RxSwift

class SingleViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        getRepo("rxswift").subscribe(onSuccess: { (json) in
            print("JSON: \(json)")
        }) { (error) in
            print(error)
        }.disposed(by: disposeBag)
    
    }
    
    func getRepo(_ repo: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { single in
            let url = URL(string: "http://www.baidu.com/repos/\(repo)")
            let task = URLSession.shared.dataTask(with: url!) { (data, _, error) in
                guard error == nil else {
                    single(.error(error!))
                    return
                }
             
                guard let data = data,
                      let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                      let result = jsonObject as? [String : Any] else {
                        single(.error(DataError.cantParseJSON))
                        return
                }
                
                single(.success(result))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    

}
