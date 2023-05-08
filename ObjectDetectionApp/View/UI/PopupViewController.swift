//
//  PopupViewController.swift
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/05/08.
//

import UIKit

enum PopupViewButtonType {
    case optional
    case dismiss
    case active
}

class PopupViewController: UIViewController {
    
    private let popupView: UIView = {
        var uiView = UIView()
        uiView.layer.cornerRadius = 24.0
        return uiView
    }()
    
    private lazy var backgroundView: UIView = {
        var uiView = UIView()
        uiView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissingPopupView)))
        return uiView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 4.0
        
        return stackView
    }()
    
    private var titleLabel = CreateLabel()
        .setupFont(OBFont.Popup.title)
        .setupLineHeight(1)
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelAlignment(.center)
        .build()
    
    private var descriptionLabel = CreateLabel()
        .setupFont(OBFont.Popup.description)
        .setupLineHeight(0)
        .setupTextColor(OBColor.decsriptionColor.decsription1)
        .setuplabelAlignment(.center)
        .build()
    
    private lazy var activeButton = OBButton()
    
    private lazy var dismissButton: OBButton = {
        var button = OBButton()
        button.setPopupConfigration("취소", OBFont.button.semiTitle, type: .dismiss)
        button.addTarget(self, action: #selector(dismissingPopupView), for: .touchUpInside)
        
        return button
    }()
    
    private var leftCompletion: (() -> Void)?
    private var rightCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupActiveButton(title: String) {
        activeButton.setPopupConfigration(title, OBFont.button.semiTitle, type: .active)
        activeButton.addTarget(self, action: #selector(dismissingPopupView), for: .touchUpInside)
        activeButton.addTarget(self, action: #selector(activeButtonTapped), for: .touchUpInside)
    }
}

enum PopupViewMargin {
    enum PopupView {
        static let sideMargin: CGFloat = 24.0
        static let height: CGFloat = 200.0
    }
    
    enum TitleLabel {
        static let topMargin: CGFloat = 24.0
    }
    
    enum DescriptionLabel {
        static let margin: CGFloat = 16.0
    }
    
    enum StackView {
        static let topMargin: CGFloat = 72.0
        static let margin: CGFloat = 16.0
        static let buttonHeight: CGFloat = 56.0
    }
    
}

extension PopupViewController {
    private func setupViews() {
        backgroundView.backgroundColor = OBColor.blurBackgroundColor
        popupView.backgroundColor = OBColor.backgroundColor
        
        [backgroundView, popupView].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            popupView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: PopupViewMargin.PopupView.sideMargin),
            popupView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -PopupViewMargin.PopupView.sideMargin),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        [titleLabel, descriptionLabel, stackView].forEach{
            popupView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor,constant: PopupViewMargin.TitleLabel.topMargin),
            titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: PopupViewMargin.DescriptionLabel.margin),
            descriptionLabel.leftAnchor.constraint(equalTo: popupView.leftAnchor, constant: PopupViewMargin.DescriptionLabel.margin),
            descriptionLabel.rightAnchor.constraint(equalTo: popupView.rightAnchor, constant: -PopupViewMargin.DescriptionLabel.margin),
            
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: PopupViewMargin.StackView.topMargin),
            stackView.leftAnchor.constraint(equalTo: popupView.leftAnchor, constant: PopupViewMargin.StackView.margin),
            stackView.rightAnchor.constraint(equalTo: popupView.rightAnchor, constant: -PopupViewMargin.StackView.margin),
            stackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -PopupViewMargin.StackView.margin)
        ])
        
        [activeButton, dismissButton].forEach{
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: PopupViewMargin.StackView.buttonHeight)
            ])
        }
    }
    
    func setPopup(title: String, description: String, buttonTitle: String, buttonType: PopupViewButtonType,_ rightCompletion: (() -> Void)?) {
        titleLabel.text = title
        descriptionLabel.text = description
        
        switch buttonType {
        case .active:
            dismissButton.isHidden = true
        case .dismiss:
            activeButton.isHidden = true
        case .optional:
            break
        }
        
        if let rightCompletion = rightCompletion {
            self.rightCompletion = rightCompletion
            setupActiveButton(title: buttonTitle)
        }
    }
    
    
    @objc func dismissingPopupView() {
        self.dismiss(animated: true)
    }
    
    @objc func activeButtonTapped() {
        self.rightCompletion?()
    }
}
