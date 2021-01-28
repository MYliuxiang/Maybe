//
//  LxRefresher.swift
//  MayBe
//
//  Created by liuxiang on 2020/6/9.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import UIKit

class LXHerderRefresh: MJRefreshNormalHeader {

    override func prepare() {
        super.prepare()
        stateLabel?.isHidden = true
        lastUpdatedTimeLabel?.isHidden = true
        arrowView?.image = nil
    }
   

}

class LXFooterRefresh: MJRefreshBackNormalFooter {

    override func prepare() {
        setTitle("没有更多了哦～", for: .noMoreData)
    }
   

}
