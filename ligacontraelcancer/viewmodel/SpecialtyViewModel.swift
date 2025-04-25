import Foundation
import Combine
import UIKit

@MainActor
class SpecialtyViewModel: ObservableObject {
    
    @Published var saveSpecialtyState: ResultState<String> = .idle
    @Published var getSpecialtyState: ResultState<Specialty> = .idle
    @Published var getAllSpecialtiesState: ResultState<[Specialty]> = .idle
    @Published var deleteSpecialtyState: ResultState<String> = .idle
    
    func saveSpecialty(_ specialty: Specialty, image: UIImage?) {
        self.saveSpecialtyState = .loading
        
        Task {
            let result = await SpecialtyService.shared.saveSpecialty(specialty, image: image)
            self.saveSpecialtyState = result
        }
    }
    
    func getSpecialtyById(_ id: String) {
        self.getSpecialtyState = .loading
        
        Task {
            let result = await SpecialtyService.shared.getSpecialtyById(id)
            self.getSpecialtyState = result
        }
    }
    
    func getAllSpecialties() {
        self.getAllSpecialtiesState = .loading
        
        Task {
            let result = await SpecialtyService.shared.getAllSpecialties()
            self.getAllSpecialtiesState = result
        }
    }

    func deleteSpecialty(_ id: String) {
        self.deleteSpecialtyState = .loading
        
        Task {
            let result = await SpecialtyService.shared.deleteSpecialty(id)
            self.deleteSpecialtyState = result
        }
    }
}
