import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet private weak var resultImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var keywordsLabel: UILabel!
    
    private var imageTarget: String?
    
    func setup(with viewModel: SearchResultViewModel, imageService: ImageService) {
        titleLabel.text = viewModel.title
        keywordsLabel.text = viewModel.keywords.joined(separator: ", ")
        
        resultImageView.image = nil
        imageTarget = viewModel.imageLink
        guard let target = viewModel.imageLink else {
            return
        }
        imageService.fetchImage(target: target) { [weak self] (image, fetchedTarget) in
            guard let self = self, fetchedTarget == self.imageTarget else {
                return
            }
            
            DispatchQueue.main.async {
                self.resultImageView.image = image
            }
        }
    }
    
}
