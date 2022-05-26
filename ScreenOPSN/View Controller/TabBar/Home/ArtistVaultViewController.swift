//
//  ArtistVaultViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ArtistVaultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            Global.navigatioinBarClear(vc: self)
    }
}

extension ArtistVaultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtistVaultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArtistVaultTableViewCell", for: indexPath) as! ArtistVaultTableViewCell
        return cell
    }
}
