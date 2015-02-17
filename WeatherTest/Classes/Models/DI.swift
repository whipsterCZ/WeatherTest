//
// Dependency Injection Container
//  Created by Daniel Kouba on 29/12/14.
//  Copyright (c) 2014 Daniel Kouba. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DI : NSObject {
    
    //MARK: Dependency Injection
    
    //Get SystemContainer | Context  - singleton
    class var context : DI {
        struct Static {
            static let instance = DI()
        }
        return Static.instance
    }
    
    
    func getParameter(key:String, defaultValue:String? = nil) -> String? {
        if let param = config.objectForKey(key) as? String {
            return param
        }
        return defaultValue;
    }
    
    lazy var config : NSDictionary = {
        return NSDictionary(
            contentsOfFile: NSBundle.mainBundle().pathForResource("config", ofType: "plist")!
            )!
        }()
    
    //MARK: - Services
    lazy var settings = Settings()
    
    lazy var locations: Locations = {
        return Locations(
            apiUrl: DI.context.getParameter("search_api_url")!,
            apiKey: DI.context.getParameter("weather_api_key")!
        )
        }()
    
    
    
    lazy var weatherService: WeatherService = {
        return WeatherService(
            apiUrl: DI.context.getParameter("weather_api_url")!,
            apiKey: DI.context.getParameter("weather_api_key")!
        )
        }()
    
    lazy var lightBlue = UIColor(red: 47/255, green: 145/255, blue: 1, alpha: 1)
    
    
    
    
    

    
    
    
    //MARK: - Convenience
    
    func application() -> UIApplication
    {
        return UIApplication.sharedApplication()
    }
    
    func appDelegate() -> AppDelegate? {
        return application().delegate as AppDelegate?
    }
    
    func viewController() -> UIViewController?
    {
        return application().keyWindow?.rootViewController
    }
    
    func screenSize() -> CGSize
    {
        return UIScreen.mainScreen().bounds.size
    }
    
    func storyBoard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "cz.danielkouba.test" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("model.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    
    func saveManagedContext () {
        if let moc = managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    
    
}