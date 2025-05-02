import UIKit

class CitaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var consultorioLabel: UILabel!
    @IBOutlet weak var pacienteLabel: UILabel!
    @IBOutlet weak var especialidadLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        stackView.layer.cornerRadius = 10
            stackView.layer.masksToBounds = true
        stackView.layer.borderWidth = 0.5
            stackView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
