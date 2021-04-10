//
//  DataManager.swift
//  HealthManager
//
//  Created by Andrea Di Francia on 10/04/21.
//  Copyright © 2021 ADF. All rights reserved.
//

import UIKit
import CoreData

/**
 The singleton that manages the access and the state of user's profile and Core Data database.
 */
class DataManager: NSObject {
    
    static let shared = DataManager()
    
    var user: User?
    var arrayImage: [UIImage] = []
    var documents: [Document] = []
    var ageFetched: Int16?
    var titleFetched: String?
    var descriptionFetched: String?
    var categoryFetched: String?
    var reminderSegue: Reminder?
    var pillReminderSegue: PillReminder?
    var pathImage: String?
    var checkedFetched: Bool?
    var deletingArray:[FilteredRecommendation] = []
    var globalVar: [FilteredRecommendation] = []
    var visitFetched: Date?
    
    private override init() {
        super.init()
    }
    
    func storeUserData() {
        do {
            let encoded = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encoded, forKey: Key.kStoredUser)
            debugPrint("User's data saved")
        } catch let error {
            debugPrint("Unable to store user's data: \(error.localizedDescription)")
        }
    }
    
    func retrieveUserData(onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        do {
            if let userData = UserDefaults.standard.data(forKey: Key.kStoredUser) {
                user = try JSONDecoder().decode(User.self, from: userData)
                onSuccess()
            } else {
                onFailure(DataManagerError.unableToLoadUserData)
            }
        } catch let error {
            onFailure(error)
        }
    }
    
    func fetchDocuments(onCompletion: @escaping(Error?) -> Void) {
        let managedContext = PersistenceService.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Document")
        do {
            try documents = managedContext.fetch(request) as! [Document]
            print("Number of saved documents: \(documents.count)")
            onCompletion(nil)
        } catch {
            debugPrint(error.localizedDescription)
            onCompletion(error)
        }
    }
    
    func saveNewDocument(title: String, date: Date, category: CategoryType, notes: String, pdfPath: String) {
        let managedContext = PersistenceService.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Document", in: managedContext)
        let document = Document(entity: entity!, insertInto: managedContext)
        document.title = title
        document.date = date
        document.category = Int16(category.rawValue)
        document.notes = notes
        document.pdfPath = pdfPath
        
        do {
            try managedContext.save()
            documents.append(document)
            print("New document succesfully saved!")
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func saveNewDocument(title: String, date: Date, category: CategoryType, notes: String, pdfPath: String, onCompletion: @escaping(Error?) -> Void) {
        let managedContext = PersistenceService.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Document", in: managedContext)
        let document = Document(entity: entity!, insertInto: managedContext)
        
        document.title = title
        document.date = date
        document.category = Int16(category.rawValue)
        document.notes = notes
        document.pdfPath = pdfPath
        
        do {
            try managedContext.save()
            documents.append(document)
            print("New document succesfully saved!")
            onCompletion(nil)
        } catch {
            debugPrint(error.localizedDescription)
            onCompletion(error)
        }
    }
    
    func deleteDocument(document: Document) {
        let managedContext = PersistenceService.persistentContainer.viewContext
        do {
            if let index = documents.index(of: document) {
                let object = managedContext.object(with: document.objectID)
                documents.remove(at: index)
                managedContext.delete(object)
                try managedContext.save()
            }
        }
        catch { debugPrint(error.localizedDescription) }
    }
    
    func getSexNameFrom(type: GenderType) -> String {
        switch type {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
    
//    CoreData for Recommendations
//  Read recomendations from Plist file
    func readRecommendations() -> [FilteredRecommendation] {
        
        var newArray: [FilteredRecommendation] = []
        
        if let path = Bundle.main.path(forResource:"RecommendationsBase", ofType: "plist"),
            let array = NSArray(contentsOfFile: path) as? [[String: Any]] {
            for dictionary in array {
                let context = PersistenceService.persistentContainer.viewContext
                let theEntityDescription = NSEntityDescription.entity(forEntityName: "FilteredRecommendation", in: PersistenceService.context)
                if (getSexNameFrom(type: (DataManager.shared.user?.gender)!)) == dictionary["sex"] as! String  &&  HealthManager.shared.getAge(birthday: (DataManager.shared.user?.birthDay)!) >= dictionary["age"] as! Int  {
                    let filteredRecom = FilteredRecommendation(entity: theEntityDescription!, insertInto: context)
                    filteredRecom.age = dictionary["age"] as! Int16
                    filteredRecom.category = (dictionary["category"] as! String)
                    filteredRecom.check = dictionary["checked"] as! Bool
                    filteredRecom.descriptionR = (dictionary["descriptionR"] as! String)
                    filteredRecom.gender = (dictionary["sex"] as! String)
                    filteredRecom.title = (dictionary["title"] as! String)
                    
                    do {
                        try context.save()
                        newArray.append(filteredRecom)
                        print("Saved in coreData")
                    } catch {
                        debugPrint("ERRORE :\(error.localizedDescription)")
                    }
                }
            }
        }
        return newArray
    }
    
    //    Fetch recommendations from CoreData
    
    func fetchRecomFromCoreData() throws -> [FilteredRecommendation] {
        let context = PersistenceService.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FilteredRecommendation")
        let filteredArray = try context.fetch(fetchRequest) as! [FilteredRecommendation]
        return filteredArray
    }
    
    //    For saving Recommendations(not working now!)
    
    func changingDataInCoreData() -> Bool {
        //        let context = PersistenceService.persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FilteredRecommendations")
        
        var res = false
        do {
            //Read from FilteredRecommendations
            let fetchedArray = try fetchRecomFromCoreData()
            for key in fetchedArray {
                print(key.value(forKey: "age")!)
                print(DataManager.shared.ageFetched!)
                
                
                if key.value(forKey: "age") as? Int16 == DataManager.shared.ageFetched && key.value(forKey: "title") as? String == DataManager.shared.titleFetched && key.value(forKey: "check") as! Bool == false {
                    key.setValue(true, forKey: "check")
                    try PersistenceService.context.save()
                    res = true
                    return res
                } else {
                    res = false
                    print("Error changing key - checked")
                }
            }
            
        } catch {
            debugPrint(error.localizedDescription)
        }
        return res
    }
    
}

enum DataManagerError: LocalizedError {
    case unableToLoadUserData
    
    public var errorDescription: String? {
        switch self {
        case .unableToLoadUserData: return "Unable to load user data."
        }
    }
    
}
