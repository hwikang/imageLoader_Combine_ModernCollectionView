//
//  SearchTextField.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import UIKit
import Combine

final class SearchTextField: UITextField {
    private var cancellables = Set<AnyCancellable>()

    let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    let clearButton = UIButton(type: .system)
    init(placeholder: String = "텍스트를 입력해 주세요") {
        super.init(frame: .zero)
        borderStyle = .roundedRect
        keyboardType = .default
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        self.placeholder = placeholder
        clearButton.isHidden = true
        addLeftView()
        addRightView()
        bindView()
    }
    private func bindView() {
    
        textPublisher.map({ $0.isEmpty }).sink { [weak self] isEmpty in
            self?.clearButton.isHidden = isEmpty
        }.store(in: &cancellables)
                    
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)

    }
    @objc private func clearButtonTapped() {
        changeText(text: nil)
    }
    
    private func addLeftView() {
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftView = imageView
        leftViewMode = .always
    }
    
    private func addRightView() {
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .systemGray2
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightView = clearButton
        rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
