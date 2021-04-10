//
//  ShowPDFViewController.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class ShowPDFViewController: UIViewController {

    @IBOutlet weak var pdfShowView: PDFView!
    var path: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(path)
       
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let url = documentDirectory.appendingPathComponent((path)!)
            if let pdfDocument = PDFDocument(url: url) {
                pdfShowView.displayMode = .singlePageContinuous
                pdfShowView.autoScales = true
                // pdfView.displayDirection = .horizontal
                pdfShowView.document = pdfDocument
            }
        }catch {
            print(error)
        }
        
        // Do any additional setup after loading the view.
        
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

}
