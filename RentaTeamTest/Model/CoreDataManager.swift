//
//  CoreDataManager.swift
//  RentaTeam Test
//
//  Created by Azat Battalov on 14.03.2022.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    var managedObjectContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    
    func fetchAndSaveMoviesFromDB(page: Int){
        APIRequests.fetchMoviesData(page: page) { response, error in
            guard let response = response else {
                NotificationCenter.default.post(name: NSNotification.Name("failedToUpdateMovies"), object: nil)
                print("Error getting movies data from server", error!.localizedDescription)
                //Можно обработать вывод ошибки пользователю
                return
            }
            
            //Если первый запрос при открытии приложения, очистить БД
            if page == 1{
                print("CLEAR!")
                self.clearMovies()
            }
            
            let moviesDict = JSONUtil.parseMoviesDataFromResponse(response: response)
            for movie in moviesDict{
                Movie.newMoview(dict: movie)
            }
            self.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name("moviesFromDBUpdated"), object: nil)
        }
        
        
    }
    
    func getLocalMovies() -> [Movie]{
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        let sd = NSSortDescriptor(key: "voteCount", ascending: false)
        fetchRequest.sortDescriptors = [sd]
        let movies = try? CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
        if let movies = movies{
            return movies
        }else{
            return []
        }
    }
    
    //MARK: CLEAR LOCAL MOVIES
    private func clearMovies(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do{
            try CoreDataManager.sharedInstance.managedObjectContext.execute(deleteRequest)
        }catch let error as NSError{
            print("Error deleting local movies", error.localizedDescription)
        }
    }
    
    // MARK: - Core Data stack
    
    //Фикс фатальной обишки. При сохранении обращение к saveContext пересекается с другими обращениями к managedObjectContext и выкидывает ошибку.
    override init(){
        super.init()
        self.managedObjectContext = persistentContainer.newBackgroundContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RentaTeamTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unable to load persistance store \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
}
