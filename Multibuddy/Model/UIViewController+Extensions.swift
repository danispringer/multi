//
//  UIViewController+Extensions.swift
//  Multibuddy
//
//  Created by Daniel Springer on 9/16/21.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

extension UIViewController {

    func setThemeColorTo(myThemeColor: UIColor) {
        UIProgressView.appearance().progressTintColor = myThemeColor
        self.navigationController!.navigationBar.tintColor = myThemeColor
        UINavigationBar.appearance().tintColor = myThemeColor
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIAlertController.self]).tintColor = myThemeColor
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIToolbar.self]).tintColor = myThemeColor

        UIButton.appearance().tintColor = myThemeColor

        UISwitch.appearance().onTintColor = myThemeColor

        for state: UIControl.State in [.application, .highlighted, .normal, .selected] {
            UIBarButtonItem.appearance().setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: myThemeColor
            ], for: state)
        }
    }


    func attrifyString(preString: String, toAttrify: String,
                       postString: String?, color: UIColor) -> NSMutableAttributedString {
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .title3)]
        let jumboAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 100, weight: .semibold),
            .foregroundColor: color]
        let attributedMessagePre = NSAttributedString(
            string: preString,
            attributes: regularAttributes)

        let attributedMessageJumbo = NSAttributedString(string: toAttrify,
                                                        attributes: jumboAttributes)

        let myAttributedText = NSMutableAttributedString()

        myAttributedText.append(attributedMessagePre)
        myAttributedText.append(attributedMessageJumbo)

        if postString != nil {
            let attributedMessagePost: NSAttributedString = NSAttributedString(
                string: "\n" + postString!, attributes: regularAttributes)
            myAttributedText.append(attributedMessagePost)
        }

        return myAttributedText
    }


    enum AlertReason {
        case unknown
        case textfieldEmpty
        case nan
        case lastLevelCompleted
        case timeUp
        case livesUp
        case pointsReached
        case emailError
    }


    func createAlert(alertReasonParam: AlertReason,
                     levelIndex: Int = 0, points: Int = 0,
                     secondsUsed: Int = 0, livesLeft: Int = 0) -> UIAlertController {

        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
            case .emailError:
                alertTitle = "Email Not Sent"
                alertMessage = """
                Your device could not send e-mail. Please check e-mail configuration and \
                try again.
                """
            case .textfieldEmpty:
                alertTitle = "Textfield empty"
                alertMessage = "Please try again"
            case .nan:
                alertTitle = "Please enter numbers only"
                alertMessage = """
                Highest number allowed: \(UInt64.max/4)
                """
            case .lastLevelCompleted:
                alertTitle = "👑 WOW! You did it! 🎉"
                alertMessage = """
                You have completed all \(Const.bingoLevelsCount) levels!
                """
            case .timeUp:
                alertTitle = "⏰ Game Over ⏰"
                alertMessage = """
                You reached \(points) points.
                Reach \(Const.pointsGoal) points to complete this level.
                Try again!
                """
            case .livesUp:
                alertTitle = "💔 Game Over 💔"
                alertMessage = """
                You ran out of lives.
                You reached \(points) points.
                Try again!
                """
            case .pointsReached:
                alertTitle = "🎉 You Won! 🎊"
                let secondSeconds = secondsUsed == 1 ? "second" : "seconds"
                alertMessage = """
                You reached \(Const.pointsGoal) points and successfully completed Level \
                \(levelIndex+1)

                Time used: \(secondsUsed) \(secondSeconds)

                Lives left: \(String(repeating: "❤️", count: livesLeft))
                """
            default:
                alertTitle = "Unknown error"
                alertMessage = """
            An unknown error occurred. Please try again
            """
        }

        let alert = UIAlertController(title: alertTitle, message: alertMessage,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)

        return alert
    }


    // self.showToast(message: "Your Toast Message")
    func showToast(message: String, color: UIColor) {
        let myWidth: CGFloat = 256
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - (myWidth/2),
                                               y: self.view.frame.size.height-200,
                                               width: myWidth, height: 48))
        toastLabel.backgroundColor = color
        toastLabel.textColor = .white
        toastLabel.font = .preferredFont(forTextStyle: .body)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2, delay: 0.5, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in // completed in
            toastLabel.removeFromSuperview()
        })
    }

}
