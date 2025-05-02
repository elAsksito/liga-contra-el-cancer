import UIKit

class DoctorDetailViewController: UIViewController {

    var doctor: User?
    
    
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var nameDoctor: UILabel!
    @IBOutlet weak var rolDoctor: UILabel!
    @IBOutlet weak var emailDoctor: UILabel!
    @IBOutlet weak var phoneDoctor: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var topView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDoctorData()
        redondearImagen()
        
        let cornerRadius: CGFloat = 20.0
        topView.layer.cornerRadius = cornerRadius
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setDoctorData(){
        if let doctor = doctor{
            let doctorName = "\(doctor.name) \(doctor.surname)"
            nameDoctor.text = doctorName
            rolDoctor.text = doctor.rol
            emailDoctor.text = doctor.email
            
            if doctor.phone.isEmpty {
                phoneTitle.isHidden = true
                phoneDoctor.isHidden = true
            } else {
                phoneTitle.isHidden = false
                phoneDoctor.text = doctor.phone
            }
            
            let placeholder = UIImage(systemName: "person.crop.circle.fill")
            if let url = URL(string: doctor.profileImageUrl) {
                imageDoctor.sd_setImage(with: url, placeholderImage: placeholder)
            } else {
                imageDoctor.image = placeholder
                imageDoctor.tintColor = .white
            }
        }
    }
    
    private func redondearImagen() {
        imageDoctor.layer.cornerRadius = imageDoctor.frame.width / 2
        imageDoctor.clipsToBounds = true
        imageDoctor.contentMode = .scaleAspectFill
    }
}
