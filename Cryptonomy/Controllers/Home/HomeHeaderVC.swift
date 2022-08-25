//
//  HomeHeaderVC.swift
//  Cryptonomy
//
//

import UIKit
import PKHUD

class HomeHeaderVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Public Variables
    var viewModel: HomeListModel!
    var currentIndex: Int = 0
    var timer: Timer?

    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeOnce()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchHomeHeaderDataPro(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.collectionView.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initializeOnce() {
        if let flow = collectionView.collectionViewLayout as? HomeLayout {
            let width = UIScreen.main.bounds.width
            flow.itemSize = CGSize(width: (width-30)/2, height: 120)
            flow.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
            flow.minimumLineSpacing = 10
            flow.minimumInteritemSpacing = 10
        }
        
        self.view.backgroundColor = UIColor.white
        
        viewModel = HomeListModel()
        viewModel.reloadCollectionViewClosure = {
            self.view.backgroundColor = UIColor.c_Blue
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.setUpTimer()
            }
        }
        viewModel.didSelectCollectionItem = { (collectionView, indexPath, datum) in
            let marketDetailVC = UIStoryboard.marketDetailVC
            marketDetailVC.datum = datum
            self.navigationController?.pushViewController(marketDetailVC, animated: true)
        }
        viewModel.errorOccured = { message in
            Common.showAlert(Gloabal.appName, message, self)
        }
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel        
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
            if self.currentIndex == self.viewModel.coinHistoData.count/2 {
                self.currentIndex = 0
            }
            self.collectionView.setContentOffset(CGPoint(x: Int(self.view.width)*self.currentIndex, y: 0), animated: true)
        }
    }
    
    //MARK: - Button tap events
    
    @IBAction func btnTapToStartTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
}
