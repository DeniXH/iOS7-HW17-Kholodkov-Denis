//
//  PasswordViewController.swift
//  iOS7-HW17-Kholodkov Denis
//
//  Created by Денис Холодков on 10.10.2022.
//

import UIKit

class PasswordViewController: UIViewController {
    
    // MARK: - Flags
    
   private var isStart = false
   private var isCycleRunning = true
   private var isButtonStopPressed = false
   private let queue = DispatchQueue.global(qos: .background)
    
    // MARK: - UI elements
    
    private lazy var textFieldPassword: UITextField = {
        var textFieldPassword = UITextField()
        textFieldPassword.text = ""
        textFieldPassword.textAlignment = .center
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.sizeToFit()
        textFieldPassword.backgroundColor = Metric.textFieldBackground
        textFieldPassword.layer.cornerRadius = Metric.cornerRadius
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        return textFieldPassword
    }()
    
    private lazy var labelSecond: UILabel = {
        var labelSecond = UILabel()
        labelSecond.text = "result"
        labelSecond.textColor = Metric.labelSecondTextColor
        labelSecond.backgroundColor = view.backgroundColor
        labelSecond.textAlignment = .center
        labelSecond.sizeToFit()
        labelSecond.backgroundColor = .clear
        labelSecond.clipsToBounds = true
        labelSecond.layer.cornerRadius = Metric.cornerRadius
        labelSecond.translatesAutoresizingMaskIntoConstraints = false
        return labelSecond
    }()
    
    // MARK: - create buttons
    
    private lazy var buttonStart = makeButton(title: "start",
                                              action: #selector(buttonStartPressed),
                                              color: .systemGreen)
    private lazy var buttonColor = makeButton(title: "color",
                                              action: #selector(buttonColorPressed),
                                              color: .magenta)
    private lazy var buttonStop = makeButton(title: "stop",
                                             action: #selector(buttonStopPressed),
                                             color: .orange)

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .cyan
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(activityIndicatorView)
        view.addSubview(textFieldPassword)
        view.addSubview(labelSecond)
        view.addSubview(buttonStart)
        view.addSubview(buttonStop)
        view.addSubview(buttonColor)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.distanceTopToIndicator),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            textFieldPassword.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.distanceTopTotextField),
            textFieldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Metric.leadingValue),
            textFieldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Metric.trailingValue),
            textFieldPassword.heightAnchor.constraint(equalToConstant: Metric.buttoAndLabelHeight),
            
            labelSecond.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.distanceTopToLabelSecond),
            labelSecond.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Metric.leadingLabelSecond),
            labelSecond.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Metric.trailingLabelSecond),
            labelSecond.heightAnchor.constraint(equalToConstant: Metric.buttoAndLabelHeight),
            
            buttonStart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.distanceTopToButtonStartAndStop),
            buttonStart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Metric.leadingValue),
            buttonStart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Metric.trailingButtonStart),
            buttonStart.heightAnchor.constraint(equalToConstant: Metric.heightButton),
            buttonStart.widthAnchor.constraint(equalToConstant: Metric.widthtButton),
            
            buttonStop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.distanceTopToButtonStartAndStop),
            buttonStop.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Metric.leadingButtonStop),
            buttonStop.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Metric.trailingValue),
            buttonStop.heightAnchor.constraint(equalToConstant: Metric.heightButton),
            buttonStop.widthAnchor.constraint(equalToConstant: Metric.widthtButton),
            
            buttonColor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.distanceTopToButtonColor),
            buttonColor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Metric.leadingValue),
            buttonColor.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Metric.trailingValue),
            buttonColor.heightAnchor.constraint(equalToConstant: Metric.heightButton),
            buttonColor.widthAnchor.constraint(equalToConstant: Metric.widthtButton)
            
        ])
    }
    
    // MARK: - change backGroundColor
    
   private var isDoor: Bool = true {
        didSet {
            view.backgroundColor = isDoor ? .white : .black
        }
    }
    
    // MARK: - button Actions
    
    @objc private func buttonStartPressed() {
        isStart = true
        isButtonStopPressed = false
        textFieldPassword.isSecureTextEntry = true
        bruteForce(passwordToUnlock: textFieldPassword.text ?? "")
    }
    
    @objc private func buttonColorPressed() {
        isDoor.toggle()
    }
    
    @objc private func buttonStopPressed() {
        isButtonStopPressed = !isButtonStopPressed // если будет true, то поменяет на false и наоборот
    }
    
    // MARK: - Multithreading function
    
   private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        queue.async {
            if self.isStart {
                while password != passwordToUnlock && !self.isButtonStopPressed {
                    self.isStart = false
                    password = generateBruteForce(password, fromArray: allowedCharacters)
                    DispatchQueue.main.async {
                        self.activityIndicatorView.startAnimating()
                        self.labelSecond.text = password
                    }
                }
            }
            DispatchQueue.main.async {
                if password == passwordToUnlock {
                    self.labelSecond.text = "Ваш пароль \(passwordToUnlock)"
                } else {
                    self.labelSecond.text = "Ваш пароль \(passwordToUnlock) не взломан"
                    self.textFieldPassword.text = ""
                }
                self.textFieldPassword.isSecureTextEntry = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}
