//
//  ViewController.swift
//  MoproKit
//
//  Created by 1552237 on 09/16/2023.
//  Copyright (c) 2023 1552237. All rights reserved.
//

import UIKit
import MoproKit
//import KeccakZkeyViewController


// Main ViewController
class ViewController: UIViewController {
    var keccakZkeyViewController: KeccakZkeyViewController?

    let keccakSetupButton = UIButton(type: .system)
    let keccakZkeyButton = UIButton(type: .system)
    let rsaButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Mopro as early as possible
        // NOTE: This is for Keccak (zkey) specifically
        initializeMoproAndMeasureTime()

        // Maybe black nice, need more style tweaks though
        view.backgroundColor = .white
        setupMainUI()
    }

    // Move the initialization to a background thread
    private func initializeMoproAndMeasureTime() {
        let start = CFAbsoluteTimeGetCurrent()

        DispatchQueue.global(qos: .background).async {
            do {
                try initializeMopro()
                let timeTaken = CFAbsoluteTimeGetCurrent() - start

                DispatchQueue.main.async {
                    // Assuming you have a reference to KeccakZkeyViewController
                    let keccakZkeyVC = KeccakZkeyViewController()
                    keccakZkeyVC.delegate = self
                    self.present(keccakZkeyVC, animated: true, completion: nil)

                    keccakZkeyVC.delegate?.didUpdateInitializationTime(timeTaken)
                }
            } catch let error as MoproError {
                DispatchQueue.main.async {
                    print("MoproError: \(error)")
                    // Optionally update the UI to show error
                }
            } catch {
                DispatchQueue.main.async {
                    print("Unexpected error: \(error)") 
                    // Optionally update the UI to show error
                }
            }
        }
    }

    func setupMainUI() {
        keccakSetupButton.setTitle("Keccak (Setup)", for: .normal)
        keccakSetupButton.addTarget(self, action: #selector(openKeccakSetup), for: .touchUpInside)

        keccakZkeyButton.setTitle("Keccak (Zkey)", for: .normal)
        keccakZkeyButton.addTarget(self, action: #selector(openKeccakZkey), for: .touchUpInside)

        rsaButton.setTitle("RSA", for: .normal)
        rsaButton.addTarget(self, action: #selector(openRSA), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [keccakSetupButton, keccakZkeyButton, rsaButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        self.title = "Mopro Examples"

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func openKeccakSetup() {
        let keccakSetupVC = KeccakSetupViewController()
        navigationController?.pushViewController(keccakSetupVC, animated: true)
    }

    @objc func openKeccakZkey() {
        let keccakZkeyVC = KeccakZkeyViewController()
        keccakZkeyVC.delegate = self
        navigationController?.pushViewController(keccakZkeyVC, animated: true)
    }

    @objc func openRSA() {
        let rsaVC = RSAViewController()
        navigationController?.pushViewController(rsaVC, animated: true)
    }
}

extension ViewController: KeccakZkeyViewControllerDelegate {
    func didUpdateInitializationTime(_ timeTaken: Double) {
        // This will call the updateInitializationTime method of KeccakZkeyViewController
        keccakZkeyViewController?.updateInitializationTime(timeTaken)
    }
}

// extension ViewController: KeccakZkeyViewControllerDelegate {
//     func didUpdateInitializationTime(_ timeTaken: Double) {
//         DispatchQueue.main.async {
//             self.textView.text += "Initializing arkzkey already done, took \(timeTaken) seconds.\n"
//         }
//     }
// }

//        // Make buttons bigger
//        proveButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
//        verifyButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
//        ])
