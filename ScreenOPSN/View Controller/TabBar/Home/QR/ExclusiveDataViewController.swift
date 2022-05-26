//
//  ExclusiveDataViewController.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-07-07.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ExclusiveDataViewController: UIViewController {
    //MARK: IBoutlet 
    @IBOutlet weak var exclusiveTableView: UITableView!
 
    var exclusiveData: NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        exclusiveTableView.tableFooterView = UIView()
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exclusiveTableView.reloadData()
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
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

extension ExclusiveDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exclusiveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExclusiveTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ExclusiveTableViewCell", for: indexPath) as! ExclusiveTableViewCell
        
        let artistExclusive = exclusiveData[indexPath.row] as! NSDictionary

        let str2 = Global.getStringValue(artistExclusive.value(forKey: "image_url") as AnyObject)
        cell.exclusiveImage.sd_setImage(with: URL(string: str2), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
        cell.exclusive_event_name.text = Global.getStringValue(artistExclusive.value(forKey: "event_name") as AnyObject)
        cell.exclusive_venue.text = Global.getStringValue(artistExclusive.value(forKey: "venue") as AnyObject)

        
        return cell
    }
    
    
}
