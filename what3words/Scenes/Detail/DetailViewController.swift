//
//  DetailViewController.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import SDWebImage

final class DetailViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: DetailViewModel!
    var disposeBag = DisposeBag()
    
    private let reloadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    // MARK: - Methods
    private func configView() {
        
    }

    func bindViewModel() {
        let input = DetailViewModel.Input(
            load: .just(())
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$movie
            .asDriver()
            .drive(movieBinding)
            .disposed(by: disposeBag)
                
        output.$isLoading
            .asDriver()
            .drive(isLoading)
            .disposed(by: disposeBag)
        
        output.$error
            .asDriver()
            .drive(rx.error)
            .disposed(by: disposeBag)
    }
}

// MARK: - Binders
extension DetailViewController {
    var isLoading: Binder<Bool> {
        return Binder(self) { vc, isLoading in
            if isLoading {
                vc.activityIndicatorView.startAnimating()
            } else {
                vc.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    var movieBinding: Binder<Movie?> {
        return Binder(self) { vc, movie in
            guard let movie = movie else { return }
            if let thumbnailUrl = movie.thumbnailUrl {
                vc.thumbnailImageView.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: UIImage(named: "placeholder"))
            }
            vc.titleLabel.text = movie.title
            vc.rateLabel.text = "Rate: \(movie.voteAverage)"
            vc.descriptionLabel.text = movie.overview
        }
    }
}

// MARK: - StoryboardSceneBased
extension DetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
}

// MARK: - UISearchBarDelegate
extension DetailViewController: UISearchBarDelegate {
    
}
