import UIKit
import Combine

extension NewCitaViewController {
    
    func cargarEspecialidades(){
        specialtyViewModel.getAllSpecialties()
    }
    
    func bindViewModel(){
        specialtyViewModel.$getAllSpecialtiesState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else {return}
                switch state{
                    
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(let data):
                    self.loadingOverlay.hide()
                    self.especialidades = data
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
        
        appointmentViewModel.$appointmentState
                    .receive(on: RunLoop.main)
                    .sink { [weak self] state in
                        guard let self = self else { return }
                        switch state {
                        case .idle:
                            self.loadingOverlay.hide()
                        case .loading:
                            self.loadingOverlay.show(in: self.view)
                        case .success(_):
                            self.loadingOverlay.hide()
                            self.alerts.showSuccessAlert(title: "Cita creada", message: "Tu cita ha sido creada correctamente.", viewController: self)
                        case .failure(let error):
                            self.loadingOverlay.hide()
                            self.alerts.showErrorAlert(title: "Error", message: error.message, viewController: self)
                        }
                    }
                    .store(in: &cancellables)
    }
}
