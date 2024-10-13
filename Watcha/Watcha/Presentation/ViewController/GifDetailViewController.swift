//
//  GifDetailViewController.swift
//  Watcha
//
//  Created by hwikang on 10/13/24.
//

import UIKit
import Combine

class GifDetailViewController: UIViewController {
    private let viewModel: GifDetailViewModelProtocol
    private let urlString: String
    private var cancellables = Set<AnyCancellable>()
    
    private let changeFavorite = PassthroughSubject<Bool,Never>()

    private let imageView = {
        let imageView = UIImageView()
       
        return imageView
    }()
    
    private let favoriteButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        return button
    }()

    init(viewModel: GifDetailViewModelProtocol, urlString: String) {
        self.viewModel = viewModel
        self.urlString = urlString
      
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        bindViewModel()
    }
    private func bindViewModel() {
        let output = viewModel.transform(input: GifDetailViewModel.Input(changeFavorite: changeFavorite.eraseToAnyPublisher()))
        output.isFavorite.sink { [weak self] isFavorite in
            self?.favoriteButton.isSelected = isFavorite
        }.store(in: &cancellables)
    }
    
    private func setUI() {
        [imageView, favoriteButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        setConstraints()
        imageView.setGifFromUrl(urlString: urlString)

    }
    
    @objc private func favoriteButtonTapped() {
        changeFavorite.send(!favoriteButton.isSelected)

    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.stopGif()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
