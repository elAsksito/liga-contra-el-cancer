import UIKit

extension CitaViewController {
    
    func cargarDatos(){
        let storedUserId = UserDefaults.standard.string(forKey: "userId") ?? ""
        appointmentViewModel.fetchAppointmentsByUserId(storedUserId)
        userViewModel.getUserById(uid: storedUserId)
        specialtyViewModel.getAllSpecialties()
    }
    
    func bindViewModel() {
        userViewModel.$userById
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
                    let user = data as User
                    self.userStored = user
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
        
        appointmentViewModel.$userAppointmentsState
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
                    if let citas = data as? [Appointment] {
                        self.citasList = citas
                        self.citasTableView.reloadData()
                    }
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
        
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
                    let specialties = data as [Specialty]
                    self.especialidades = specialties
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
        
        specialtyViewModel.$getSpecialtyState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else {return}
                switch state {
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(_):
                    self.loadingOverlay.hide()
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
