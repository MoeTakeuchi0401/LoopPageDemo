//
//  PageViewController.swift
//  LoopPageDemo
//
//  Created by takeuchi-mo on 2019/02/04.
//  Copyright © 2019年 takeuchi-mo. All rights reserved.
//

import UIKit

struct App {
    // AppDelegete
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    // 画面サイズ
    static var windowSize: CGSize { return UIScreen.main.bounds.size }
    // 画面横幅
    static var windowWidth: CGFloat { return self.windowSize.width }
    // 画面縦幅
    static var windowHeight: CGFloat { return self.windowSize.height }
    // ナビバー高さ
    static let navigationBarHeight: CGFloat = 44
    // ステータスバー高さ
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let collectionViewHeight = App.statusBarHeight + App.navigationBarHeight
    private let cellWidth: CGFloat = 108
    
    // ~~~~~~~~~Page側~~~~~~~~~
    private let pagelist: [String] = ["A", "BBBB", "CCC", "DDDDDD"]
    private (set) var pageControllergrop = [UIViewController]()
    // 初回のPage番号、現在のPage番号
    static let firstPageNum: NSInteger = 0
    private (set) var selectedPageNum:Int!
    // スクロール開始位置
    private var startPointPageX:CGFloat = 0
    // 高速スクロールを封じるView
    private var notScrollView = UIView()
    
    // ~~~~CollectionView側~~~~~
    private var collectionView: UICollectionView!
    private var selectBarView = UIView()
    // 現在のセル番号
    private var selectedCollectionNum:Int!
    // スクロール開始位置
    private var startPointCollectionX:CGFloat = 0
    // cellをコピーする回数
    private let pagelistsCount: NSInteger = 5
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers()
        self.setCollectionView()
        self.setSelectBarView()

        self.dataSource = self
        self.delegate = self
        
        self.view.subviews
            .filter{ $0.isKind(of: UIScrollView.self) }
            .forEach{($0 as! UIScrollView).delegate = self }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let pageNum = self.selectedPageNum, self.selectedCollectionNum == nil {
            self.changeCellAndPage(pageNum: pageNum)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.selectedPageNum == nil {
            self.changeCellAndPage(pageNum: PageViewController.firstPageNum)
        }
    }
    
    func setViewControllers() {
        // Page用のViwControllerをセット
        for i in 0...(pagelist.count - 1) {
            let viewController:SubViewController = SubViewController.instantiateFromStoryboard()
            viewController.Set(Text:pagelist[i], index: i)
            self.pageControllergrop.append(viewController)
        }
        // 高速スクロールを封じるViewをセット
        self.notScrollView.backgroundColor = App.Color.paleOverlayBackgroundGray.uiColor
        self.notScrollView.isHidden = true
        self.view.addSubviewWithSameFrameConstraints(self.notScrollView)
    }
    
    func setCollectionView() {
        // レイアウト
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: self.cellWidth,  height:CGFloat(PageViewController.collectionViewHeight))
        let rec = CGRect(x: 0.0, y: 0.0, width: App.windowWidth , height: PageViewController.collectionViewHeight)
        self.collectionView = UICollectionView(frame: rec, collectionViewLayout: flowLayout)
        
