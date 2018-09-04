//
//  MapFoodViewController.swift
//  MapFoodDemo
//
//  Created by nhl on 2018/9/3.
//  Copyright © 2018年 nhl. All rights reserved.
//

import UIKit

class MapFoodViewController: UIViewController {
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var TableViewTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var relocationButton: UIButton!
    
    var tableViewOrginY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func didRelocationButtonTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.tableViewOrginY = UIScreen.main.bounds.height / 2
            self.tableView.frame.origin = CGPoint.init(x: 0, y: UIScreen.main.bounds.height / 2)
            self.updateView(self.tableViewOrginY)
        }
    }
    
    @IBAction func didMoreButtonTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.tableViewOrginY = UIScreen.main.bounds.height / 2
            self.tableView.frame.origin = CGPoint.init(x: 0, y: UIScreen.main.bounds.height / 2)
            self.updateView(self.tableViewOrginY)
        }
    }
    
    //更新视图的位置
    func updateView(_ tableViewY: CGFloat) {
        //定位按钮
        if tableViewY >= UIScreen.main.bounds.height / 4 {
            relocationButton.frame.origin = CGPoint.init(x: tableView.frame.origin.x + 10, y: tableView.frame.origin.y - 10 - relocationButton.frame.height)
        }else {
            relocationButton.frame.origin = CGPoint.init(x: tableView.frame.origin.x + 10, y: UIScreen.main.bounds.height / 4 + relocationButton.frame.height)
        }
        //搜索返回显示判断
        if  tableViewY > UIScreen.main.bounds.height / 4 {
            UIView.animate(withDuration: 0.3) {
                self.searchView.frame.origin = CGPoint.init(x: 10, y: 0)
            }
        }else {
            UIView.animate(withDuration: 0.3) {
                self.searchView.frame.origin = CGPoint.init(x: 10, y: 0 - tableViewY)
            }
        }
        //更多商家显示判断
        if  tableViewY < (UIScreen.main.bounds.height - headView.frame.height - 64)  {
            UIView.animate(withDuration: 0.1) {
                self.moreView.alpha = 0
            }
        }else {
            UIView.animate(withDuration: 0.1) {
                self.moreView.alpha = 1
            }
        }
    }
}
extension MapFoodViewController {
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(didMapViewPan))
        tableView.addGestureRecognizer(pan)
        TableViewTopLayoutConstraint.constant = UIScreen.main.bounds.height - 64
        tableViewOrginY = UIScreen.main.bounds.height - 64
        moreView.alpha = 0
    }
    
    
    @objc func didMapViewPan(pan: UIPanGestureRecognizer) {
        let point = pan.translation(in: mapView)
        let y = tableView.frame.origin.y
        switch pan.state {
        case .changed:
            updateView(y)
            //可移动范围内移动
            if y >= 0 && y <= UIScreen.main.bounds.height - headView.frame.height - 64 {
                pan.view?.center = CGPoint.init(x: (pan.view?.center.x ?? 0) , y: (pan.view?.center.y ?? 0) + point.y)
                pan.setTranslation(CGPoint.zero, in: mapView)
            }
            //超出可移动范围时，根据拖动方向而定
            if (y <= 0 && point.y >= 0) || (y >= UIScreen.main.bounds.height - headView.frame.height - 64 && point.y <= 0){
                pan.view?.center = CGPoint.init(x: (pan.view?.center.x ?? 0) , y: (pan.view?.center.y ?? 0) + point.y)
                pan.setTranslation(CGPoint.zero, in: mapView)
            }
            
        case .ended:
            if y > tableViewOrginY{//向下
                if  y > UIScreen.main.bounds.height / 2 {
                    pan.view?.frame.origin = CGPoint.init(x: 0, y: UIScreen.main.bounds.height - headView.frame.height - 64)
                    UIView.animate(withDuration: 0.3) {
                        self.moreView.alpha = 1
                    }
                }else {
                    self.moreView.alpha = 0
                    pan.view?.frame.origin =  CGPoint.init(x: 0, y: UIScreen.main.bounds.height / 2)
                }
            }else {
                self.moreView.alpha = 0
                if  y < UIScreen.main.bounds.height / 2 {
                    pan.view?.frame.origin = CGPoint.init(x: 0, y: 0)
                }else {
                    pan.view?.frame.origin =  CGPoint.init(x: 0, y: UIScreen.main.bounds.height / 2)
                }
            }
            pan.setTranslation(CGPoint.zero, in: mapView)
            tableViewOrginY = tableView.frame.origin.y
            updateView(tableViewOrginY)
        default:
            break
        }
        
    }
}

extension MapFoodViewController: UIGestureRecognizerDelegate {
    
    
}
extension MapFoodViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") else {
            return UITableViewCell()
        }
        return cell
    }
}







