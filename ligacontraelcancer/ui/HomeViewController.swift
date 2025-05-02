import UIKit
import Combine
import SDWebImage

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var itemSegmentedControl: UISegmentedControl!
    
    var especialidadList: [Specialty] = []
    var doctorList: [User] = []
        
    var currentItems: [ContenidoItem] = []
    
    let specialtyViewModel = SpecialtyViewModel()
    let doctorViewModel = UserViewModel()
    let alerts = Alerts()
    let loadingOverlay = LoadingOverlay()
    
    var cancellables = Set<AnyCancellable>()
    
    
    let paddingInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    let numberOfItemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        bindViewModel()
        cargarDatosIniciales()
        actualizarContenidoParaSegmento(index: 0)
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        actualizarContenidoParaSegmento(index: itemSegmentedControl.selectedSegmentIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! ItemCollectionViewCell
        let item = currentItems[indexPath.row]
        cell.titleLbl.text = item.title
        let placeholder = UIImage(systemName: "photo.fill")?
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(.black)

        
        if let url = URL(string: item.imageURLString) {
            cell.itemImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            cell.itemImageView.image = placeholder
            cell.itemImageView.tintColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return paddingInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingLateralSpace = paddingInset.left + paddingInset.right
        let internalSpace = (numberOfItemsPerRow - 1 ) * 10
        let availableWidth = collectionView.bounds.width - paddingLateralSpace - internalSpace
        let widthPerItem = availableWidth / numberOfItemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

}
