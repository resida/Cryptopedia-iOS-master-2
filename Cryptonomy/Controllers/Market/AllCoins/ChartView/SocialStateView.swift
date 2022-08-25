//
//  SocialStateView.swift
//  Cryptonomy
//

import UIKit

class SocialStateView: UITableViewHeaderFooterView {

    //MARK: - IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: - Public Variables
    
    var arrNetworkInfo: [Network] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    //MARK: - View life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(SocialViewCell.nib, forCellWithReuseIdentifier: SocialViewCell.identifier)
    }
}

extension SocialStateView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrNetworkInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialViewCell.identifier, for: indexPath) as! SocialViewCell
        let info = self.arrNetworkInfo[indexPath.row]
        if let image = UIImage(named: info.key!) {
            cell.socialImgView.image = image
        } else {
            cell.socialImgView.image = #imageLiteral(resourceName: "dummy")
        }
        cell.socialImgView.isUserInteractionEnabled = true
        
        return cell
    }
}

extension SocialStateView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.arrNetworkInfo[indexPath.row]
        let url = URL(string: info.value!)!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
