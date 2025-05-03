import UIKit

extension CitaViewController {
    
    func cargarDatos(){
        let storedUserId = UserDefaults.standard.string(forKey: "userId") ?? ""
        appointmentViewModel.observeAppointmentsByUserId(storedUserId)
        userViewModel.getUserById(uid: storedUserId)
        appointmentViewModel.observeAppointmentsByUserId(storedUserId)
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
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    self.loadingOverlay.show(in: self.view)
                case .success(let data):
                    self.citasList = data
                    self.citasTableView.reloadData()
                    DispatchQueue.main.async {
                        self.loadingOverlay.hide()
                    }
                case .failure(let error):
                    self.loadingOverlay.hide()
                    self.alerts.showErrorAlert(title: "Error",
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
