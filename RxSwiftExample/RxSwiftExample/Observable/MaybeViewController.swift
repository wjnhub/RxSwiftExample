//
//  MaybeViewController.swift
//  WjnHub
//
//  Created by wjn on 2020/6/12.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
Maybe特征
* 发出一个元素或发出一个completed事件或error事件
* 不会共享附加作用

适用：可能需要发出一个元素 也可能不需要发出
*/

import UIKit
import RxCocoa
import RxSwift

class MaybeViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateString().subscribe(onSuccess: { (element) in
            print("返回一个元素：\(element)")
        }, onError: { (error) in
            print("返回一个error： \(error)")
        }) {
            print("完成回调")
        }.disposed(by: disposeBag)
    }
    
    func generateString() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            // 返回一个元素
            maybe(.success("swift"))
            // 或者 返回完成回调
            maybe(.completed)
            // 或者 返回一个错误信息
            let error = DataError.cantParseJSON
            maybe(.error(error))
            
            return Disposables.create {}
        }
    }

}
