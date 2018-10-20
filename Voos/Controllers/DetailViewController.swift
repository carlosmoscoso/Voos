//
//  DetailViewController.swift
//  Voos
//
//  Created by Carlos Alexandre Moscoso on 03/10/18.
//  Copyright © 2018 Carlos Moscoso. All rights reserved.
//

import UIKit

private let reuseIdentifiers = ["Header", "Cell"]

class HeaderView: UICollectionReusableView {
    
    @IBOutlet var label: UILabel!
/*
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: self.bounds)
        
        addSubview(label!)
    }
 
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        label = decoder.decodeObject(forKey: "label") as? UILabel
    }
  */
    override func prepareForReuse() {
        super.prepareForReuse()
//        label.text = nil
    }
    /*
    override func encode(with coder: NSCoder) {
        coder.encode(label, forKey: "label")
        super.encode(with: coder)
    }*/
}

class DetailViewController: UICollectionViewController {

    var collectionViewFlowLayout: UICollectionViewFlowLayout? {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)//"Header")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass ||
            traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            
            collectionViewFlowLayout?.sectionHeadersPinToVisibleBounds = splitViewController!.isCollapsed
        }
    }
    
    // MARK: Collection view data source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifiers[0], for: indexPath) as! HeaderView
//        header.label.text = "CAM"
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifiers[1], for: indexPath)
//        cell.backgroundColor = .red
        
        return cell
    }
    
    // MARK: Collection view delegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.backgroundColor = .white
        view.layer.zPosition = 0.0
    }
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("alo")
//        delegate?.personPickerController(self, didPickPerson: persons[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let imageView = cell.contentView.viewWithTag(1) as? UIImageView
//        imageView?.image = UIImage(named: "Placeholder")
    }*/
}
/*
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionViewFlowLayout!.itemSize.height)
    }
}
*/
