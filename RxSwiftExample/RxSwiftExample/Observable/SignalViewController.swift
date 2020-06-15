//
//  SignalViewController.swift
//  WjnHub
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
Signal特征
* 不会产生error事件
* 一定在MainScheduler监听（主线程监听）
* 共享附加作用

适用：和Driver类似，区别是 Driver会对新观察者回放上一个元素，而Signal不会
 一般*状态序列*选Driver    *事件序列*选Signal
*/

import UIKit
import RxCocoa
import RxSwift

class SignalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        makeUI()
        
        stateExample()
        
//        driverExample()

        signalExample()
        
        
    }
    
    func signalExample() {
        
        let event: Signal<Void> = submitButton.rx.tap.asSignal()
        
        let observer: () -> Void = { self.showAlert("弹框1") }
        event.emit(onNext: observer)
        
        let newObserver: () -> Void = { self.showAlert("弹框2") }
        event.emit(onNext: newObserver)
    }
    
    func driverExample() {
        
        let event: Driver<Void> = submitButton.rx.tap.asDriver()
        
        let observer: () -> Void = { self.showAlert("弹框1") }
        event.drive(onNext: observer)
        
        let newObserver: () -> Void = { self.showAlert("弹框2") }
        event.drive(onNext: newObserver)
    }
    
    func stateExample() {
        let state: Driver<String?> = userNameTextField.rx.text.asDriver()
        
        let observer = userNameLabel.rx.text
        state.drive(observer)
        
        let newObserver = userNameSizeLabel.rx.text
        state.map { $0?.count.description }.drive(newObserver)
    }
    
    func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(userNameTextField)
        view.addSubview(userNameLabel)
        view.addSubview(userNameSizeLabel)
        view.addSubview(submitButton)
        
        userNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalTo(0)
            make.height.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameTextField.snp_bottomMargin).offset(20)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        userNameSizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp_bottomMargin).offset(20)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.top.equalTo(userNameSizeLabel.snp_bottomMargin).offset(20)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
    }

    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入用户名"
        tf.backgroundColor = .green
        return tf
    }()

    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    lazy var userNameSizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.textAlignment = .center
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("提交", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var showAlert: (String) -> Void = { string in
        let alert = UIAlertController(title: "提示", message: string, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true) {
            
        }
    }
}
