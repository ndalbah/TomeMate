//
//  NetworkManager.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://h10qk46o48.execute-api.us-east-2.amazonaws.com"
    
    // MARK: - SPELLS
    func fetchSpells(query: String, page: Int = 1, pageSize: Int = 10, completion: @escaping (Result<PaginatedSpells, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/spells?name=\(encodedQuery)&page=\(page)&page_size=\(pageSize)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(PaginatedSpells.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                print("Decode error:", error)
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    
    func fetchSpell(id: String) async throws -> SpellModel {
        guard let url = URL(string: "\(baseURL)/spells/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(SpellModel.self, from: data)
    }
    
    // MARK: - CREATURES
    func fetchCreatures(query: String, page: Int = 1, pageSize: Int = 10, completion: @escaping (Result<PaginatedCreatures, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/creatures?q=\(encodedQuery)&page=\(page)&page_size=\(pageSize)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(PaginatedCreatures.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                print("Decode error:", error)
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    // MARK: - ITEMS
    func fetchItems(query: String, page: Int = 1, pageSize: Int = 10, completion: @escaping (Result<PaginatedItems, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/items?q=\(encodedQuery)&page=\(page)&page_size=\(pageSize)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(PaginatedItems.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                print("Decode error:", error)
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    //MARK: - CLASSES
    func fetchClasses(query: String, completion:@escaping (Result<[ClassesModel], Error>) -> Void){
        guard let url = URL(string: "\(baseURL)/classes") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    func fetchSubClasses(query: String, completion:@escaping (Result<[SubclassModel], Error>) -> Void){
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/subclasses?className=\(encodedQuery)") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    
    //MARK: - RACES
    func fetchRaces(query: String, completion:@escaping (Result<[RaceModel], Error>) -> Void){
        guard let url = URL(string: "\(baseURL)/races") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    func fetchSubraces(query: String, completion:@escaping (Result<[SubraceModel], Error>) -> Void){
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/subraces?raceName=\(encodedQuery)") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    
    //MARK: - BACKGROUNDS
    func fetchBackgrounds(completion:@escaping(Result<[BackgroundModel], Error>)->Void){
        let url = URL(string: "\(baseURL)/backgrounds")!
        fetch(url: url, completion: completion)
    }
    
    //MARK: - SKILLS
    func fetchSkills(completion:@escaping(Result<[SkillsModel], Error>)->Void){
        let url = URL(string: "\(baseURL)/skills")!
        fetch(url: url, completion: completion)
    }
    
    //MARK: - LANGUAGES
    func fetchLanguages(completion:@escaping(Result<[LanguageModel], Error>) ->Void){
        let url = URL(string: "\(baseURL)/languages")!
        fetch(url: url, completion: completion)
    }
    
    // MARK: - FETCH FUNCTION
    private func fetch<T: Decodable>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}


struct PaginatedSpells: Decodable {
    let total_pages: Int
    let data: [SpellModel]
}

struct PaginatedItems: Decodable {
    let total_pages: Int
    let data: [ItemModel]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_pages = try container.decode(Int.self, forKey: .total_pages)

        var arrayContainer = try container.nestedUnkeyedContainer(forKey: .data)
        var items: [ItemModel] = []
        while !arrayContainer.isAtEnd {
            if let item = try? arrayContainer.decode(ItemModel.self) {
                items.append(item)
            } else {
                _ = try? arrayContainer.decode(AnyCodable.self)
            }
        }
        data = items
    }

    private enum CodingKeys: String, CodingKey {
        case total_pages, data
    }
}

struct PaginatedCreatures: Decodable {
    let total_pages: Int
    let data: [CreatureModel]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_pages = try container.decode(Int.self, forKey: .total_pages)

        var arrayContainer = try container.nestedUnkeyedContainer(forKey: .data)
        var creatures: [CreatureModel] = []
        while !arrayContainer.isAtEnd {
            if let creature = try? arrayContainer.decode(CreatureModel.self) {
                creatures.append(creature)
            } else {
                _ = try? arrayContainer.decode(AnyCodable.self)
            }
        }
        data = creatures
    }

    private enum CodingKeys: String, CodingKey {
        case total_pages, data
    }
}

struct AnyCodable: Decodable {}
