//
//  SetU3dVC.swift
//  MayBe
//
//  Created by liuxiang on 2020/9/8.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class SetU3dVC: BaseViewController {

     @IBOutlet weak var locationXL: UILabel!
     @IBOutlet weak var ratationL: UILabel!
     @IBOutlet weak var loactionYL: UILabel!
     @IBOutlet weak var scaleL: UILabel!
     @IBOutlet weak var loactionZL: UILabel!
     var positon:U3dLocation = U3dLocation(x: 0.0, y: -3.94, z: 3.64)
     var scale:Float = 3.5
     var ratation:Float = 180.0
    
    @IBOutlet weak var containView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navBar.isHidden = true
//        let uview = UnityGetGLView()
//        containView.addSubview(uview!)
//        uview?.snp.makeConstraints({ (make) in
//            make.edges.equalToSuperview()
//        })
        uint3DAC()
    }
    
    func setValue() {
        locationXL.text = String(format: "x:%.2f", positon.x)
        loactionYL.text = String(format: "y:%.2f", positon.y)
        loactionZL.text = String(format: "z:%.2f", positon.z)
        scaleL.text = String(format: "y:%.2f", scale)
        ratationL.text = String(format: "%.2f", ratation)

    }
    
    @IBAction func locationminusX(_ sender: Any) {
        positon.x = positon.x - 0.03
        uint3DAC()

    }
    
    @IBAction func locationplusX(_ sender: Any) {
        positon.x = positon.x + 0.03
        uint3DAC()

    }
    @IBAction func locationminusY(_ sender: Any) {
        positon.y = positon.y - 0.03
        uint3DAC()

    }
    @IBAction func locationminusZ(_ sender: Any) {
        positon.z = positon.z - 0.03
        uint3DAC()

    }
    
    @IBAction func locationplusZ(_ sender: Any) {
        positon.z = positon.z + 0.03
        uint3DAC()

    }
    @IBAction func locationplusY(_ sender: Any) {
        positon.y = positon.y + 0.03
        uint3DAC()

    }

    
    @IBAction func rationminus(_ sender: Any) {
        ratation = ratation - 30
        uint3DAC()

    }
    @IBAction func rationplus(_ sender: Any) {
        ratation = ratation + 30
        uint3DAC()


    }
    
    @IBAction func scaleminus(_ sender: Any) {
        scale = scale - 0.1
        uint3DAC()

    }
    
    @IBAction func scaleplus(_ sender: Any) {
        scale = scale + 0.1
        uint3DAC()
    }
    
    
    func uint3DAC() {
        setValue()
        let xStr = String(format: "%.2f", positon.x)
        let yStr = String(format: "%.2f", positon.y)
        let zStr = String(format: "%.2f", positon.z)
        let scaleStr = String(format: "%.2f", scale)
        let rationStr = String(format: "%.2f", ratation)

    
//        UnitySendMessage("iOSHolder", "PlayAniWithTransInfo","""
//            {"modelConfig":
//            {"ModelName":"lily","AniName":"level1_lesson1_hello_001","isSpeak":1},
//            "LocalPos":{"x":\(xStr),"y":\(yStr),"z":\(zStr)},
//            "LocalRotation":{"x":0.0,"y":\(rationStr),"z":0.0},
//            "LocalScale":{"x":\(scaleStr),"y":\(scaleStr),"z":\(scaleStr)}}
//            """);
//        print("""
//        {"modelConfig":
//        {"ModelName":"lily","AniName":"level1_lesson1_hello_001","isSpeak":1},
//        "LocalPos":{"x":\(xStr),"y":\(yStr),"z":\(zStr)},
//        "LocalRotation":{"x":0.0,"y":\(rationStr),"z":0.0},
//        "LocalScale":{"x":\(scaleStr),"y":\(scaleStr),"z":\(scaleStr)}}
//        """)
        
    }


   
}


struct U3dLocation {
    var x = 0.0
    var y = 0.0
    var z = 0.0
    
}
