//
//  ViewController.swift
//  YFCircleTool
//
//  Created by chenyufeng on 2019/6/3.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var circleView:YFCircleView = {
        
        let circleView = YFCircleView.init(frame:.init(x: 0, y: 64, width: self.view.frame.width, height: 200))
        
        return circleView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(circleView)
        circleView.delegate = self
        circleView.showImageArray = ["1","2","3","4"]
    }

}

extension ViewController : YFCircleViewDelegate {
    
    func YFCircleViewSelectIndex(selectIndex: Int) {
        print(selectIndex)
    }
}
