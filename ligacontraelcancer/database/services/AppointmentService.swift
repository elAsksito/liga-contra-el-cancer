import Foundation
import FirebaseFirestore

class AppointmentService{
    
    static let shared = AppointmentService()
    private init(){}
    
    private let db = Firestore.firestore()
    private let collection = "appointments"
    private var appointmentsCollection: CollectionReference {
        db.collection("appointments")
    }
    

}
