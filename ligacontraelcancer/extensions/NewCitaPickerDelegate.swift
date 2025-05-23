import UIKit

extension NewCitaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return especialidades.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return especialidades[row].nombre
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedSpecialty = especialidades[row]
        especialidadTextField.text = selectedSpecialty.nombre
        selectedSpecialtyForAppointment = selectedSpecialty
    }
    
    
    func configurarPickerEspecialidad() {
        let pickerEspecialidad = UIPickerView()
        pickerEspecialidad.delegate = self
        pickerEspecialidad.dataSource = self
        especialidadTextField.inputView = pickerEspecialidad
        especialidadTextField.tintColor = .clear
        especialidadTextField.placeholder = "Seleccione la especialidad"
    }

    func configurarPickerFecha(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(fechaSeleccionada(_:)), for: .valueChanged)
        fechaTextField.inputView = datePicker
        fechaTextField.tintColor = .clear
        fechaTextField.placeholder = "Horario de Cita 10 AM - 6PM"
    }

    func configurarPickerHora(){
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(horaSeleccionada(_:)), for: .valueChanged)
        timePicker.minuteInterval = 30
        horaTextField.inputView = timePicker
        horaTextField.tintColor = .clear
        horaTextField.placeholder = "Seleccione la fecha"
    }
    
    @objc func fechaSeleccionada(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        fechaTextField.text = formatter.string(from: sender.date)
    }

    @objc func horaSeleccionada(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let horaSeleccionada = sender.date
        
        if validarHora(hora: horaSeleccionada) {
            horaTextField.text = formatter.string(from: horaSeleccionada)
        } else {
            alerts.showErrorAlert(title: "Hora fuera de rango", message: "La hora seleccionada debe estar entre las 10:00 AM y las 6:00 PM.", viewController: self)
            
            let horaValida = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
            horaTextField.text = formatter.string(from: horaValida)
        }
    }

}
