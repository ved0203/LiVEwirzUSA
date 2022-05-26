//
//  Constant.swift
//  My ID
//

import UIKit

struct TwitterConstants {    
    static let CONSUMER_KEY = "qERBloPTg6pYvVcrtcTlhVoQF"
    static let CONSUMER_SECRET_KEY = "eVMYyLAKHwIK2cS1j46pOdaXPqvjonNY2VQtsnMYypurxR53oj"
    static let CALLBACK_URL = "livewirz://"
}

struct GlobalConstant {
    // MARK: APP Name and Url
    static let APP_NAME = "LiVEwirz"
    static let Default_URL = "https://crmadmin.livewirz.com/apis/"
    // static let Default_URL = "http://livewire-ssams-com.stackstaging.com/apis/"
    static let APIKey = "123456"
    static let GoogleAPIKey = ""
    static let FACEBOOKSCHEME = ""
    static let KKIsLogin = "islogin"
    
    // MARK: - Screen Size
    static let SCREENWIDTH = UIScreen.main.bounds.size.width
    static let SCREENHEIGHT = UIScreen.main.bounds.size.height
    static let SCREENMAXLENGTH = max(GlobalConstant.SCREENWIDTH, GlobalConstant.SCREENHEIGHT)
    static let SCREENMINLENGTH = min(GlobalConstant.SCREENWIDTH, GlobalConstant.SCREENHEIGHT)
   
    // MARK: - Device IPHONE
    static let ISIPHONE4ORLESS  = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH < 568.0
    static let ISIPHONE5 = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 568.0
    static let ISIPHONE6 = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 667.0
    static let ISIPHONE6P = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 736.0
    static let ISIPHONEXAndXS = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 812.0
    static let ISIPHONEXSMax = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 2688.0
    static let ISIPHONEXR = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 1792.0
    
    static let ISIPAD = UIDevice.current.userInterfaceIdiom == .pad && GlobalConstant.SCREENMAXLENGTH == 1024.0
    static let ISIPADPRO = UIDevice.current.userInterfaceIdiom == .pad && GlobalConstant.SCREENMAXLENGTH == 1366.0
    // MARK: - Device Version
    static let SYSVERSIONFLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (GlobalConstant.SYSVERSIONFLOAT < 8.0 && GlobalConstant.SYSVERSIONFLOAT >= 7.0)
    static let iOS8 = (GlobalConstant.SYSVERSIONFLOAT >= 8.0 && GlobalConstant.SYSVERSIONFLOAT < 9.0)
    static let iOS9 = (GlobalConstant.SYSVERSIONFLOAT >= 9.0 && GlobalConstant.SYSVERSIONFLOAT < 10.0)
    // MARK: Navigation bar color
    static var navigationBarColor = "#F7941C"
    
    static var font = UIFont(name:"Roboto-Regular", size: 13.0)
    static var fontMedium = UIFont(name:"Roboto-Medium", size: 13.0)
    
    //[NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 13)]
    //[NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 13)]
    
    static var isSuccess: Bool  = false
    static var isSuccessF: Bool  = false
    
    static var isController = ""
    static var isController2 = ""
    static var isConcerOn: Bool = true
    
    // MARK: Caller Name
    static var kkCallerName = ""
    static var kkCallerID = ""
    static var kkCheckOutDate = ""
    static var selectedIndexpath: Int = 0
    static var selectedNumber: Int = 0
    
    static var kkBooking_id = ""
    static var kkBookingSuccessfull = ""
    
    static var KKbooking_status = ""
    static var controllerCheck = ""
    static var isAlreadyLaunchedOnce = false
    static var arrayshareEkeyArray: NSMutableArray = NSMutableArray()
    
    // MARK: Validation Messages
    
    static var phoneValidationMessage = "Please enter mobile number & password!"
    static var maximumPhoneNumberLimit = "Mobile number can’t be less than 8 digits and more than 13 digits!"
    static let emailValidationMessage  = "Please enter valid email."
    static var passwordValidationMessage = "Please enter password."
    static var currentPasswordValidationMessage = "Please enter current password."
    static var newPasswordValidationMessage = "Please enter new password."
    static var confirmPasswordValidationMessage = "Please enter confirm password."
    static var passwordValidationMaxMessage = "Please enter minimum 6 digits of password."
    static var forloginValidation = "Please login fist."
    static var matchTwoPasswords = "New password and confirm password  does not match!"
}

