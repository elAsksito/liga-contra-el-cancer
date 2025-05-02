import UIKit

extension CitaViewController {
    func mostrarAlertaCita(titulo: String, cita: Appointment?, index: Int?) {
        let alert = UIAlertController(title: titulo, message: nil, preferredStyle: .alert)

        var pacienteTF = UITextField()
        self.especialidadTextField = nil
        self.fechaTextField = nil
        self.horaTextField = nil

        let especialidadPicker = UIPickerView()
        especialidadPicker.delegate = self
        especialidadPicker.dataSource = self

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()

        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels

        let consultorio = cita?.consultorio ?? "Consulta \(citasList.count + 1)"

        alert.addTextField { tf in
            tf.text = consultorio
            tf.isEnabled = false
        }

        alert.addTextField { tf in
            tf.placeholder = "Nombre del Paciente"
            tf.text = cita?.userId
            pacienteTF = tf
        }

        alert.addTextField { tf in
            tf.placeholder = "Seleccione la especialidad"
            tf.inputView = especialidadPicker
            tf.tintColor = .clear
            tf.text = cita?.especialidadId
            tf.delegate = self
            self.especialidadTextField = tf
        }

        alert.addTextField { tf in
            tf.placeholder = "Seleccione la fecha"
            tf.inputView = datePicker
            tf.tintColor = .clear
            tf.text = cita?.fecha
            self.fechaTextField = tf
            tf.delegate = self
            datePicker.addTarget(self, action: #selector(self.fechaSeleccionada(_:)), for: .valueChanged)
        }

        alert.addTextField { tf in
            tf.placeholder = "Horario de Cita 10 AM - 6PM"
            tf.inputView = timePicker
            tf.tintColor = .clear
            tf.text = cita?.hora
            self.horaTextField = tf
            tf.delegate = self
            timePicker.addTarget(self, action: #selector(self.horaSeleccionada(_:)), for: .valueChanged)
        }

        let guardar = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let horaTexto = self.horaTextField?.text, !horaTexto.isEmpty else {
                let alerta = UIAlertController(title: "Hora no seleccionada", message: "Por favor, seleccione una hora válida.", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                self.present(alerta, animated: true)
                return
            }

            if let horaSeleccionada = self.horaTextField?.text {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                guard let hora = formatter.date(from: horaSeleccionada) else { return }

                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: hora)

                if hour < 10 || hour >= 18 {
                    let alerta = UIAlertController(title: "Horario fuera de atención", message: "La cita debe ser registrada entre las 10:00 AM y las 6:00 PM.", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                    self.present(alerta, animated: true)
                    return
                }
            }

            let nuevaCita = Appointment(
                consultorio: consultorio,
                especialidadId: self.especialidadTextField?.text ?? "",
                userId: pacienteTF.text ?? "",
                doctorId: "",
                estado: "Pendiente",
                fecha: self.fechaTextField?.text ?? "",
                hora: self.horaTextField?.text ?? "",
                observaciones: "",
                receta: ""
            )



            
            if let i = index {
                self.citasList[i] = nuevaCita
                self.citasTableView.reloadData()
            } else {
                self.citasList.append(nuevaCita)
                self.citasTableView.reloadData()
            }
        }

        alert.addAction(guardar)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func fechaSeleccionada(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        self.fechaTextField?.text = formatter.string(from: sender.date)
    }

    @objc func horaSeleccionada(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.horaTextField?.text = formatter.string(from: sender.date)
    }

    func verificarHorario(horaSeleccionada: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        guard let hora = formatter.date(from: horaSeleccionada) else { return false }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: hora)

        return !(hour < 10 || hour >= 18)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
