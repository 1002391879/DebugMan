//
//  LogTabBarViewController.swift
//  exampleWindow
//
//  Created by Remi Robert on 20/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class LogTabBarViewController: UITabBarController {

    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = UIApplication.shared.delegate?.window {
            window?.endEditing(true)
        }
        
        setChildControllers()
        
        self.selectedIndex = LogsSettings.shared.tabBarSelectItem
        self.tabBar.tintColor = Color.mainGreen
    }
    
    //MARK: - private
    func setChildControllers() {

        //1.
        let logs = UIStoryboard(name: "Logs", bundle: Bundle(for: DebugMan.self)).instantiateViewController(withIdentifier: "Logs")
        let network = UIStoryboard(name: "Network", bundle: Bundle(for: DebugMan.self)).instantiateViewController(withIdentifier: "Network")
        let app = UIStoryboard(name: "App", bundle: Bundle(for: DebugMan.self)).instantiateViewController(withIdentifier: "App")
        
        //2.
        Sandboxer.shared.isSystemFilesHidden = false
        Sandboxer.shared.isExtensionHidden = false
        Sandboxer.shared.isShareable = true
        Sandboxer.shared.isFileDeletable = true
        Sandboxer.shared.isDirectoryDeletable = true
        guard let sandboxer = Sandboxer.shared.homeDirectoryNavigationController() else {return}
        sandboxer.tabBarItem.title = "Sandbox"
        sandboxer.tabBarItem.image = UIImage.init(named: "DebugMan_sandbox", in: Bundle.init(for: DebugMan.self), compatibleWith: nil)
        
        //3.
        guard let tabBarControllers = LogsSettings.shared.tabBarControllers else {
            self.viewControllers = [logs, network, sandboxer, app]
            return
        }
        
        //4.添加额外的控制器
        var temp = [logs, network, sandboxer, app]
        
        for vc in tabBarControllers {
            
            let nav = UINavigationController.init(rootViewController: vc)
            nav.navigationBar.barTintColor = UIColor.init(hexString: "#1f2124")
            
            //****** 以下代码从LogNavigationViewController.swift复制 ******
            nav.navigationBar.isTranslucent = false
            
            nav.navigationBar.tintColor = Color.mainGreen
            nav.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20),
                                                 NSForegroundColorAttributeName: Color.mainGreen]
            
            let selector = #selector(LogNavigationViewController.exit)
            
            
            let image = UIImage(named: "DebugMan_close", in: Bundle(for: LogNavigationViewController.self), compatibleWith: nil)
            let leftItem = UIBarButtonItem(image: image,
                                             style: .done, target: self, action: selector)
            leftItem.tintColor = Color.mainGreen
            nav.topViewController?.navigationItem.leftBarButtonItem = leftItem
            //****** 以上代码从LogNavigationViewController.swift复制 ******
            
            temp.append(nav)
        }
        
        self.viewControllers = temp
    }
    
    //MARK: - target action
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        guard let items = self.tabBar.items else {return}
        
        for index in 0...items.count-1 {
            if item == items[index] {
                LogsSettings.shared.tabBarSelectItem = index
            }
        }
    }
    
    //MARK: - show more than 5 tabs by liman
    override var traitCollection: UITraitCollection {
        let realTraits = super.traitCollection
        let lieTrait = UITraitCollection.init(horizontalSizeClass: .regular)
        return UITraitCollection(traitsFrom: [realTraits, lieTrait])
    }
}
