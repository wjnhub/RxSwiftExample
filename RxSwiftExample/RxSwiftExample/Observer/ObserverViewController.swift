//
//  ObserverViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ObserverViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        makeUI()
        bindView()
        
    }
    
    func loadData() {
        URLSession.shared.rx.data(request: URLRequest(url: URL(string: "http://www.baidu.com")!))
            .subscribe(onNext: { (data) in
                print("请求到的数据是： \(data)")
            }, onError: { (error) in
                print("错误信息：\(error)")
            }, onCompleted: {
                print("请求完成回调")
            }).disposed(by: disposeBag)
        
        // 等同于下面实现
        let observer: AnyObserver<Data> = AnyObserver { (event) in
            switch event {
            case .next(let data):
                print("请求到的数据是： \(data)")
            case .error(let error):
                print("错误信息：\(error)")
            default:
                break
            }
        }
        
        URLSession.shared.rx.data(request: URLRequest(url: URL(string: "http://www.baidu.com")!))
            .subscribe(observer).disposed(by: disposeBag)
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
