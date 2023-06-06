//
//  LevelsViewController.swift
//  Multibuddy
//
//  Created by Daniel Springer on 10/16/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI

class LevelsViewController: UITableViewController, RemoteTableReloadDelegate {


    // MARK: Outlets

    @IBOutlet var aboutButton: UIButton!
    @IBOutlet var tipsButton: UIButton!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--multibuddyScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        aboutButton.menu = infoMenu()
        aboutButton.showsMenuAsPrimaryAction = true

        setThemeColorTo(myThemeColor: myThemeColor)

        tipsButton.addTarget(self, action: #selector(tipsTapped), for: .touchUpInside)
        let tipsItem = UIBarButtonItem(customView: tipsButton)

        let aboutItem = UIBarButtonItem(customView: aboutButton)

        navigationItem.rightBarButtonItems = [aboutItem, tipsItem]
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tipsButton.setTitleNew(Const.tipsTitle, font: .title2)
        tipsButton.accessibilityLabel = emojiless(original: Const.tipsTitle)

        tipsButton.doGlowAnimation(withColor: myThemeColor)
        //        navigationController?.navigationBar.prefersLargeTitles = true

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        let shouldShowHelp = restoreAndShouldShowHelp()
        guard shouldShowHelp else {
            return
        }
        guard !CommandLine.arguments.contains("--multibuddyScreenshots") else {
            return // don't show tips alert if testing
        }
        if !ud.bool(forKey: Const.userSawSplash) {
            showSplash()
            ud.set(true, forKey: Const.userSawSplash)
        }

    }


    // MARK: Helpers

