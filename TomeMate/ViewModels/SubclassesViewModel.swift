//
//  SubclassesViewModel.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import Foundation
import Combine

class SubclassesViewModel: ObservableObject {
    
    @Published var subclasses: [SubclassModel] = []
    
    @Published var errorMessage: String?
    
    init(){
        fetchSubclasses()
    }
    func fetchSubclasses() {
        NetworkManager.shared.fetchSubClasses(query: "") { result in
            switch result {
            case .success(let subclasses):
                self.subclasses = subclasses
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching subclasses:", error)
            }
        }
    }
}
