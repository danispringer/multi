//
//  BingoViewController.swift
//  Multibuddy
//
//  Created by Daniel Springer on 10/6/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit
import GameKit

class BingoViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var numberLabel: UILabel!

    @IBOutlet weak var bingoButton: UIButton!
    @IBOutlet weak var notBingoButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgress: UIProgressView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var livesLeftLabel: UILabel!
    @IBOutlet weak var gameOverNextLevelButton: UIButton!
    @IBOutlet weak var gameOverPlayAgainButton: UIButton!


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

    var currentNumber = 0
    var myThemeColor: UIColor!
    var myGameTimer: Timer!
    var myPreTimer: Timer!
    var numbersRange: ClosedRange<Int>!
    var numbersDistribution: GKShuffledDistribution!
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


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--multibuddyScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        self.title = "\(Const.shabbosGameName): Level \(levelNumberIndex+1)"
        numberLabel.text = " "
        scoreLabel.text = "Score: 0"
        livesLeftLabel.text = "Lives left: " + String(repeating: "\n❤️", count: livesLeft)
        setThemeColorTo(myThemeColor: myThemeColor)
        timerProgress.progress = 0
        toggleUI(enable: false)

        numbersDistribution = GKShuffledDistribution(lowestValue: numbersRange.first!,
                                                     highestValue: numbersRange.last!)

        timerLabel.text = "\(timeLeftPre)00:\(Int(Const.timerSeconds))"

        bingoButton.setTitleNew(Const.shabbosGameName)
        notBingoButton.setTitleNew(Const.noMessage)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        bingoButton.doGlowAnimation(withColor: myThemeColor)
        //        notBingoButton.doGlowAnimation(withColor: myThemeColor)
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

    @IBAction func preLevelSelectionTapped(_ sender: UIButton) {
        // 0=again, 1=next
        ud.set(levelNumberIndex+sender.tag, forKey: Const.levelIndexKey)
        navigationController!.popViewController(animated: true)
    }


    func startPreTimer() {
        timerProgress.setProgress(1, animated: true)
        var runsLeft: Float = 2
        let messages = ["🔴🔴 Ready 🔴🔴", "🟡🟡 Set 🟡🟡", "🟢🟢 Go! 🟢🟢"]
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

        let isBingo = currentNumber % 7 == 0

        // bingo tag is 0
        if isBingo && sender.tag == 0 {
            self.showToast(message: "\(Const.shabbosGameName.uppercased())! 2x BONUS!",
                           color: myThemeColor)
            score += Const.pointsPerTap * 2
            showNextNumber()
        } else if !isBingo && sender.tag == 1 {
            self.showToast(message: "\(correctMessages.randomElement()!)!".uppercased(),
                           color: .systemGreen)
            score += Const.pointsPerTap
            showNextNumber()
        } else if isBingo && sender.tag == 1 {
            removeALife()
            shakeAndShow()
            self.showToast(message: "Oops", color: .systemGray)
        } else if !isBingo && sender.tag == 0 {
            removeALife()
            shakeAndShow()
            self.showToast(message: "Oops", color: .systemGray)
        }
    }


    func removeALife() {
        livesLeft-=1
        livesLeftLabel.text = "Lives left: " + String(repeating: "\n❤️", count: livesLeft)
        guard livesLeft > 0 else {
            endGameWith(reason: .livesUp)
            return
        }
    }


    func endGameWith(reason: GameEndReason) {
        self.toggleUI(enable: false)
        self.killGameTimer()

        var alert: UIAlertController!

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
                    forKey: Const.completedBingoLevels) as! String
                var completedLevelsArray = completedLevelsString.split(separator: ",")
                if !completedLevelsArray.contains("\(levelNumberIndex!)") {
                    completedLevelsArray.append("\(levelNumberIndex!)")
                    completedLevelsString = completedLevelsArray.joined(separator: ",")
                    ud.set(completedLevelsString, forKey: Const.completedBingoLevels)
                    remoteDelegate?.reload()
                }
        }

        DispatchQueue.main.async { [self] in
            present(alert, animated: true)
            timerLabel.isHidden = true
            timerLabel.textColor = .label
            let points = score
            let pointPoints = points == 1 ? "point" : "points"
            numberLabel.attributedText = attrifyString(
                preString: "Your score:\n",
                toAttrify: "\(points)",
                postString: pointPoints,
                color: myThemeColor)
            timerProgress.isHidden = true
            scoreLabel.isHidden = true
            livesLeftLabel.isHidden = true
            gameOverPlayAgainButton.isHidden = false
            gameOverNextLevelButton.isHidden = false
        }
    }


    func showNextNumber() {
        guard myGameTimer != nil else {
            toggleUI(enable: false)
            return
        }
        toggleUI(enable: false)
        currentNumber = numbersDistribution.nextInt()
        let myAttrText = attrifyString(
            preString: "Will number\n", toAttrify: "\(currentNumber)",
            postString: "be \(Const.shabbosGameName)?", color: myThemeColor)
        numberLabel.attributedText = myAttrText
        self.toggleUI(enable: true)
    }


    func toggleUI(enable: Bool) {
        DispatchQueue.main.async {
            for button: UIButton in [self.bingoButton, self.notBingoButton] {
                button.isHidden = !enable
            }
        }
    }

}
