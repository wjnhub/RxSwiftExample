//
//  PublishSubjectViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
 PublishSubject将对观察者发送订阅后产生的元素，而订阅前的元素不会发送给观察者。
 如果观察者接受所有元素，可通过使用`Observable`的`create`方法创建Observable，或者使用`ReplaySubject`
 如果源Observable因为产生一个error事件而终止，PublishSubject不会发出任何元素，而是将error事件发送出来

 */

import UIKit
import RxSwift
import RxCocoa

class PublishSubjectViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        subject.subscribe{ print("subscription： 1 Event", $0) }.disposed(by: disposeBag)
        
        subject.onNext("🐈")
        subject.onNext("🐩")
        subject.onNext("🐢")
        
        subject.subscribe{ print("subscription： 2 Event", $0) }.disposed(by: disposeBag)
        
        subject.onNext("🚫")
        subject.onNext("🍚")
        

        /**
         输出结果
         subscription： 1 Event next(🐈)
         subscription： 1 Event next(🐩)
         subscription： 1 Event next(🐢)
         subscription： 1 Event next(🚫)
         subscription： 2 Event next(🚫)
         subscription： 1 Event next(🍚)
         subscription： 2 Event next(🍚)
         */
    }
    
    
    
    
}
