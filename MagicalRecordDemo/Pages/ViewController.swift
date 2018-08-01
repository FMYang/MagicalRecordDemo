//
//  ViewController.swift
//  MagicalRecordDemo
//
//  Created by yfm on 2018/7/31.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import MagicalRecord

class ViewController: UIViewController {

    var sourceData = [News]()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame)
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)

//        self.loadData()

        self.conflictTest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

                let result = News.mr_findAll() as! [News]
                self.sourceData += result
                self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func conflictTest() {
        let task1 = TaskOperation()
        task1.taskBlock = {
            MagicalRecord.save({ (localContext) in
                let obj = News.mr_findFirst(in: localContext)
                print("======1 \(obj?.objectID)")
                obj?.title = "task1"
            })
        }

        let task2 = TaskOperation()
        task2.taskBlock = {
            MagicalRecord.save({ (localContext) in
                let obj = News.mr_findFirst(in: localContext)
                print("======2 \(obj?.objectID)")
                obj?.title = "task2"
            })
        }

        let task3 = TaskOperation()
        task3.taskBlock = {
            MagicalRecord.save({ (localContext) in
                let obj = News.mr_findFirst(in: localContext)
                print("=======3 \(obj?.objectID)")
                obj?.title = "task3"
            })
        }

//        task2.addDependency(task1)

        OperationQueue.main.addOperation(task1)
        OperationQueue.main.addOperation(task2)
        OperationQueue.main.addOperation(task3)
    }

    func loadData() {
        let path = "https://c.m.163.com/recommend/getSubDocPic?from=toutiao&prog=Rpic2&open=&openpath=&passport=8E/MTw4x6CjQef5NzXYRu%2Bxu5Qgz9IwfxBMkTUgNz7o%3D&devId=0ruGb4%2BFBTnxKBxQ4XAU1NjNuMn%2BPttYS7jFtfotw9G6jNdpzU62sP1jSy8uzsx8&version=37.1&spever=false&net=wifi&lat=&lon=&ts=1533029662&sign=/a4YgBAuAVZ1JPK5RoR6PUFX6UrtuxmePCzD9g8cKix48ErR02zJ6/KXOnxX046I&encryption=1&canal=appstore&offset=0&size=10&fn=5&spestr=shortnews"

//        let path = "https://c.m.163.com/recommend/getSubDocPic?from=toutiao"

        let url = URL(string: path)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error)
            } else {
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                let jsonArr = json["tid"] as! [[String: Any]]

                var result = [News]()
                for dic in jsonArr {
                    let obj = News.mr_createEntity()
                    obj?.title = dic["title"] as? String
                    obj?.source = dic["source"] as? String
                    obj?.id = dic["id"] as? String
                    if let title = obj?.title, !title.isEmpty {
                        result.append(obj!)
                    }
                }
                DispatchQueue.main.async {
                    self.sourceData = result
                    self.tableView.reloadData()
                }

                // 数据库
                MagicalRecord.save({ (localContext) in
                    for dic in jsonArr {
                        let predicate = NSPredicate(format: "id==%@", dic["id"] as? String ?? "")
                        let count = News.mr_countOfEntities(with: predicate)
                        print("count=\(count)")
                        var entity: News?
                        if count == 0 {
                            entity = News.mr_createEntity(in: localContext)
                        } else {
                            entity = News.mr_findAll(with: predicate, in: localContext)?.first as? News
                        }
                        entity?.title = dic["title"] as? String
                        entity?.source = dic["source"] as? String
                        entity?.id = dic["id"] as? String
                    }
                }, completion: { (finish, error) in
                    let result = News.mr_findAll()
//                    self.sourceData = result as! [News]
//                    self.tableView.reloadData()
                    print(result ?? [])
                })
            }
        }.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sourceData[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