        // その他設定
        self.collectionView.delaysContentTouches = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(cellType: BarCollectionViewCell.self)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.addSubview(self.collectionView)
    }
    
    func setSelectBarView() {
        self.selectBarView.backgroundColor = UIColor.blue
        self.selectBarView.frame.size = CGSize(width: self.cellWidth,  height: 3)
        self.selectBarView.center = self.view.convert(self.collectionView.center, to: self.collectionView)
        self.selectBarView.center.y = PageViewController.collectionViewHeight - 1
        
        self.view.addSubview(self.selectBarView)
    }
    
    // 前後のViewControllerを読み込む
    private func nextViewController(viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        guard var index = self.pageControllergrop.index(of: viewController) else { return nil }
        index = isAfter ? (index + 1) : (index - 1)
        // 無限ループさせる
        if index < 0 {
            index = self.pageControllergrop.count - 1
        } else if index == self.pageControllergrop.count {
            index = 0
        }
        if index >= 0 && index < self.pageControllergrop.count {
            return self.pageControllergrop[index]
        }
        return nil
    }
    
    // PageまたはCellを変更したとき
    private func changeCellAndPage(indexPath: IndexPath? = nil, pageNum: NSInteger? = nil) {
        guard self.pageControllergrop.count >= self.pagelist.count else { return }
        let isFirstChange: Bool = (self.selectedPageNum == nil)
        
        // 変更したPageへ
        self.selectedPageNum = {
            if let pageNum = pageNum { return pageNum }
            if let indexPath = indexPath { return indexPath.row % self.pagelist.count }
            return PageViewController.firstPageNum
        }()
        self.setViewControllers([self.pageControllergrop[self.selectedPageNum]], direction: .forward, animated: false, completion: nil)
        
        // 変更したCellへ
        let indexPath: IndexPath = {
            if let indexPath = indexPath { return indexPath }
            return IndexPath(row: self.pagelist.count + self.selectedPageNum, section: 0)
        }()
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: !isFirstChange)
        
        DispatchQueue.main.async {
            self.changeCellColor(indexPath)
        }
    }
    
    // Cellの色を更新
    private func changeCellColor(_ indexPath: IndexPath? = nil) {
        // 一旦全てのCellを灰色に
        for cell in self.collectionView.visibleCells {
            if let cell = cell as? BarCollectionViewCell {
                cell.setSelectedCell(false)
            }
        }
        // 選択したCellのみ青色に
        guard let indexPath = indexPath else {
            self.selectedCollectionNum = nil
            return
        }
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? BarCollectionViewCell else {
            self.selectedCollectionNum = nil
            return
        }
        self.selectedCollectionNum = indexPath.row
        self.changeSelectBar(indexPath.row % self.pagelist.count)
        cell.setSelectedCell(true)
    }
    
    // バーのサイズを更新
    private func changeSelectBar(_ nextPageNum: NSInteger) {
        let titleWidth: CGFloat = (CGFloat(self.pagelist[nextPageNum].count) * 15) + 14
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.selectBarView.frame.size = CGSize(width: titleWidth,  height: 3)
                self.selectBarView.center.x = App.windowWidth / 2
        })
    }

    // MARK: - UIPageViewControllerDataSource UIPageViewControllerDelegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController: viewController, isAfter: false)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController: viewController, isAfter: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        self.notScrollView.isHidden = true
        
        // Pageが切り替わらなければ何もしない
        guard completed else { return }
        
        // 現在のPage番号を更新
        if let viewController = pageViewController.viewControllers?.first {
            guard let index = pageControllergrop.index(of: viewController) else { return }
            self.selectedPageNum = index
        }
    }
    
    // MARK: - UICollectionViewDelegate Method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pagelist.count * self.pagelistsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BarCollectionViewCell = collectionView.dequeueReusableCell(
            with: BarCollectionViewCell.self,
            for: indexPath
        )
        let pageNum: NSInteger = indexPath.row % self.pagelist.count
        cell.setTitle(self.pagelist[pageNum])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.changeCellAndPage(indexPath: indexPath)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startPointPageX = scrollView.contentOffset.x
        
        // 現在表示中のPageにCellの中心値を合わせる
        self.startPointCollectionX = {
            let listWidth = self.collectionView.contentSize.width / CGFloat(self.pagelistsCount)
            let contentOffsetX = listWidth * 2 + (self.cellWidth * CGFloat(self.selectedPageNum))
            let centerMargin = (App.windowWidth - self.cellWidth) / 2
            return contentOffsetX - centerMargin
        }()
        
        // Cellの色味をリセット
        self.changeCellColor()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isScrollCollectionView: Bool = (scrollView.className == "UICollectionView")
        
        // Pageスクロール中はCollectionViewスクロールを禁止
        self.collectionView.isScrollEnabled = isScrollCollectionView
        
        if isScrollCollectionView {
            let listWidth = self.collectionView.contentSize.width / CGFloat(self.pagelistsCount)
            // スクロールが左側のしきい値を超えたとき、中央に戻す
            if (self.collectionView.contentOffset.x <= self.cellWidth) {
                self.collectionView.contentOffset.x = (listWidth * 2) + self.cellWidth
            // スクロールが右側のしきい値を超えたとき、中央に戻す
            } else if (self.collectionView.contentOffset.x) >= (listWidth * 3) + cellWidth {
                self.collectionView.contentOffset.x = listWidth + self.cellWidth
            }
            
        } else {
            let changePageX = self.startPointPageX - scrollView.contentOffset.x
            let changeCollectionX = self.cellWidth * (changePageX / App.windowWidth)
            // 高速スクロールを封じる
            if abs(changePageX) > 0 && abs(changePageX) < App.windowWidth {
                self.notScrollView.isHidden = false
            }
            // Pageをスクロールさせた割合分、CollectionViewも動かす
            if changeCollectionX != 0 {
                self.collectionView.contentOffset.x = self.startPointCollectionX - changeCollectionX
            }
        }
        // cellの色味を更新
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: center) else { return }
        if self.selectedCollectionNum != indexPath.row {
            self.changeCellColor(indexPath)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollCenterCell(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollCenterCell(scrollView)
    }
    
    private func scrollCenterCell(_ scrollView: UIScrollView) {
        self.collectionView.isScrollEnabled = true
        self.notScrollView.isHidden = true
        
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: center) else { return }
        self.changeCellAndPage(indexPath: indexPath)
    }
}
