import UIKit
import Combine

extension HomeViewController {

    func cargarDatosIniciales() {
        specialtyViewModel.getAllSpecialties()
        doctorViewModel.getAllDoctors()
    }

    func actualizarContenidoParaSegmento(index: Int) {
        switch index {
        case 0:
            currentItems = especialidadList.map {
                ContenidoItem(title: $0.nombre, imageURLString: $0.image)
            }
        case 1:
            currentItems = doctorList.map {
                ContenidoItem(title: $0.name, imageURLString: $0.profileImageUrl)
            }
        default:
            currentItems = []
        }

        itemsCollectionView.reloadData()
    }
    
    func bindViewModel(){
        specialtyViewModel.$getAllSpecialtiesState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else {return}
                switch state {
                    
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(let data):
                    loadingOverlay.hide()
                    
                    let specialties = data as [Specialty]
                    self.especialidadList = specialties
                    self.actualizarContenidoParaSegmento(index: self.itemSegmentedControl.selectedSegmentIndex)
                    
                    
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
        
        
        doctorViewModel.$getDoctorsState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else {return}
                switch state {
                    
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(let data):
                    self.loadingOverlay.hide()
                    
                    let doctors = data as [User]
                    self.doctorList = doctors
                    self.actualizarContenidoParaSegmento(index: self.itemSegmentedControl.selectedSegmentIndex)
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
    }
}
