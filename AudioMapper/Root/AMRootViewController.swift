//
//  AMRootViewController.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 12/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit

class AMRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.backgroundColor = AMColor.appLightGray
        
        let task1Button: UIButton = self.getButton(with: "Task 1")
        task1Button.frame = CGRect(x: -60+self.view.bounds.size.width/2, y: -50+self.view.bounds.size.height/2, width: 120, height: 40)
        self.view.addSubview(task1Button)
        
        let task2Button: UIButton = self.getButton(with: "Task 2")
        task2Button.frame = CGRect(x: -60+self.view.bounds.size.width/2, y: 10+self.view.bounds.size.height/2, width: 120, height: 40)
        self.view.addSubview(task2Button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func getButton(with title: String) -> UIButton {
        
        let button: UIButton = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(AMColor.appDarkBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(self.launchRelevantTaskController(sender:)), for: .touchDown)
        button.layer.borderColor = AMColor.appDarkBlack.cgColor
        button.layer.borderWidth = 0.5
        return button
    }
    
    func launchRelevantTaskController(sender: UIButton) {
        
        let taskController = (sender.title(for: .normal)! == "Task 1") ? AMContactsViewController(style: .plain) : AMAudioContactsViewController(style: .plain)
        self.navigationController?.pushViewController(taskController, animated: true)
    }
}
