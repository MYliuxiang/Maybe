//
//  LXAsync.swift
//  MayBe
//
//  Created by liuxiang on 2020/12/22.
//  Copyright © 2020 liuxiang. All rights reserved.
//

import Foundation

struct LXAsync {
    public typealias Task = () -> Void
    
    ///异步调用
    /// - Parameter task: 任务block
    public static func async(_ task: @escaping Task) {
        _async(task)
    }
    
    /// 异步调用
    /// - Parameters:
    ///   - task: 任务block
    ///   - mainTask: 回到主线程的block
    public static func async(_ task: @escaping Task, _ mainTask: @escaping Task) {
        _async(task, mainTask)
    }
    
    private static func _async(_ task: @escaping Task, _ mainTask: Task? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        
    }
    
    /// 主队列延时调用
    /// - Parameters:
    ///   - seconds: 时间
    ///   - block: 执行任务
    /// - Returns: DispatchWorkItem，可取消 item.cancle
    @discardableResult
    public static func delay(_ seconds: Double, _ block: @escaping Task) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds,
                                      execute: item)
        return item
    }
    
    
    /// 全局队列延时调用
    /// - Parameters:
    ///   - seconds: 时间
    ///   - task: 任务block
    /// - Returns: DispatchWorkItem
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }
    
    /// 全局队列延时调用
    /// - Parameters:
    ///   - seconds: 时间
    ///   - task: 任务block
    ///   - mainTask: 调用完成回到主线程的操作block
    /// - Returns: DispatchWorkItem
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping Task, _ mainTask: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, mainTask)
    }
    
    private static func _asyncDelay(_ seconds: Double, _ task: @escaping Task, _ mainTask: Task? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds,
                                          execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
    
    
    
}
