//
//  DocumentTableViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit
import PDFKit

class DocumentTableViewController: UITableViewController,UICollectionViewDelegate, UICollectionViewDataSource {
  
    var document: Document?

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    
    @IBOutlet weak var imagePDF: UIImageView!
    @IBOutlet weak var imagePDF2: UIImageView!
    
    var pdfDocument: PDFDocument?
    var shareAll = [] as [Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePDF))
        
        if let document = document {
            labelTitle.text = document.title
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            labelData.text = formatter.string(from: (document.date)!)
            labelCategory.text = Config.getCategoryNameFrom(type: CategoryType(rawValue: Int((document.category)))!)
            if document.notes == "Note"{
                labelNote.text = "No notes for this document"
            }else{
                labelNote.text = document.notes
            }
        }
//        let fileManager = FileManager.default
//        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        do {
//            let fileUrls = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//            for x in fileUrls {
//                print("URLGENERALE \(x)")
////                if let pdfDocument = PDFDocument(url: x) {
////                    captureThumbnails(pdfDocument: pdfDocument)
////                    captureThumbnails2(pdfDocument: pdfDocument)
////                }
//            }
//        }catch {
//            print(error.localizedDescription)
//        }

        print(document?.pdfPath)
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let url = documentDirectory.appendingPathComponent((document?.pdfPath)!)
            if let pdfDocument = PDFDocument(url: url) {
                captureThumbnails(pdfDocument: pdfDocument)
                captureThumbnails2(pdfDocument: pdfDocument)
            }
        }catch {
            print(error)
        }
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func sharePDF() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let text = "Send visit of \(formatter.string(from: (document?.date)!))"
        shareAll.append(text)
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let url = documentDirectory.appendingPathComponent((document?.pdfPath)!)
            shareAll.append(url)
        }catch {
            print("[ERROR]\(error)")
        }
        
        //        let image = UIImage(named: "Product")
        //        let myWebsite = NSURL(string:"")
        
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        //        if( MFMailComposeViewController.canSendMail() )
        //
        //        {
        //            print("Can send email.")
        //
        //            let mailComposer = MFMailComposeViewController()
        //            mailComposer.mailComposeDelegate = self
        //
        //            //Set to recipients
        //           // mailComposer.setToRecipients(["exemple@exemple.com"])
        //
        //            //Set the subject
        //            let formatter = DateFormatter()
        //            formatter.dateStyle = .short
        //            mailComposer.setSubject("Send visit of \(formatter.string(from: (document?.date)!))")
        //
        //            //set mail body
        //            mailComposer.setMessageBody("This is my visit on \((labelCategory.text)!)", isHTML: true)
        //
        //            //////////////////////////////////////////////////////
        //            let fileManager = FileManager.default
        //            do {
        //                let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        //                let url = documentDirectory.appendingPathComponent((document?.pdfPath)!)
        //                print((document?.pdfPath)!)
        //                print(url)
        //                if let fileData =  NSData(contentsOf: url)
        //                {
        //                    print("File data loaded.")
        //                    mailComposer.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: (document?.pdfPath)!)
        //                }else{
        //                    print("[ERROR] no file attach")
        //                }
        //            }catch {
        //                print("[ERROR]\(error)")
        //            }
        //            /////////7/////////////////////////////////////////////////
        //
        //            //this will compose and present mail to user
        //            self.present(mailComposer, animated: true, completion: nil)
        //        }
        //        else
        //        {
        //            debugPrint("email is not supported")
        //        }
        
    }//END EMAIL
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    //Add collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPdf", for: indexPath)
        
//        let pdfView = PDFView()
//        pdfView.translatesAutoresizingMaskIntoConstraints = false
//        cell.addSubview(pdfView)
//        pdfView.leadingAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        pdfView.trailingAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        pdfView.topAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.topAnchor).isActive = true
//        pdfView.bottomAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        print(document?.pdfPath)
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileUrls = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for x in fileUrls {
                print(x)

//                let webView = UIWebView(frame: self.view.frame)
//                let urlRequest = URLRequest(url: x)
//                webView.loadRequest(urlRequest as URLRequest)
//                cell.addSubview(webView)
                if let pdfDocument = PDFDocument(url: x) {
                   captureThumbnails(pdfDocument: pdfDocument)
                   
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
       
        return cell
    }
    
    func captureThumbnails(pdfDocument:PDFDocument) {
        if let page1 = pdfDocument.page(at: 0) {
            imagePDF.image = page1.thumbnail(of: CGSize(
                width: imagePDF.frame.size.width,
                height: imagePDF.frame.size.height), for: .artBox)
        }
    }
        func captureThumbnails2(pdfDocument:PDFDocument) {
            if let page2 = pdfDocument.page(at: 1) {
                imagePDF2.image = page2.thumbnail(of: CGSize(
                    width: imagePDF2.frame.size.width,
                    height: imagePDF2.frame.size.height), for: .artBox)
            }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPDF", let index = segue.destination as? ShowPDFViewController {
            index.path = document?.pdfPath
        }
    }
    
}
