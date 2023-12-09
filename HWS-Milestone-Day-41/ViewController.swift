//
//  ViewController.swift
//  HWS-Milestone-Day-41
//
//  Created by Ade Dwi Prayitno on 09/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    var word: UITextField!
    var scoreLabel: UILabel!
    var healthPointLabel: UILabel!
    var letterButtons: [UIButton] = []
    var buttonsView: UIView!
    var resetButton: UIButton!
    
    var healthPoint: Int = 7 {
        didSet {
            healthPointLabel.text = "HealtPoint: \(healthPoint)"
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var allLetter = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var animalNamesMaster = ["Lion", "Tiger", "Elephant", "Giraffe", "Zebra", "Kangaroo", "Koala", "Penguin", "Cheetah", "Gorilla", "Panda", "Hippopotamus", "Rhinoceros", "Chimpanzee", "Dolphin", "Shark", "Eagle", "Owl", "Camel", "Alligator", "Crocodile", "Snake", "Bat", "Bear", "Fox", "Wolf", "Rabbit", "Deer", "Moose", "Hedgehog", "Turtle", "Frog", "Octopus", "Jellyfish", "Seahorse", "Starfish", "Snail", "Butterfly"]
    var animalNames: [String] = []
    var usedLetter: [String] = []
    var correctAnswer: String = ""
    
    override func loadView() {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        title = "Hangman: Animals Name"
        animalNames = animalNamesMaster
        startGame()
    }

    func setupView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        healthPointLabel = UILabel()
        healthPointLabel.translatesAutoresizingMaskIntoConstraints = false
        healthPointLabel.textAlignment = .right
        healthPointLabel.text = "HealthPoint: 7"
        view.addSubview(healthPointLabel)
        
        word = UITextField()
        word.translatesAutoresizingMaskIntoConstraints = false
        word.isUserInteractionEnabled = false
        word.text = "????"
        word.textAlignment = .center
        word.layer.borderColor = UIColor.black.cgColor
        word.layer.borderWidth = 2
        view.addSubview(word)
        
        resetButton = UIButton(type: .system)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        view.addSubview(resetButton)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            healthPointLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            healthPointLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            word.heightAnchor.constraint(equalToConstant: 40),
            word.widthAnchor.constraint(equalToConstant: 650),
            word.heightAnchor.constraint(equalToConstant: 120),
            word.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            word.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            word.topAnchor.constraint(greaterThanOrEqualTo: healthPointLabel.bottomAnchor, constant: 50),
            
            resetButton.topAnchor.constraint(greaterThanOrEqualTo: word.bottomAnchor, constant: 50),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 650),
            buttonsView.heightAnchor.constraint(equalToConstant: 120),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(greaterThanOrEqualTo: word.bottomAnchor, constant: 40),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let buttonSize = 50
        
        for row in 0..<2 {
            for column in 0..<13 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                let itemIndex = row * 13 + column
                letterButton.setTitle(allLetter[itemIndex], for: .normal)
                letterButton.layer.borderWidth = 2
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(
                    x: column * buttonSize,
                    y: row * buttonSize,
                    width: buttonSize,
                    height: buttonSize
                )
                
                letterButton.frame = frame
                
                letterButtons.append(letterButton)
                buttonsView.addSubview(letterButton)
            }
        }
    }
    
    func startGame() {
        animalNames.shuffle()
        correctAnswer = animalNames.first?.uppercased() ?? "-"
        
        word.text = correctAnswer.map { _ in
            return "?"
        }.joined()
        
        animalNames.removeAll(where: {$0 == correctAnswer})
        
        resetAllLettersButtons()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if correctAnswer.contains(buttonTitle) {
            usedLetter.append(buttonTitle)
            usedLetter.append(buttonTitle)
            sender.isHidden = true
            onCorrectAnswerhandler()
        } else {
            healthPoint -= 1
            onWrongAnswerHandler()
        }
    }
    
    @objc func resetTapped() {
        animalNames = animalNamesMaster
        score = 0
        healthPoint = 7
        usedLetter.removeAll()
        startGame()
    }
    
    func nextGame() {
        score += 1
        healthPoint = 7
        usedLetter.removeAll()
        startGame()
    }
    
    func onCorrectAnswerhandler() {
        var tempWord = ""
        for letter in correctAnswer {
            let letterString = String(letter)
            
            if usedLetter.contains(letterString) {
                tempWord.append(letterString)
            } else {
                tempWord.append("?")
            }
        }
        
        word.text = tempWord
        
        if isAllCorrect() {
            showNewLevelAlert()
        }
    }
    
    func showNewLevelAlert() {
        let ac = UIAlertController(title: "Horayy", message: "Congratulations on entering a new level", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yeayy", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            nextGame()
        }))
        present(ac, animated: true)
    }
    
    func onWrongAnswerHandler() {
        if healthPoint == 0 {
            showEmptyHealthpoint()
        } else {
            showWrongAnswerAlert()
        }
    }
    
    func showWrongAnswerAlert() {
        let ac = UIAlertController(title: "Opps", message: "Oops wrong answer, your healtpoin is \(healthPoint)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .destructive))
        present(ac, animated: true)
    }
    
    func showEmptyHealthpoint() {
        let ac = UIAlertController(title: "Game Over", message: "Your healtpoin is \(healthPoint), better luck next time!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { [weak self] _ in
            guard let self else { return}
            resetTapped()
        }))
        present(ac, animated: true)
    }
    
    
    func isAllCorrect() -> Bool {
        guard let wordText = word.text else { return false }
        return !wordText.contains("?")
    }
    
    func resetAllLettersButtons() {
        letterButtons.forEach { button in
            button.isHidden = false
        }
    }
}

