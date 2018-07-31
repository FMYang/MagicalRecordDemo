//
//  ViewController.swift
//  MagicalRecordDemo
//
//  Created by yfm on 2018/7/31.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let path = "https://c.m.163.com/recommend/getSubDocPic?from=toutiao&prog=Rpic2&open=&openpath=&passport=8E/MTw4x6CjQef5NzXYRu%2Bxu5Qgz9IwfxBMkTUgNz7o%3D&devId=0ruGb4%2BFBTnxKBxQ4XAU1NjNuMn%2BPttYS7jFtfotw9G6jNdpzU62sP1jSy8uzsx8&version=37.1&spever=false&net=wifi&lat=&lon=&ts=1533029662&sign=/a4YgBAuAVZ1JPK5RoR6PUFX6UrtuxmePCzD9g8cKix48ErR02zJ6/KXOnxX046I&encryption=1&canal=appstore&offset=0&size=10&fn=5&spestr=shortnews"

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: path)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error)
            } else {
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                print(json)
            }
        }.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

