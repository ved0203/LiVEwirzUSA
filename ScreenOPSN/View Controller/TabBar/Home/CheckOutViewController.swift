//
//  CheckOutViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CheckOutViewController: UIViewController {
    
    @IBOutlet weak var lanyardTableView: UITableView!
    var lanyardProductArray: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        postDataForgetLanyardProduct()
    }
    
    @IBAction func didTappedForGoingToCheckOut(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CompleteOrderViewController") as! CompleteOrderViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func postDataForgetLanyardProduct() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            dictPost = [:]
            WebHelper.requestgetUrl(strURL: APIName.kkproducts, Dictionary: dictPost, Controller: self, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)

                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.lanyardProductArray = success.object(forKey: "products") as! NSArray
                    self.lanyardTableView.reloadData()
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                
                Global.hideActivityIndicator(self.view)
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
}

extension CheckOutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lanyardProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let data = self.lanyardProductArray[indexPath.row] as! NSDictionary
        let image = Global.getStringValue(data.value(forKey: "product_image") as AnyObject)
        cell.productImage.downloadImage(from: image)
        cell.productName.text = Global.getStringValue(data.value(forKey: "product_name") as AnyObject)
        cell.productDescription.text = Global.getStringValue(data.value(forKey: "description") as AnyObject)
        cell.labelPrice.text = "$\(Global.getStringValue(data.value(forKey: "unit_price") as AnyObject))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "CompleteOrderViewController") as! CompleteOrderViewController
        nextVC.getData = self.lanyardProductArray[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

class ProductCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
}
