//
//  AsyncSubjectViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
 AsyncSubject将在源Observable产生完成事件后，发出最后一个元素（仅仅只有最后一个元素）
 如果源Observable没有发出任何元素，只有一个完成事件，那AsyncSubject也只有一个完成事件。
 如果源Observable因为产生一个error事件而终止，AsyncSubject不会发出任何元素，而是将error事件发送出来
 */

import UIKit
import RxCocoa
import RxSwift

class AsyncSubjectViewController: UIViewController {

    let disposeBag = DisposeBag()
    let subject = AsyncSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subject.subscribe { print("subscription: 1Event: ", $0) }.disposed(by: disposeBag)
        
        subject.onNext("🐈")
        subject.onNext("🐩")
        subject.onNext("🐢")
        
        subject.onCompleted()
        
        /**
         返回结果
         subscription: 1Event:  next(🐢)
         subscription: 1Event:  completed
         */
    }
    
    

}
