//
//  DisposableViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DisposableViewController: UIViewController {
    
    var disposable: Disposable?
    let disposeBag = DisposeBag() // 推荐使用

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        makeUI()
        
        self.disposable = userNameTextField.rx.text.orEmpty.subscribe(onNext: { (text) in
            print(text)
            })
        
        clearButton.rx.tap.subscribe(onNext: { [weak self](event) in
            self?.disposable?.dispose()
        }).disposed(by: disposeBag)
        
    }
    
    
    
    func makeUI() {
        view.backgroundColor = .white
        view.addSubview(userNameTextField)
        view.addSubview(clearButton)
        
        userNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.right.equalTo(0)
            make.height.equalTo(80)
        }
        
        clearButton.snp.makeConstraints { (make) in
            make.top.equalTo(userNameTextField.snp_bottomMargin).offset(20)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
    }
    
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .orange
        tf.placeholder = "请输入用户名"
        return tf
    }()

 
    lazy var clearButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.backgroundColor = .blue
        bt.setTitle("清除订阅", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        return bt
    }()

}
