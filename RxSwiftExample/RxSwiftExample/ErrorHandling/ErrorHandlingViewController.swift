//
//  ErrorHandlingViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

class ErrorHandlingViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rxData: Observable<Data> = Observable.create { (observer) -> Disposable in
            
            guard let data = try? Data(contentsOf: URL(string: "http://www.baidu.com")!) else {
                observer.onError(DataError.cantParseJSON)
                return Disposables.create{}
            }
            observer.onNext(data)
            observer.onCompleted()
            return Disposables.create{}
        }
        
        // `retry`重试
        rxData.retry(3)//尝试3次仍失败，抛出异常
            .subscribe(onNext: { (data) in
                print("取得数据成功: \(data)")
            }, onError: { error in
                print("取得数据失败: \(error)")
            }).disposed(by: disposeBag)
        
        
        // `retryWhen` 当发生错误时，经过一段时间重试
        let retryDelay: Double = 5 //重试延时5秒
        rxData.retryWhen { (rxError: Observable<Error>) -> Observable<Int> in
            return Observable.timer(retryDelay, scheduler: MainScheduler.instance)
        }.subscribe(onNext: { (data) in
            print("取得数据成功: \(data)")
        }, onError: { (error) in
            print("取得数据失败: \(error)")
            }).disposed(by: disposeBag)
        
        // 请求失败，等待5秒重试，重试4次仍然失败，抛出异常
        let maxRetryCount = 4
        
        rxData.retryWhen { (rxError: Observable<Error>) -> Observable<Int> in
            return rxError.enumerated().flatMap { (index, error) -> Observable<Int> in
                guard index < maxRetryCount else {
                    return Observable.error(error)
                }
                return Observable.timer(retryDelay, scheduler: MainScheduler.instance)
            }
        }.subscribe(onNext: { (data) in
            print("取得数据成功: \(data)")
        }, onError: { (error) in
            print("取得数据失败: \(error)")
            }).disposed(by: disposeBag)
        
        // catchError 恢复，在错误产生时，用一个备用元素将错误替换掉
        
        // Result
//        makeUI()
//
//        let rxUserInfo = userNameTextField.rx.text
//        updateUserInfoButton.rx.tap.withLatestFrom(rxUserInfo)
//            .flatMapLatest { userInfo -> Observable<Result<Void, Error>> in
//                return update(userInfo)
//                    .map(Result.success)
//                    .carchError{error in Observable.just(Result.failure(error))}
//            }
//        .observeOn(MainScheduler.instance)
//        .subscribe(onNext: { result in
//            switch result {           // 处理 Result
//            case .success:
//                print("用户信息更新成功")
//            case .failure(let error):
//                print("用户信息更新失败： \(error.localizedDescription)")
//            }
//        })
//        .disposed(by: disposeBag)
        
    }
    
    
    
  
    
    func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(userNameTextField)
        view.addSubview(updateUserInfoButton)
        
        
        userNameTextField.snp.makeConstraints { (make) in
           make.top.equalTo(100)
           make.left.right.equalTo(0)
           make.height.equalTo(80)
       }
        
        updateUserInfoButton.snp.makeConstraints { (make) in
            make.top.equalTo(userNameTextField).offset(20)
            make.left.right.equalTo(0)
            make.bottom.equalTo(50)
        }
    }
    
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .orange
        tf.placeholder = "请输入用户名"
        return tf
    }()
    
    
    lazy var updateUserInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.setTitle("更新用户信息", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    


}
