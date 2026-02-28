//
//  TomeMateHolder.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import Foundation
import CoreData
import Combine

final class TomeMateHolder: ObservableObject {
    @Published var characters: [Character] = []
    
    init(_ context: NSManagedObjectContext){
        // refresh all
        refreshAll(context)
    }
    //MARK: REFRESH FUNCTIONS
    
    func refreshAll(_ context: NSManagedObjectContext){
        refreshCharacters(context)
    }
    
    func refreshCharacters(_ context: NSManagedObjectContext){
        characters = fetchCharacters(context)
    }
    
    //MARK: FETCHERS
    func fetchCharacters(_ context: NSManagedObjectContext) -> [Character]{
        do {return try context.fetch(charactersFetch())}
        catch {fatalError("Failed to fetch characters: \(error)")}
    }
    
    //MARK: FETCH REQUESTS
    func charactersFetch() -> NSFetchRequest<Character>{
        let request = Character.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Character.createdAt, ascending: true)]
        return request
    }
    
    //MARK: SAVE
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshAll(context) // always refresh
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
    
