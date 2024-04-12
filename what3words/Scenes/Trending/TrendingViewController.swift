//
//  TrendingViewController.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Then
import ESPullToRefresh

final class TrendingViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCoverView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    var viewModel: TrendingViewModel!
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
        title = "Treding Movies"
        tableView.do {
            $0.register(cellType: MovieTableViewCell.self)
            $0.delegate = self
            $0.es.addPullToRefresh {
                self.reloadTrigger.onNext(())
            }
            $0.es.addInfiniteScrolling {
                self.loadMoreTrigger.onNext(())
            }
        }
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.configSearchCoverView(isHidden: true)
                self?.searchBar.text = nil
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.configSearchCoverView(isHidden: false)
            })
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        let input = TrendingViewModel.Input(
            load: .just(()),
            reload: reloadTrigger.asDriverOnErrorJustComplete(),
            loadMore: loadMoreTrigger.asDriverOnErrorJustComplete(), 
            search: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text).asDriverOnErrorJustComplete(), 
            selectMovie: tableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$movies
            .asDriver()
            .drive(tableView.rx.items) { tableView, index, movie in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: MovieTableViewCell.self
                )
                .then {
                    $0.configView(movie: movie)
                }
            }
            .disposed(by: disposeBag)
                
        output.$isLoading
            .asDriver()
            .drive(isLoading)
            .disposed(by: disposeBag)
        
        output.$isReloading
            .asDriver()
            .drive(isReloading)
            .disposed(by: disposeBag)
        
        output.$isLoadingMore
            .asDriver()
            .drive(isLoadingMore)
            .disposed(by: disposeBag)
        
        output.$error
            .asDriver()
            .drive(rx.error)
            .disposed(by: disposeBag)
    }
    
    func configSearchCoverView(isHidden: Bool) {
        searchCoverView.isHidden = isHidden
    }
}

// MARK: - Binders
extension TrendingViewController {
    var isLoading: Binder<Bool> {
        return Binder(self) { vc, isLoading in
            if isLoading {
                vc.activityIndicatorView.startAnimating()
            } else {
                vc.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    var isReloading: Binder<Bool> {
        return Binder(self) { vc, isReloading in
            if !isReloading {
                vc.tableView.es.stopPullToRefresh()
            }
        }
    }
    
    var isLoadingMore: Binder<Bool> {
        return Binder(self) { vc, isLoadingMore in
            if !isLoadingMore {
                vc.tableView.es.stopLoadingMore()
            }
        }
    }
}

// MARK: - StoryboardSceneBased
extension TrendingViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

// MARK: - UITableViewDelegate
extension TrendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 264
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
