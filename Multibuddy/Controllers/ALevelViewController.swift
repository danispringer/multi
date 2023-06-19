//
//  ALevelViewController.swift
//  Multibuddy
//
//  Created by Daniel Springer on 10/6/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit


class ALevelViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var numberLabel: UILabel!

    @IBOutlet weak var isMultipleButton: UIButton!
    @IBOutlet weak var notMultipleButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgress: UIProgressView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var livesLeftLabel: UILabel!


    // MARK: Properties

    weak var remoteDelegate: RemoteTableReloadDelegate?

    let timeLeftPre = "Time left: "
    let correctMessages = [
        "amazing",
        "astonishing",
        "awesome",
        "excellent",
        "fabulous",
        "fantastic",
        "great",
        "impressive",
        "magnificent",
        "marvelous",
        "outstanding",
        "perfect",
        "superb",
        "terrific",
        "wonderful"
    ]

    var myBase: Int!

    var correctGuesses: [Int] = []
    var wrongGuesses: [Int] = []

    var currentNumber = 0
    var myGameTimer: Timer!
    var myPreTimer: Timer!
    var numbersRange: ClosedRange<Int>!
    var arrToCustomShuffle: [Int]!
    var myArrCustomIndex = 0
    var levelNumberIndex: Int!
    var score = 0 {
        didSet {
            guard score < Const.pointsGoal else {
                endGameWith(reason: .pointsReached)
                return
            }
            scoreLabel.countAnimation(upto: Double(score))
        }
    }

    var livesLeft = Const.livesPerLevel

    var runsLeft: Float = Const.timerSeconds
    let initialTime = Const.timerSeconds

    enum GameEndReason {
        case timeUp
        case livesUp
        case pointsReached
    }


    enum NextChoice {
        case again
        case next
    }


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--multibuddyScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        self.title = "Spot Multiples of: \(myBase!)"

        timerProgress.accessibilityElementsHidden = true
        numberLabel.text = " "
        scoreLabel.text = "Score: 0"
        let livesLabelRawLabel = "Lives left: " + String(repeating: "\n❤️", count: livesLeft)
        livesLeftLabel.text = isVOOn ? "Lives left: \(livesLeft)" : livesLabelRawLabel
        setThemeColorTo(myThemeColor: myThemeColor)
        timerProgress.progress = 0
        toggleUI(enable: false)

        timerLabel.text = "\(timeLeftPre)00:\(Int(Const.timerSeconds))"

        isMultipleButton.setTitleNew(Const.yesMessage, font: .largeTitle)
        notMultipleButton.setTitleNew(Const.noMessageGame, font: .largeTitle)

        arrToCustomShuffle = Array(numbersRange)
        for num in arrToCustomShuffle where num % myBase == 0 {
            arrToCustomShuffle.append(contentsOf: Array(repeating: num, count: myBase))
        }
        arrToCustomShuffle.shuffle()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        isMultipleButton.doGlowAnimation(withColor: myThemeColor)
        startPreTimer()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        myPreTimer?.invalidate()
        myPreTimer = nil
        myGameTimer?.invalidate()
        myGameTimer = nil
    }


    // MARK: Helpers

    func preLevelSelectionTapped(choice: NextChoice) {
        // 0=again, 1=next
        var valueToAdd = 0
        switch choice {
                //            case .again: // add 0 so case unneeded
            case .next:
                valueToAdd = 1
            default:
                break
        }
        ud.set(levelNumberIndex+valueToAdd, forKey: Const.levelIndexKey)
        navigationController!.popViewController(animated: true)
    }


    func startPreTimer() {
        timerProgress.setProgress(1, animated: true)
        var runsLeft: Float = 2
        let rawMessages = ["🔴🔴 Ready 🔴🔴", "🟡🟡 Set 🟡🟡", "🟢🟢 Go! 🟢🟢"]
        var messages: [String] = []
        for message in rawMessages {
            messages.append(isVOOn ? emojiless(original: message) : message)
        }

        var messageIndex = 0
        showToast(message: messages[messageIndex], color: .systemBlue)
        messageIndex += 1

        myPreTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            runsLeft -= 1
            self.showToast(message: messages[messageIndex], color: .systemBlue)
            messageIndex += 1
            if runsLeft == 0 {
                timer.invalidate()
                self.myPreTimer.invalidate()
                self.myPreTimer = nil
                self.startGameTimer()
            }
        }
    }


    func killGameTimer() {
        myGameTimer.invalidate()
        myGameTimer = nil
    }


    func startGameTimer() {
        toggleUI(enable: true)

        let totalRuns: Float = Const.timerSeconds

        myGameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in

            self.runsLeft -= 1
            self.timerProgress.setProgress(self.runsLeft/totalRuns, animated: true)
            let preStr = Int(self.runsLeft) < 10 ? "00:0" : "00:"
            self.timerLabel.text = "\(self.timeLeftPre)\(preStr)\(Int(self.runsLeft))"
            if self.runsLeft <= 10 {
                self.timerLabel.textColor = .red
            }
            if self.runsLeft == 0 {
                self.endGameWith(reason: .timeUp)
            }
        }

        showNextNumber()
    }


    func shakeAndShow() {
        toggleUI(enable: false)
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.showNextNumber()
            }
        })
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: numberLabel.center.x - 8,
                                                       y: numberLabel.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: numberLabel.center.x + 8,
                                                     y: numberLabel.center.y))
        numberLabel.layer.add(animation, forKey: "position")

        CATransaction.commit()
    }


    @IBAction func selectionTapped(_ sender: UIButton) {

        guard myGameTimer != nil else {
            toggleUI(enable: false)
            return
        }

        let isMultiple = currentNumber % myBase == 0

        // yesButton tag is 0
        if isMultiple && sender.tag == 0 {
            self.showToast(message: "\(Const.appName.uppercased())! 2x BONUS!",
                           color: myThemeColor)
            score += Const.pointsPerTap * 2
            correctGuesses.append(currentNumber)
            showNextNumber()
        } else if !isMultiple && sender.tag == 1 {
            self.showToast(message: "\(correctMessages.randomElement()!)!".uppercased(),
                           color: .systemGreen)
            score += Const.pointsPerTap
            correctGuesses.append(currentNumber)
            showNextNumber()
        } else if isMultiple && sender.tag == 1 {
            wrongGuesses.append(currentNumber)
            removeALife()
            shakeAndShow()
            self.showToast(message: "Oops", color: .systemGray)
        } else if !isMultiple && sender.tag == 0 {
            wrongGuesses.append(currentNumber)
            removeALife()
            shakeAndShow()
            self.showToast(message: "Oops", color: .systemGray)
        }
    }


    func removeALife() {
        livesLeft-=1
        let rawLivesLeft = "Lives left: " + String(repeating: "\n❤️", count: livesLeft)
        livesLeftLabel.text = isVOOn ? "Lives left: \(livesLeft)" : rawLivesLeft
        guard livesLeft > 0 else {
            endGameWith(reason: .livesUp)
            return
        }
    }


    func endGameWith(reason: GameEndReason) {
        self.toggleUI(enable: false)
        self.killGameTimer()

        var alert: UIAlertController!

        var correctGuessesFormatted = correctGuesses.map { String($0) }.joined(separator: ", ")
        var wrongGuessesFormatted = wrongGuesses.map { String($0) }.joined(separator: ", ")
        if correctGuessesFormatted.isEmpty {
            correctGuessesFormatted = isVOOn ? "None" : "😢 None"
        }
        if wrongGuessesFormatted.isEmpty {
            wrongGuessesFormatted = isVOOn ? "None" : "😎 None"
        }

        switch reason {
            case .timeUp:
                alert = createAlert(alertReasonParam: .timeUp, points: score)
            case .livesUp:
                alert = createAlert(alertReasonParam: .livesUp, points: score)
            case .pointsReached:
                alert = createAlert(alertReasonParam: .pointsReached,
                                    levelIndex: levelNumberIndex,
                                    secondsUsed: Int(initialTime-runsLeft),
                                    livesLeft: livesLeft)
                var completedLevelsString: String = ud.value(
                    forKey: Const.completedLevels) as! String
                var completedLevelsArray = completedLevelsString.split(separator: ",")
                if !completedLevelsArray.contains("\(levelNumberIndex!)") {
                    completedLevelsArray.append("\(levelNumberIndex!)")
                    completedLevelsString = completedLevelsArray.joined(separator: ",")
                    ud.set(completedLevelsString, forKey: Const.completedLevels)
                    remoteDelegate?.reload()
                }
        }

        DispatchQueue.main.async { [self] in

            alert.message?.append(
"""
\n\nCorrectly spotted: \(correctGuessesFormatted).
Incorrectly spotted: \(wrongGuessesFormatted).
""")

            let nextLevelAction = UIAlertAction(title: "Next Level", style: .default) { _ in
                self.preLevelSelectionTapped(choice: .next)
            }
            let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { _ in
                self.preLevelSelectionTapped(choice: .again)
            }
            let goHomeAction = UIAlertAction(title: "Back To Home", style: .default) { _ in
                self.navigationController!.popViewController(animated: true)
            }
            for action in [nextLevelAction, playAgainAction, goHomeAction] {
                alert.addAction(action)
            }

            present(alert, animated: true)
            timerLabel.isHidden = true
            timerLabel.textColor = .label
            let points = score
            let pointPoints = points == 1 ? "point" : "points"
            //            numberLabel.attributedText = attrifyString(
            //                preString: "Your score:\n",
            //                toAttrify: "\(points)",
            //                postString: pointPoints,
            //                color: myThemeColor)
            numberLabel.isHidden = true
            timerProgress.isHidden = true
            scoreLabel.isHidden = true
            livesLeftLabel.isHidden = true
        }
    }


    func showNextNumber() {
        guard myGameTimer != nil else {
            toggleUI(enable: false)
            return
        }
        toggleUI(enable: false)
        currentNumber = returnIntAndStepToNext()
        let myAttrText = attrifyString(
            preString: "Is\n", toAttrify: "\(currentNumber)",
            postString: "a multiple of \(myBase!)?",
            color: myThemeColor)
        numberLabel.attributedText = myAttrText
        self.toggleUI(enable: true)
    }


    func returnIntAndStepToNext() -> Int {
        if !arrToCustomShuffle.indices.contains(myArrCustomIndex) { // if end of arr
            myArrCustomIndex = 0
        }
        let myInt = arrToCustomShuffle[myArrCustomIndex]
        myArrCustomIndex+=1
        return myInt
    }


    func toggleUI(enable: Bool) {
        DispatchQueue.main.async {
            for button: UIButton in [self.isMultipleButton, self.notMultipleButton] {
                button.isHidden = !enable
            }
        }
    }

}