// MARK: All Segue

struct Segue {
    static let kkSegueIntroductionToHome = "introductionToHome"
}

// MARK: API Names

struct APIName {
    static let kkUserLogin = "auth/user_signin"
    static let kkUserSignUp = "auth/user_registration"
    static let kkVerifyUserEmail = "auth/check_email_exist"
    static let kkUser_logout = "auth/user_logout"
    static let kkUser_registration_by_phone = "auth/user_registration_by_phone"
    static let kkUser_verify_otp = "auth/verify_otp"
    static let kkForgot_password = "auth/forgot_password"
    static let kkChange_password = "auth/change_password"
    static let kkResend_otp = "auth/resend_otp"
    static let kkUpdate_profile = "auth/update_profile"
    static let kkUser_profile = "auth/user_profile"
    static let kkConcert_User_profile = "auth/concert_user_profile"
    static let kkSuggestion = "auth/frnd_suggestions"
    static let kkRequest_for_frnd = "auth/request_for_frnd"
    static let kkFrnd_requests = "auth/frnd_requests"
    static let kkMy_frnds = "auth/my_frnds"
    static let kkSearchfrnds = "auth/search_frnd"
    static let kkSend_feedback = "auth/send_feedback"
    static let kkAdd_photo_video = "vault/add_photo_video"
    static let kkSearch_events = "events/search_events"
    static let kkPre_populate_events = "events/pre_populate_events"
    static let kkAdd_event_by_artist = "events/add_event_by_artist"
    static let kkAdd_event_by_fan = "events/add_event_by_fan"
    static let kkSend_mail_for_add_artist = "events/send_mail_for_add_artist"
    static let kkproducts = "events/products"
    static let kkMy_events = "events/my_events"
    static let kkAdd_to_cart = "checkout/add_to_cart"
    static let kkSave_address = "checkout/save_address"
    static let kkSocial_login = "auth/user_registration_by_social"
    static let kkCreate_order = "checkout/create_order"
    static let kkVault_photos = "vault/vault_photos"
    static let kkVault_videos = "vault/vault_videos"
    static let kkPost_comment = "vault/post_comment"
    static let kkHomeposts_list = "home/posts_list"
    static let kkDelete_event_by_fan = "events/delete_event_by_fan"
    static let kkDelete_event_by_artist = "events/delete_event_by_artist"
    static let kkPosted_event_list = "events/event_review_list"
    
    static let kkPosted_artist_setting = "home/get_artist_settings"
    static let kkPosted_save_artist_setting = "home/artist_settings"
    static let kkPost_like_unlike = "home/post_like_unlike"
    static let kkLike_unlike_on_comment = "home/like_unlike_on_comment"
    static let kkPost_user_comment_onpost = "home/add_user_comment_onpost"
    static let kkPost_user_comment_list = "home/post_user_comment_list"
    static let kkArtists_followed_posts_list = "home/artists_followed_posts_list"
    static let kkAartist_add_post = "vault/artist_add_post"
    static let kkUser_app_settings = "home/user_app_settings"
    static let kkAdd_report_post = "vault/add_report_post"
    static let kkAdd_report_user = "auth/add_report_user"
    
    static let kkEvent_info_after_scan_qrcode = "events/event_info_after_scan_qrcode"
    static let kkConcert_mode_contents = "vault/concert_mode_contents"
    static let kkDelete_vault_content = "vault/delete_vault_content"
    static let kkMultiDelete_vault_content = "vault/multi_delete_vault_content"
    static let kkGetMediaList = "home/event_gallery"
    
    static let kkJoin_event_by_user = "home/join_event_by_user"
    
    static let kkStates_of_us = "auth/states_of_us"
    static let kkReport_post_reasons = "vault/report_post_reasons"
    static let kkAdd_event_review = "events/add_event_review"
    
    static let kkMy_post_list = "auth/my_posts_list"
    static let kkMy_frnd_list = "auth/my_frnds"
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 812
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && GlobalConstant.SCREENMAXLENGTH  == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && GlobalConstant.SCREENMAXLENGTH   == 1366.0
    static let IS_IPHONE_XSMAX      = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 896
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && GlobalConstant.SCREENMAXLENGTH == 1792
}
