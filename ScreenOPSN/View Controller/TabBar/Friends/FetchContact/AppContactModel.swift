//
//  AppContactModel.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-06-29.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class AppContactFilterModel {
    var address = ""
    var is_invited = ""
    var  age = "";
    var city_id = "";
    var city_name = ""
    var cityname = ""
    var company_name = ""
    var country_code = ""
    var country_id = ""
    var country_name = ""
    var countryname = ""
    var created_on = ""
    var device_id = ""
    var device_token = ""
    var dob = ""
    var email = ""
    var followers = ""
    var following = ""
    var gender = ""
    var invite_id = ""
    var invited_by = ""
    var invited_to = ""
    var status_id = ""
    var is_login = ""
    var is_email_verify = ""
    var is_phone_verify = ""
    var modified_on = ""
    var name = ""
    var oauth_provider = ""
    var oauth_uid = ""
    var phone_no = ""
    var posts = ""
    var profile_id = ""
    var profile_pic = ""
    var request_status = ""
    var roleid = ""
    var rolename = ""
    var state_id = ""
    var state_name = ""
    var statename = ""
    var upload_folder_name = ""
    var user_status = ""
    var userid = ""
    var zipcode = ""
    
    func toString()-> String{
        return "AppContactFilterModel{name:"+name+",modified_on:"+modified_on+",address:"+address+",profile_pic:"+profile_pic+",rolename:"+rolename+"}"
    }
}
