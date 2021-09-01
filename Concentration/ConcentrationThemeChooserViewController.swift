//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by allan galdino on 01/09/21.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🐔🦊🐼🦀🐪🐓🐳🐙🦄🐵",
        "Faces": "😀😂😎😫😰😴🙄🤔😘😷",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }

    @IBAction func changeTheme(_ sender: Any) {
        if let concentrationVC = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle,
               let theme = themes[themeName] {
                concentrationVC.theme = theme
            }
        } else if let concentrationVC = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle,
               let theme = themes[themeName] {
                concentrationVC.theme = theme
            }
            navigationController?.pushViewController(concentrationVC, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }

    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        splitViewController?.viewControllers.last as? ConcentrationViewController
    }

    // MARK: - Navigation

    private var lastSeguedToConcentrationViewController: ConcentrationViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle,
               let theme = themes[themeName] {
                if let concentrationVC = segue.destination as? ConcentrationViewController {
                    concentrationVC.theme = theme
                    lastSeguedToConcentrationViewController = concentrationVC
                }
            }
        }
    }
}

extension ConcentrationThemeChooserViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return false
            }
        }
        return true
    }
}
