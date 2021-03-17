//
//  LxDragButton.swift
//  MayBe
//
//  Created by liuxiang on 2021/3/1.
//  Copyright © 2021 liuxiang. All rights reserved.
//

import UIKit


class LxDragButton: UIButton {

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
       
        let isCurInRect = self.bounds.contains((touch?.location(in: self))!)
        let isPreInRect = self.bounds.contains((touch?.previousLocation(in: self))!)
        if (!isCurInRect) { // 现在在外面
               if (isPreInRect) { // 之前在里边
                   // 从里边滑动到外边
                   
               } else {  // 之前在外边
                   // 在按钮外拖动
                   // 在按钮范围外拖动手动发送UIControlEventTouchDragOutside事件
                
                self.sendActions(for: .touchDragOutside)
               }
           } else { // 现在在里边
               if (!isPreInRect) { // 之前在外边
                   // 从外边滑动到里边
                   // 从按钮范围外滑动回按钮范围内，需要手动调用touchesBegan方法，让按钮进入高亮状态，并开启UIControl的事件监听
                   //[self beginTrackingWithTouch:touch withEvent:event];
                let set:Set<UITouch> = [touch!]
                self.touchesBegan(set, with: event)
               } else { // 之前在里边
                   // 在按钮内拖动
               }
           }

        super.touchesMoved(touches, with: event)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        if !self.bounds.contains(point!) {
            self.sendActions(for: .touchUpOutside)
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let isCurInRect = self.bounds.contains(touch.location(in: self))
        let isPreInRect = self.bounds.contains(touch.previousLocation(in: self))
        
        if (!isCurInRect) { // 现在在外面
                if (isPreInRect) { // 之前在里边
                    // 从里边滑动到外边
                    // 从按钮范围内滑动到按钮范围外手动触发UIControlEventTouchDragExit事件并阻断按钮默认事件的执行
                    self.sendActions(for: .touchDragExit)
                    // 阻断按钮默认事件的事件的执行后，需要手动触发touchesCancelled方法，让按钮从高亮状态变成默认状态
//                    self.touchesCancelled([touch], with: event)
                    return false;
                } else {  // 之前在外边
                    // 在按钮外拖动
                    // 在按钮范围外滑动时，需要手动触发touchesCancelled方法，让按钮从高亮状态变成默认状态，并阻断按钮默认事件的执行
                    self.sendActions(for: .touchDragEnter)

//                    self.touchesCancelled([touch], with: event)

                    return false;
                }
            } else { // 现在在里边
                if (!isPreInRect) { // 之前在外边
                    // 从外边滑动到里边
                    // 从按钮范围外滑动到按钮范围内，需要手动触发UIControlEventTouchDragEnter事件
                    self.sendActions(for: .touchDragEnter)
                    return super.continueTracking(touch, with: event)
                } else { // 之前在里边
                    // 在按钮内拖动
                    return super.continueTracking(touch, with: event)
                }
            }
//         super.continueTracking(touch, with: event)
                        

    }

}



