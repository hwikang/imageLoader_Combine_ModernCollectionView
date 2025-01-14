//
//  GifViewController.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import UIKit
import Combine

class GifViewController: UIViewController {
    private let viewModel: GifViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let addFavorite = PassthroughSubject<String,Never>()
    private let deleteFavorite = PassthroughSubject<String,Never>()
    private let loadMore = PassthroughSubject<Void,Never>()

    private var dataSource: UICollectionViewDiffableDataSource<Section, CellData>?
    private let searchTextField = SearchTextField()
    private lazy var collectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            self?.dataSource?.sectionIdentifier(for: index)?.layoutSize
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: GifCollectionViewCell.id)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    init(viewModel: GifViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDatasource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: GifViewModel.Input(
            addFavorite: addFavorite.eraseToAnyPublisher(), deleteFavorite: deleteFavorite.eraseToAnyPublisher(),
            searchText: searchTextField.textPublisher.debounce(for: 0.3, scheduler: DispatchQueue.main).eraseToAnyPublisher(),
            loadMore: loadMore
                .debounce(for: 0.3, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()))
        
        output.cellData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.dataSource?.apply(snapshot)
            }.store(in: &cancellables)
        
        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier.id, for: indexPath)
            (cell as? GifCellProtocol)?.apply(cellData: itemIdentifier)
            if let cell = cell as? GifCollectionViewCell, case let .gifCell(data) = itemIdentifier {
                cell.onTapFavorite = {
                    if data.isFavorite {
                        self?.deleteFavorite.send(data.id)
                    } else {
                        self?.addFavorite.send(data.id)
                    }
                }
                cell.onTapImage = {
                    self?.pushGifDetailVC(urlString: data.originalURLString, id: data.id)
                }
            }
            return cell
        })
    }
    
    private func setUI() {
        [searchTextField, collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
    }
    
    private func pushGifDetailVC(urlString: String, id: String) {
        let detailRP = GifRepository(network: GifNetwork(manager: NetworkManager(session: URLSession.shared)))
        let detailUC = GifUsecase(repository: detailRP)
        let detailVM = GifDetailViewModel(usecase: detailUC, gifID: id)
        let detailVC = GifDetailViewController(viewModel: detailVM, urlString: urlString)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GifViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let snapshot = dataSource?.snapshot() else { return }
        if indexPath.row == snapshot.numberOfItems - 12 {
            loadMore.send(())
        }
    }

}
