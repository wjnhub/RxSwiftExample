//
//  BinderViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BinderViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeUI()
        bindView()
    }
    
    func bindView() {
        let userNameValid = userNameTextField.rx.text.orEmpty
            .map{ $0.count > 6}.share(replay: 1)
        
        userNameValid.bind(to: userNameValidLabel.rx.isHidden).disposed(by: disposeBag)
        
        // 等同于下面实现
        let observer: AnyObserver<Bool> = AnyObserver{[weak self](event) in
            switch event {
            case .next(let isHidden):
                self?.userNameValidLabel.isHidden = isHidden
            default:
                break
            }
        }
        userNameValid.bind(to: observer).disposed(by: disposeBag)
        
        // 该示例是一个UI观察者，所以他在响应事件时，只会处理next事件，并且更新UI的操作需要在主线程执行，用Binder更适合
        let oberver1: Binder<Bool> = Binder(userNameValid) { (view, isHidden) in
            self.userNameValidLabel.isHidden = isHidden
        }
        userNameValid.bind(to: oberver1).disposed(by: disposeBag)
        
        // 由于页面是否隐藏是一个常用观察者，所以应该让所有UIView都提供这种观察者 extension实现
        userNameValid.bind(to: userNameValidLabel.rx.isHidden).disposed(by: disposeBag)
        // 这就是我们最上面的实现过程，可以通过这种方式创建自定义UI观察者
        
    }
    
    func makeUI() {
        view.addSubview(userNameTextField)
        view.addSubview(userNameValidLabel)
        
        userNameTextField.snp.makeConstraints { (make) in
           make.top.equalTo(60)
           make.left.right.equalTo(0)
           make.height.equalTo(80)
       }
        
        userNameValidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameTextField.snp_bottomMargin).offset(20)
            make.left.equalTo(0)
        }
    }
    
    lazy var userNameValidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "用户名不符合要求啊"
        label.isHidden = true
        return label
    }()
    
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入用户名"
        tf.backgroundColor = .green
        return tf
    }()

}

extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { view, hidden in
            view.isHidden = hidden
        }
    }
}
