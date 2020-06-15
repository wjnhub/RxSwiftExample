//
//  DriverViewController.swift
//  WjnHub
//
//  Created by wjn on 2020/6/12.
//  Copyright © 2020 wjn. All rights reserved.
//

/**
Driver特征
* 不会产生error事件
* 一定在MainScheduler监听（主线程监听）
* 共享附加作用

适用：简化UI层代码，驱动UI的序列
*/

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DriverViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        
        // 根据输入内容请求数据源
        let results = searchTextField.rx.text.asDriver()
            .flatMapLatest { (query) in
                self.getRepo(query!).asDriver(onErrorJustReturn: [])
        }
  
        // 数据源和计数Label绑定
        results.map { "\($0.count)" }
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 数据源和tableView绑定
        results.drive(tableView.rx.items(cellIdentifier: "cell")) { (row, result, cell) in
            cell.textLabel?.text = "\(result)"
        }.disposed(by: disposeBag)
        
        // 绑定tableView事件
        tableView.rx.itemSelected.bind { indexPath in
            print(indexPath)
        }.disposed(by: disposeBag)
        
        // 设置tableView Delegate/DataSource代理
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // tableView滚动收回键盘
        tableView.rx.didScroll.subscribe { [weak self](event) in
            self?.searchTextField.endEditing(true)
        }.disposed(by: disposeBag)
                
    }
    
    func getRepo(_ repo: String) -> Single<[String]> {
        return Single<[String]>.create { single in
            // 模拟请求数据
            var result = ["211", "r55"]
            if !repo.isEmpty {
                result  = [repo] + ["211", "r55"] + [repo]
            }
            
            single(.success(result))
            return Disposables.create { }
        }
    }
    
    func makeUI() {
        view.backgroundColor = .yellow
        
        view.addSubview(searchTextField)
        view.addSubview(countLabel)
        view.addSubview(tableView)
        
        searchTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(80)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-100)
            make.height.equalTo(80)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.left.equalTo(searchTextField.snp_rightMargin).offset(20)
            make.right.equalTo(view).offset(-20)
            make.centerY.equalTo(searchTextField.snp_centerYWithinMargins)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp_bottomMargin).offset(20)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "输入要搜索的内容"
        tf.backgroundColor = .white
        return tf
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .green
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
}

extension DriverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
