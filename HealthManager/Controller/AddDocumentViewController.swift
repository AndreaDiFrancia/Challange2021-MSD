//
//  AddDocumentViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreImage
import GLKit


class AddDocumentViewController: UIViewController, IRLScannerViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var flagEdit = false
    var flagBtnEdit = true
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var addPageButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMood))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        
        addPageButton.layer.cornerRadius = min(addPageButton.bounds.size.height, addPageButton.bounds.size.width) / 2
        addPageButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = min(nextButton.bounds.size.height, nextButton.bounds.size.width) / 2
        nextButton.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func editMood() {
        if flagBtnEdit == true {
            flagEdit = true
            collectionView.reloadData()
            flagBtnEdit = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            flagEdit = false
            collectionView.reloadData()
            flagBtnEdit = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scan(sender: AnyObject) {
        let scanner = IRLScannerViewController.standardCameraView(with: self)
        scanner.showControls = true
        scanner.showAutoFocusWhiteRectangle = true
        let navigationController = UINavigationController(rootViewController: scanner)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    // MARK: IRLScannerViewControllerDelegate
    
    func pageSnapped(_ page_image: UIImage, from controller: IRLScannerViewController) {
        controller.dismiss(animated: true) { () -> Void in
            DataManager.shared.arrayImage.append(page_image)
            self.collectionView.reloadData()
        }
    }
    
    func didCancel(_ cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true) {}
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if flagEdit == true {
            DataManager.shared.arrayImage.remove(at: indexPath.item)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  DataManager.shared.arrayImage.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! DocumentCollectionViewCell
        cell.imageDocument.image =  DataManager.shared.arrayImage[indexPath.row]
        cell.btnCancel.isHidden = true
        if flagEdit == true {
            cell.btnCancel.isHidden = false
            cell.btnCancel.image = #imageLiteral(resourceName: "edit")
        }
        return cell
    }
    
    @IBAction func finishPhotoEdit(_ sender: Any) {
      //segue
    }
}

extension UIImage {
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}
