//
//  PasswordViewController.swift
//  iOS7-HW17-Kholodkov Denis
//
//  Created by Денис Холодков on 10.10.2022.
//

import UIKit

class PasswordViewController: UIViewController {

// MARK: - Flags

    var isStart = false
    var isCycleRunning = true
    var isButtonStopPressed = false
    let queue = DispatchQueue.global(qos: .background)

// MARK: - UI elements

    private lazy var textFieldPassword: UITextField = {
        var textFieldPassword = UITextField()
        textFieldPassword.text = ""
        textFieldPassword.textAlignment = .center
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.sizeToFit()
        textFieldPassword.backgroundColor = UIColor(red: 53/255.0,
                                                    green: 193/255.0,
                                                    blue: 148/255.0,
                                                    alpha: 100)
        textFieldPassword.layer.cornerRadius = 16
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        return textFieldPassword
    }()

    private lazy var labelSecond: UILabel = {
        var labelSecond = UILabel()
        labelSecond.text = "result"
        labelSecond.textColor = UIColor(red: 183/255.0,
                                        green: 154/255.0,
                                        blue: 194/255.0,
                                        alpha: 100)
        labelSecond.backgroundColor = view.backgroundColor
        labelSecond.textAlignment = .center
        labelSecond.sizeToFit()
        labelSecond.backgroundColor = .clear
        labelSecond.clipsToBounds = true
        labelSecond.layer.cornerRadius = 16
        labelSecond.translatesAutoresizingMaskIntoConstraints = false
        return labelSecond
    }()

    private lazy var buttonStart: UIButton = {
        var buttonStart = UIButton()
        buttonStart.setTitle("start", for: .normal)
        buttonStart.backgroundColor = .systemGreen
        buttonStart.layer.cornerRadius = 16
        buttonStart.addTarget(self, action: #selector(buttonStartPressed), for: .touchUpInside)
        buttonStart.translatesAutoresizingMaskIntoConstraints = false
        return buttonStart
    }()

    private lazy var buttonColor: UIButton = {
        var buttonColor = UIButton()
        buttonColor.setTitle("color", for: .normal)
        buttonColor.backgroundColor = .magenta
        buttonColor.layer.cornerRadius = 16
        buttonColor.addTarget(self, action: #selector(buttonColorPressed), for: .touchUpInside)
        buttonColor.translatesAutoresizingMaskIntoConstraints = false
        return buttonColor
    }()

    private lazy var buttonStop: UIButton = {
        var buttonStop = UIButton()
        buttonStop.setTitle("stop", for: .normal)
        buttonStop.backgroundColor = .orange
        buttonStop.layer.cornerRadius = 16
        buttonStop.addTarget(self, action: #selector(buttonStopPressed), for: .touchUpInside)
        buttonStop.translatesAutoresizingMaskIntoConstraints = false
        return buttonStop
    }()

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

            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            textFieldPassword.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            textFieldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            textFieldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 30),

            labelSecond.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            labelSecond.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            labelSecond.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70),
            labelSecond.heightAnchor.constraint(equalToConstant: 40),

            buttonStart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 260),
            buttonStart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            buttonStart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            buttonStart.heightAnchor.constraint(equalToConstant: 30),
            buttonStart.widthAnchor.constraint(equalToConstant: 150),

            buttonStop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 260),
            buttonStop.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 200),
            buttonStop.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            buttonStop.heightAnchor.constraint(equalToConstant: 30),
            buttonStop.widthAnchor.constraint(equalToConstant: 150),

            buttonColor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 310),
            buttonColor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            buttonColor.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            buttonColor.heightAnchor.constraint(equalToConstant: 30),
            buttonColor.widthAnchor.constraint(equalToConstant: 150)

        ])
    }

// MARK: - change backGroundColor

    var isDoor: Bool = true {
        didSet {
            if isDoor {
                view.backgroundColor = .white
            } else {
                view.backgroundColor = .black
            }
        }
    }

// MARK: - button Actions

    @objc func buttonStartPressed() {
        isStart = true
        isButtonStopPressed = false
        textFieldPassword.isSecureTextEntry = true
        bruteForce(passwordToUnlock: textFieldPassword.text ?? "")
    }

    @objc func buttonColorPressed() {
        isDoor.toggle()
    }

    @objc func buttonStopPressed() {
        isButtonStopPressed = isButtonStopPressed ? false : true
    }

// MARK: - Multithreading function

    func bruteForce(passwordToUnlock: String) {
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

// MARK: - Extensions

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index]): Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    return str
}

