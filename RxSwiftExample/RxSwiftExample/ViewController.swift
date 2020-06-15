//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by wjn on 2020/6/15.
//  Copyright © 2020 wjn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        makeUI()
        
        nextButton.rx.tap.subscribe(onNext: { [weak self](tap) in
            let driverVC = SignalViewController()
            self?.navigationController?.pushViewController(driverVC, animated: true)
        }).disposed(by: disposeBag)
    }

    func makeUI() {
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 200, height: 200))
            make.center.equalTo(view)
        }
    }
    
    lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .red
        bt.titleLabel?.text = "跳转"
        bt.setTitleColor(.white, for: .normal)
        return bt
    }()

}

