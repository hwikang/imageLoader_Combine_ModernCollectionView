//
//  GifCollectionViewCell.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import UIKit
import Combine

final class GifCollectionViewCell: UICollectionViewCell, GifCellProtocol {
    static let id = "GifCollectionViewCell"
    public var onTapFavorite: (() -> Void)?
    public var onTapImage: (() -> Void)?
    private let gifImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let favoriteButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.stopGif()
    }
    
    private func setUI() {
        [gifImageView, favoriteButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        gifImageView.addGestureRecognizer(tapGesture)
        setConstraints()
    }
    
    @objc private func imageTapped() {
        onTapImage?()
    }
    
    @objc private func favoriteButtonTapped() {
        onTapFavorite?()
    }
    
    private func setConstraints() {
        let margin = frame.width * 0.03
        NSLayoutConstraint.activate([
          
            gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            favoriteButton.topAnchor.constraint(equalTo: gifImageView.topAnchor, constant: margin),
            favoriteButton.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: -margin),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
               
    }
    
    public func apply(cellData: CellData) {
        guard case .gifCell(let gifData) = cellData else {
            return
        }
        favoriteButton.isSelected =  gifData.isFavorite
        gifImageView.setGifFromUrl(urlString: gifData.previewURLString)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
