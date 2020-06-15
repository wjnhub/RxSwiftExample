//
//  ReplaySubjectViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
 ReplaySubject将对观察者发送全部元素，无论观察者何时进行订阅
 `bufferSize`可以设置订阅前最新的`n`个元素发送给观察者
 不要在多个线程调用 `onNext`,     `onError`或`onCompleted` 会导致无序调用，造成意想不到的结果
 */

import UIKit
import RxSwift
import RxCocoa

class ReplaySubjectViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
         subscription： 2 Event next(🐢)
         subscription： 1 Event next(🚫)
         subscription： 2 Event next(🚫)
         subscription： 1 Event next(🍚)
         subscription： 2 Event next(🍚)
         */
    }
    


}
