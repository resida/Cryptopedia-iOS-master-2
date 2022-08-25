//
//  HomeHeaderView.swift
//  Cryptonomy
//
//

import UIKit
import SwiftyUserDefaults

typealias didSelectItemInCollection = (( _ collectionView: UICollectionView, _ indexPath: IndexPath, _ rawList: Datum) -> ())?

class HomeHeaderView: UITableViewHeaderFooterView {

    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var btnTapToStart: UIButton!
    
    //MARK: - Public Variables
    var didSelectCollectionItem : didSelectItemInCollection = nil
    var errorOccured: ((String)->())? = nil
    
    var coinHistoData: [Datum] = []
    var currentIndex: Int = 0
    var timer: Timer?
    var isApiCalled: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeOnce()
    }
    
    func initializeOnce() {
        if let flow = collectionView.collectionViewLayout as? HomeLayout {
            let width = UIScreen.main.bounds.width
            flow.itemSize = CGSize(width: (width-30)/2, height: 114)
            flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            flow.minimumLineSpacing = 10
            flow.minimumInteritemSpacing = 10
        }
                
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeHeaderCell.nib, forCellWithReuseIdentifier: HomeHeaderCell.identifier)
        
        self.fetTopHeaderData()
    }
    
    func fetTopHeaderData() {
        if self.coinHistoData.count == 0 {
            self.viewWithTag(111)?.backgroundColor = UIColor.white
            self.btnTapToStart.isHidden = true
        }
        
        self.isApiCalled = true
        
        let params = TickerParams()
        params.limit = "10"
        params.convert = Defaults[.currentCurrency]!
        
        apiMgr.getHomeHeaderDataCoinMarketCapPro(params, success: { (result) in
            DispatchQueue.main.async {
                self.viewWithTag(111)?.backgroundColor = UIColor.c_Blue
                self.btnTapToStart.isHidden = false
                self.coinHistoData = result
                self.collectionView.reloadData()
                self.setUpTimer()
            }
        }, failure: { message in
            if let error = self.errorOccured { error(message) }
            Common.hideLoading()
        })
    }
    
    func setUpTimer() {
        if let currentTimer = self.timer {
            currentTimer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.animateHorizontalCollectionView), userInfo: nil, repeats: true)
    }
    
    @objc func animateHorizontalCollectionView() {
        DispatchQueue.main.async {
            self.currentIndex += 1
            if self.currentIndex == self.coinHistoData.count / 2 {
                self.currentIndex = 0
            }
            
            self.collectionView.setContentOffset(CGPoint(x: Int(self.width)*self.currentIndex, y: 0), animated: true)
        }
    }
}

extension HomeHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinHistoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCell.identifier, for: indexPath) as! HomeHeaderCell
        cell.setCurrentTicker(data: coinHistoData[indexPath.item])
        
        return cell
    }
}

extension HomeHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectCollectionItem!(collectionView, indexPath, coinHistoData[indexPath.item])
    }
}
