//
//  Extension + UITextField.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
    
    func changeText(text: String?) {
        self.text = text
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)

    }
}
