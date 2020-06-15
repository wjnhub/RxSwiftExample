//
//  BehaviorSubjectViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
 当观察者对BehavorSubject进行订阅时，它会将源`Observable`中最新的元素发出来（如果不存在最新元素，发出默认元素）
 如果源Observable因为产生一个error事件而终止，PublishSubject不会发出任何元素，而是将error事件发送出来
 */

import UIKit
import RxSwift
import RxCocoa

class BehaviorSubjectViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "💰")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        subject.subscribe{ print("subscription： 1 Event", $0) }.disposed(by: disposeBag)
        
        subject.onNext("🐈")
        subject.onNext("🐩")
        
        subject.subscribe{ print("subscription： 2 Event", $0) }.disposed(by: disposeBag)
        
        subject.onNext("😊")
        subject.onNext("😭")
        
        subject.subscribe{ print("subscription： 3 Event", $0) }.disposed(by: disposeBag)
        
        subject.onNext("🍑")
        subject.onNext("🍒")
        
        /**
         输出结果
         subscription： 1 Event next(💰)
         subscription： 1 Event next(🐈)
         subscription： 1 Event next(🐩)
         subscription： 2 Event next(🐩)
         subscription： 1 Event next(😊)
         subscription： 2 Event next(😊)
         subscription： 1 Event next(😭)
         subscription： 2 Event next(😭)
         subscription： 3 Event next(😭)
         subscription： 1 Event next(🍑)
         subscription： 2 Event next(🍑)
         subscription： 3 Event next(🍑)
         subscription： 1 Event next(🍒)
         subscription： 2 Event next(🍒)
         subscription： 3 Event next(🍒)
         */

    }
    
    

}
