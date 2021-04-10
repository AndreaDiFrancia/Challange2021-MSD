//
//  CategoryTableViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit
import PDFKit

class CategoryTableViewController: UITableViewController {
    
    var documentsOfCategory: [Document] = []
    var filteredDocuments = [Document]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        debugPrint("Document of \(title ?? "Category"): \(documentsOfCategory.count)")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Document"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Private instance methods
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDocuments = documentsOfCategory.filter({( document : Document) -> Bool in
            if let title = document.title {
                return title.lowercased().contains(searchText.lowercased())
            } else { return false }
        })
        tableView.reloadData()
    }
    
    private func getPdfThumbnailFor(document: Document) -> UIImage? {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let url = documentDirectory.appendingPathComponent((document.pdfPath)!)
            if let pdfDocument = PDFDocument(url: url), let page = pdfDocument.page(at: 0) {
                return page.thumbnail(of: CGSize( width: 100, height: 100), for: .artBox)
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredDocuments.count : documentsOfCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentTableViewCell
        let document = isFiltering() ? filteredDocuments[indexPath.row] : documentsOfCategory[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        cell.titleLabel.text = document.title
        cell.dateLabel.text = document.date != nil ? formatter.string(from: document.date!) : "-"
        cell.thumbnailIcon.image = getPdfThumbnailFor(document: document)
        cell.thumbnailIcon.layer.cornerRadius = 8.0
        cell.thumbnailIcon.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering() {
                DataManager.shared.deleteDocument(document: filteredDocuments[indexPath.row])
                if let index = documentsOfCategory.index(of: filteredDocuments[indexPath.row]) {
                    documentsOfCategory.remove(at: index)
                }
                filteredDocuments.remove(at: indexPath.row)
            } else {
                DataManager.shared.deleteDocument(document: documentsOfCategory[indexPath.row])
                documentsOfCategory.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDocument", let cell = sender as? DocumentTableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let selectedDocumentController = segue.destination as! DocumentTableViewController
            selectedDocumentController.document = isFiltering() ? filteredDocuments[indexPath.row] : documentsOfCategory[indexPath.row]
        }
    }
    
}

extension CategoryTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}
