//
//  RHCache.swift
//  RHMoyaCache
//
//  Created by 荣恒 on 2018/9/28.
//  Copyright © 2018 荣恒. All rights reserved.
//

import Foundation

//MARK : - 缓存管理类
public class RHCache {
    
    /// 单例对象
    public static let shared = RHCache()
    
    private init() {}
    
    /// 存储列表
    private var storageList : [String : AnyObject] = [:]
}

//MARK : - 对象缓存
public extension RHCache {
    
    /// 同步获取缓存
    func object<T : Codable>(for key: String) throws -> T {
        return try getStorage(T.self).object(forKey: key)
    }
    
    /// 异步获取缓存
    func object<T : Codable>(_ type : T.Type, for key: String, completion : @escaping (Result<T>) -> Void) {
        do {
            try getStorage(type).async.object(forKey: key, completion: completion)
        } catch let error {
            completion(Result.failure(error))
        }
    }
    
    /// 同步缓存数据
    func cachedObject<T : Codable>(_ cachedObject: T, for key: String) throws {
        try getStorage(T.self).setObject(cachedObject, forKey: key)
    }
    
    /// 异步缓存数据
    func asyncCachedObject<T : Codable>(_ cachedObject: T, for key: String, completion : @escaping (Result<T>) -> Void) {
        do {
            try getStorage(T.self).async.object(forKey: key, completion: { result in
                completion(result)
            })
        } catch let error {
            completion(Result.failure(error))
        }
    }
    
    /// 删除指定缓存，同步
    func removeCachedObject<T : Codable>(_ type: T.Type, for key: String) throws {
        try getStorage(type).removeObject(forKey: key)
    }
    
    /// 异步查所有 T 类型的数据
    func objectAll<T : Codable>(_ type : T.Type, completion : @escaping ([T]) -> Void) {
        do {
            let asyncStorage = try getStorage(type).async
            let memoryStorage = asyncStorage.innerStorage.memoryStorage
            let diskStorage = asyncStorage.innerStorage.diskStorage
            
            asyncStorage.serialQueue.async {
                let memoryAll = memoryStorage.entrtyAll().map({ $0.object })
                if !memoryAll.isEmpty {
                    completion(memoryAll)
                } else {
                    let diskAll = diskStorage.entrtyAll().map({ $0.object })
                    completion(diskAll)
                }
            }
        } catch {
            completion([])
        }
    }
    
}

extension RHCache {
    /// 获取存储对象，没有就创建
    func getStorage<T : Codable>(_ type : T.Type) throws -> Storage<T> {
        if let object = storageList["\(type)"],
            let storage = object as? Storage<T> {
            return storage
        } else {
            let storage = try Storage<T>(diskName: "jiangroom.cache.data.\(type)")
            storageList["\(type)"] = storage
            return storage
        }
    }
}



extension Storage where T: Codable {

    /// 快速构建存储 Storage
    convenience init(diskName : String) throws {
        try self.init(diskConfig: DiskConfig(name: diskName),
                  memoryConfig: MemoryConfig(), transformer:
            TransformerFactory.forCodable(ofType: T.self))
    }
    
}

// MARK: - 查询所有缓存
protocol StorageAllAware {
    associatedtype T
    /**
     查询所有数据
     */
    func entrtyAll() -> [Entry<T>]
}

extension DiskStorage : StorageAllAware {
    func entrtyAll() -> [Entry<T>] {
        var entrys : [Entry<T>] = []
        guard let files = fileManager.subpaths(atPath: path) else { return entrys }
        
        for file in files {
            if let entry = try? entry(forKey: "\(path)/\(file)") {
                entrys.append(entry)
            }
        }
        
        return entrys
    }
}

extension MemoryStorage : StorageAllAware {
    func entrtyAll() -> [Entry<T>] {
        var entrys : [Entry<T>] = []
        for key in self.keys {
            if let entry = try? entry(forKey: key) {
                entrys.append(entry)
            }
        }
        return entrys
    }
}
