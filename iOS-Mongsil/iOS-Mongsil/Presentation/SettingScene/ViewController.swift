//
//  ViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/17.
//

import UIKit

class ViewController: UIViewController {
    let settingView = SettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingView)
        settingView.translatesAutoresizingMaskIntoConstraints = false
//
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
