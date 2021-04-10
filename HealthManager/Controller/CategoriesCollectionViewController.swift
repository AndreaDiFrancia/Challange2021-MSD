//
//  CategoriesCollectionViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CategoryCell"

class CategoriesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Medical History"
        DataManager.shared.fetchDocuments { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Opss", message: error.localizedDescription, preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Config.category.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        //let categoryName = Config.getCategoryNameFrom(type: Config.category[indexPath.item])+"Icon"
        cell.titleLabel.text = Config.getCategoryNameFrom(type: Config.category[indexPath.item])
        cell.iconImageView.image = UIImage(named: Config.getCategoryNameFrom(type: Config.category[indexPath.item])+"Icon")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.size.width-12)/2
        return CGSize(width: size, height: size)
    }
    
    // MARK: Actions
    
    @IBAction func addNewDocument(_ sender: Any) {
        let scanner = IRLScannerViewController.standardCameraView(with: self)
        scanner.showControls = true
        scanner.showAutoFocusWhiteRectangle = true
        let navigationController = UINavigationController(rootViewController: scanner)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategory", let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView!.indexPath(for: cell) {
            segue.destination.title = Config.getCategoryNameFrom(type: Config.category[indexPath.item])
            let selectedCategoryController = segue.destination as! CategoryTableViewController
            selectedCategoryController.documentsOfCategory = DataManager.shared.documents.filter { $0.category == Config.category[indexPath.item].rawValue }
        }
    }
    
}

extension CategoriesCollectionViewController: IRLScannerViewControllerDelegate {
    
    func pageSnapped(_ page_image: UIImage, from cameraView: IRLScannerViewController) {
        DataManager.shared.arrayImage.append(page_image)
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddDocument", bundle: nil)
        let viewControllerDocument = storyBoard.instantiateViewController(withIdentifier: "addDocument")
        cameraView.navigationController?.navigationBar.isHidden = false
        cameraView.navigationController?.pushViewController(viewControllerDocument, animated: true)
    }
    
    func didCancel(_ cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true, completion: nil)
    }
    
}
