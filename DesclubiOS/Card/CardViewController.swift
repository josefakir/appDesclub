//
//  CardViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 15/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class CardViewController: MembershipBaseUIViewController {

	
	@IBOutlet var commonView: UIView!
	@IBOutlet weak var membershipAccess: UIButton!
	@IBOutlet weak var couponImage: UIImageView!
	
	
	@IBOutlet weak var anonymousContainerView: UIView!
	@IBOutlet weak var membershipContainerView: UIView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var cardNumber: UILabel!
	@IBOutlet weak var email: UILabel!
	@IBOutlet weak var validThru: UILabel!
	
	@IBOutlet weak var logout: UIButton!
	@IBOutlet weak var versionLabel: UILabel!
	
    @IBOutlet weak var adminSettingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.edgesForExtendedLayout = UIRectEdge.None
		
		//set version
		versionLabel.text = "v" + CommonConstants.getAppVersion()
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
        GoogleAnalitycUtil.trackScreenName("analytics.screen.card")

		//important
		self.sourveView = membershipAccess
		
		self.hideAndShowComponents()
	}
	
	private func hideAndShowComponents(){
		print(UserHelper.isLoggedIn())
		
        self.adminSettingView.hidden = true

		if UserHelper.isLoggedIn() {
			anonymousContainerView?.hidden = true
			
			membershipContainerView?.hidden = false
			
			//show card information
			let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
			self.name?.text = membership.name
			self.cardNumber?.text = UserHelper.getCardNumber()
			self.email.text = membership.email
			self.validThru.text = UserHelper.getValidThru()
            
            
//            if membership.email == "sergio@geckodelabs.com" {
//                self.adminSettingView.hidden = false
//            }
			
		}else{
			anonymousContainerView?.hidden = false
			membershipContainerView?.hidden = true
		}
	}
	
	override func afterLogin() {
		super.afterLogin()
		self.hideAndShowComponents()
	}
	
    @IBAction func adminSwitchRulerGeofencing(sender: UISwitch) {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(sender.on, forKey: CommonConstants.settingAdminRulesGeo)
        userDefault.synchronize()
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate {
            app.loadPointGeo()
        }
    }

	@IBAction func membershipAccess(sender: UIButton) {
		self.showMembershipAccessModal()
	}
	
    @IBAction func showWarranty(sender: UIButton){
        
        let storyboard = UIStoryboard(name: "Warranty", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
	
	@IBAction func logout(sender: UIButton) {
		
		let refreshAlert = UIAlertController(title: "¿Quiere cerrar su sesión?", message: "Sin una membresía activa no podrás disfrutar de los descuentos", preferredStyle: UIAlertControllerStyle.Alert)
		
		refreshAlert.addAction(UIAlertAction(title: "Sí, estoy seguro", style: .Default, handler: { (action: UIAlertAction!) in
			
			UserHelper.logout()
			self.hideAndShowComponents()
  }))
		
		refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: { (action: UIAlertAction!) in
			print("Cancelled")
  }))
		
		self.presentViewController(refreshAlert, animated: true, completion: nil)
	}
	
}
