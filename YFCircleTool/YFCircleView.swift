//
//  YFCircleView.swift
//  YFCircleTool
//
//  Created by chenyufeng on 2019/6/3.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

// MARK: - 选中代理
protocol YFCircleViewDelegate {
    
    func YFCircleViewSelectIndex(selectIndex:Int)
}

private let kListCellIden = "kListCellIden"

class YFCircleView: UIView {
    
    // MARK: - 定义属性
    var delegate : YFCircleViewDelegate?
    var circleTimer : Timer?
    var showImageArray:[String]? {
        
        didSet {
            
            collectionView.reloadData()
            
            pageControl.numberOfPages = showImageArray?.count ?? 0
            
            collectionView.scrollToItem(at: IndexPath(item: (showImageArray?.count ?? 0) * 100, section: 0), at: .left, animated: false)
            
            removeCircleTimer()
            addCircleTimer()
        }
    }
    
    
    var pageControl:UIPageControl = {
        
        let control = UIPageControl.init()
        control.pageIndicatorTintColor = UIColor.white
        control.currentPageIndicatorTintColor = UIColor.red
        control.currentPage = 0
        return control
    }()
    
    lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collect = UICollectionView(frame:.zero, collectionViewLayout:layout)
        collect.delegate = self
        collect.dataSource = self
        collect.isPagingEnabled = true
        collect.bounces = false
        collect.showsHorizontalScrollIndicator = false
        collect.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kListCellIden)
        return collect
        
    }()
    
    // MARK: 系统回调函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.frame = self.bounds
        
        self.addSubview(pageControl)
        pageControl.frame = CGRect(x: 0, y: self.frame.height - 30, width: self.frame.width, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionView代理
extension YFCircleView :UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (showImageArray?.count ?? 0) * 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kListCellIden, for: indexPath)
        
        let currentIndex = indexPath.item % (showImageArray?.count ?? 0)
        if currentIndex % 2 == 0 {
            cell.backgroundColor = UIColor.yellow
        }
        else {
            cell.backgroundColor = UIColor.blue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentIndex = indexPath.item % (showImageArray?.count ?? 0)
        delegate?.YFCircleViewSelectIndex(selectIndex: currentIndex)
    }
}

// MARK: - UIScrollViewDelegate滚动
extension YFCircleView:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        let newOffX =  Int(offSetX/collectionView.frame.width)
        pageControl.currentPage = newOffX%(showImageArray?.count ?? 0)
    }
    
    //开始拖动时，移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCircleTimer()
    }
    
    //结束拖动时，重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCircleTimer()
    }
}

// MARK: - circleTimer定时器
extension YFCircleView {
    
    //添加定时器
    private func addCircleTimer() {
        circleTimer = Timer.init(timeInterval: 3, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        RunLoop.current.add(circleTimer!, forMode: .common)
    }
    
    //移除定时器
    private func removeCircleTimer() {
        circleTimer?.invalidate()
        circleTimer = nil
    }
    
    @objc private func scrollToNext() {
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