    func didPassGatedAlert(completion: @escaping (Bool) -> Void) {

        let firstRandom = Int.random(in: 7...11)
        let secondRandom = Int.random(in: 7...11)
        let solution = firstRandom * secondRandom

        let alert = UIAlertController(title: "Grown Up Area",
                                      message: "What is \(firstRandom) * \(secondRandom)?",
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter result here..."
        }
        let alertAction = UIAlertAction(title: Const.okMessage, style: .cancel) { _ in
            if let userAttempt = Int(alert.textFields?.first?.text ?? ""),
               userAttempt == solution {
                alert.dismiss(animated: true) {
                    completion(true)
                }
            } else {
                alert.dismiss(animated: true) {
                    completion(false)
                }
            }
        }
        alert.addAction(alertAction)

        present(alert, animated: true)
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            // your code with delay
            alert.dismiss(animated: true) {
                completion(false)
            }
        }
    }


    func showSplash() {
        let alert = createAlert(alertReasonParam: .splash, alertStyle: .alert)
        present(alert, animated: true)
    }


    func getCompletedLevels() -> [Int] {
        let completedLevelsString: String = ud.string(
            forKey: Const.completedLevels) ?? ""
        let completedLevelsArrayTemp = completedLevelsString.split(separator: ",")
        return completedLevelsArrayTemp.map { Int($0)! }
    }


    func restoreAndShouldShowHelp() -> Bool {
        guard let restoredLevelIndex: Int = ud.value(
            forKey: Const.levelIndexKey) as? Int else {
            return true
        }
        ud.removeObject(forKey: Const.levelIndexKey)

        if restoredLevelIndex >= Const.baseOptions.count {
            let alert = createAlert(alertReasonParam: .lastLevelCompleted)
            present(alert, animated: true)
            return false
        }
        showLevelFor(IndexPath(row: restoredLevelIndex, section: 0))
        return false
    }


    // MARK: Delegates

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return "What Multiples Do You Want to Practice Today?"
    }


    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return Const.baseOptions.count
    }


    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let isLevelCompleted = getCompletedLevels().contains(indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: Const.aLevelCell)
        as! LevelTableViewCell
        cell.selectionStyle = .none
        cell.mainLabel.text = """
        Spot Multiples of \(indexPath.row + Const.fakeIndexOffset)
        """

        if isLevelCompleted {
            cell.fakeBackgroundView.backgroundColor = .systemGreen
        } else {
            cell.fakeBackgroundView.backgroundColor = myThemeColor
        }

        cell.secondaryLabel.text = """
        \(String(repeating: "⭐️", count: indexPath.row + Const.fakeIndexOffset))
        """

        cell.fakeBackgroundView.layer.cornerRadius = 8

        cell.accessibilityLabel = "Level \(indexPath.row + Const.fakeIndexOffset)"

        return cell
    }


    func showLevelFor(_ indexPath: IndexPath) {
        let aLevelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: Const.aLevelViewController) as! ALevelViewController
        aLevelVC.levelNumberIndex = indexPath.row
        let levelMaxNumber = 10 * (indexPath.row + Const.fakeIndexOffset)
        aLevelVC.numbersRange = (indexPath.row + Const.fakeIndexOffset)...levelMaxNumber
        aLevelVC.myBase = indexPath.row + Const.fakeIndexOffset
        aLevelVC.remoteDelegate = tableView.delegate as? any RemoteTableReloadDelegate
        self.navigationController!.pushViewController(aLevelVC, animated: true)
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLevelFor(indexPath)
    }


    // MARK: Actions

    func shareApp() {
        let message = Const.appsLink
        let activityController = UIActivityViewController(activityItems: [message],
                                                          applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = aboutButton
        activityController
            .completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
                guard error == nil else {
                    let alert = self.createAlert(alertReasonParam: .unknown)
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                    return
                }
            }
        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }

    }


    func infoMenu() -> UIMenu {
        let shareAppAction = UIAction(title: Const.shareTitleMessage,
                                      image: UIImage(systemName: "heart"),
                                      state: .off) { _ in

            self.didPassGatedAlert { didPass in
                guard didPass else {
                    return
                }
                self.shareApp()
            }
        }
        let reviewAction = UIAction(title: Const.leaveReview,
                                    image: UIImage(systemName: "hand.thumbsup"),
                                    state: .off) { _ in

            self.didPassGatedAlert { didPass in
                guard didPass else {
                    return
                }
                self.requestReview()
            }
        }
        let moreAppsAction = UIAction(title: Const.showAppsButtonTitle,
                                      image: UIImage(systemName: "apps.iphone"),
                                      state: .off) { _ in
            self.didPassGatedAlert { didPass in
                guard didPass else {
                    return
                }
                self.showApps()
            }
        }

        let emailAction = UIAction(title: Const.contact,
                                   image: UIImage(systemName: "envelope.badge"),
                                   state: .off) { _ in
            self.didPassGatedAlert { didPass in
                guard didPass else {
                    return
                }
                self.sendEmailTapped()
            }
        }

        let resetAction = UIAction(title: Const.reset,
                                   image: UIImage(systemName: "trash"), state: .off) { _ in
            self.resetTapped()
        }


        let version: String? = Bundle.main.infoDictionary![Const.appVersion] as? String
        var myTitle = Const.appName
        if let safeVersion = version {
            myTitle += " \(Const.version) \(safeVersion)"
        }

        let infoMenu = UIMenu(title: myTitle, image: nil, identifier: .none,
                              options: .displayInline,
                              children: [emailAction, reviewAction, shareAppAction,
                                         moreAppsAction, resetAction])
        return infoMenu
    }


    func showApps() {

        let myURL = URL(string: Const.appsLink)
        guard let safeURL = myURL else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)
    }

    func resetTapped() {
        let alert = createAlert(alertReasonParam: .resetProgress,
                                okActionString: "Keep progress")
        let eraseAction = UIAlertAction(title: "Erase progress", style: .destructive) { _ in
            ud.set("", forKey: Const.completedLevels)
            self.tableView.reloadData()
        }
        alert.addAction(eraseAction)
        present(alert, animated: true)
    }


    @objc func tipsTapped() {
        let tipsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: Const.tipsViewController) as! TipsViewController
        self.navigationController!.pushViewController(tipsVC, animated: true)
    }


    // MARK: RemoteTableReloadDelegate

    func reload() {
        tableView.reloadData()
    }

}


protocol RemoteTableReloadDelegate: AnyObject {
    func reload()
}


extension LevelsViewController: MFMailComposeViewControllerDelegate {

    func sendEmailTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }


    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the
        // --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setToRecipients([Const.emailString])
        let version: String? = Bundle.main.infoDictionary![Const.appVersion] as? String
        var myTitle = Const.appName
        if let safeVersion = version {
            myTitle += " \(Const.version) \(safeVersion)"
        }
        mailComposerVC.setSubject(myTitle)
        mailComposerVC.setMessageBody("Hi, I have a question about your app.", isHTML: false)

        return mailComposerVC
    }


    func showSendMailErrorAlert() {
        let alert = createAlert(alertReasonParam: .emailError)
        present(alert, animated: true)
    }


    // MARK: MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}


extension LevelsViewController {


    func requestReview() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        guard let writeReviewURL = URL(string: Const.reviewLink)
        else {
            fatalError("expected valid URL")
        }
        UIApplication.shared.open(
            writeReviewURL,
            options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
            completionHandler: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.

private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in
            (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
