//
//  ViewController.swift
//  Project8
//
//  Created by Андрей Бородкин on 01.07.2021.
//

import UIKit

struct Score {
    var value: Int
    var count: Int
}

class ViewController: UIViewController {

    //MARK: - Parameters declaration
    
    
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = Score(value: 0, count: 0) {
        
            didSet {
                scoreLabel.text = "Score: \(score.value)"
            }
        
    }
    
//    var score = 0 {
//        didSet {
//            scoreLabel.text = "Score: \(score)"
//        }
//    }
    var level = 1
    
    //MARK: - UI Setup - General
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped(_:)), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 2
        buttonsView.layer.cornerRadius = 7
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        //MARK: - UI Setup - Buttons
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in  0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
//        cluesLabel.backgroundColor = .red
//        answersLabel.backgroundColor = .blue
//        buttonsView.backgroundColor = .green
        
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
        
    }

    //MARK: - Methods
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else {return}
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswer = answersLabel.text?.components(separatedBy: "\n")
            splitAnswer?[solutionPosition] = answerText
            
            answersLabel.text = splitAnswer?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score.value += 1
            score.count += 1
            
            if score.count == 7 {
                showNextLevelAlert()
            }
        } else {
            let ac = UIAlertController(title: "That's incorrect", message: nil, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Try again.", style: .cancel) { _ in
                self.score.value -= 1
                self.clearTapped(nil)
            }
            ac.addAction(dismissAction)
            present(ac, animated: true)
        }
    }
    
    @objc func clearTapped(_ sender: UIButton?) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                print("1", levelContents, "\n\n\n")
                var lines = levelContents.components(separatedBy: "\n")
                print("2", lines, "\n\n\n")
                lines.shuffle()
                print("3", lines, "\n\n\n")

               // print("4", lines.enumerated(), "\n\n\n")
                for (index, line) in lines.enumerated() {
                    
                    print("(4)", "\(index): \(line)")
                    
                    
                    let parts = line.components(separatedBy: ": ")
                    print("(5)", parts)
                    
                    let answer = parts[0]
                    print("(6)", answer)
                    
                    let clue = parts[1]
                    print("(7)", clue)
                    
                    clueString += "\(index + 1). \(clue)\n"
                    print("(8)", clueString)
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    print("(9)", solutionWord)
                    
                    solutionsString += "\(solutionWord.count) letters\n"
                    print("(10)", solutionsString)
                    
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    print("(11)", bits)
                    
                    letterBits += bits
                    print("(12)", letterBits, "\n\n\n")
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    fileprivate func showNextLevelAlert() {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        let levelUp = UIAlertAction(title: "Let's go!", style: .default) { _ in
            self.level += 1
            self.score.count = 0
            self.solutions.removeAll(keepingCapacity: true)
            self.loadLevel()
            
            for button in self.letterButtons {
                button.isHidden = false
            }
            
        }
        ac.addAction(levelUp)
        present(ac, animated: true)
    }
}

