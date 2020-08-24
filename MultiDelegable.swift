//

import Foundation

public struct DelegateStore<Delegate> {
    fileprivate var delegatesTable = NSHashTable<AnyObject>.weakObjects()
    
    public init() {}
    
    public func add(_ delegate: Delegate) {
        self.delegatesTable.add(delegate as AnyObject)
    }
    
    public func remove(_ delegate: Delegate) {
        self.delegatesTable.remove(delegate as AnyObject)
    }
    
    public func contains(_ delegate: Delegate) -> Bool {
        return self.delegatesTable.contains(delegate as AnyObject)
    }
    
    public func notifyAll(_ block: (Delegate) -> Void) {
        self.delegatesTable.allObjects.compactMap { $0 as? Delegate }.forEach(block)
    }
}

extension DelegateStore: CustomStringConvertible {
    
    public var description: String {
        var string = "DelegateStore ["
        string += self.delegatesTable.allObjects.map({ return "<\(type(of: $0))>"}).joined(separator: ", ")
        return string + "]"
    }
    
}


public protocol MultiDelegable: class {
    associatedtype Delegate
    
    var delegateStore: DelegateStore<Delegate> { get }
    
    func addDelegate(_ delegate: Delegate)
    func removeDelegate(_ delegate: Delegate)
    func notifyDelegates(_ block: (_ delegate: Delegate) -> Void)
}

extension MultiDelegable {
    
    public func addDelegate(_ delegate: Delegate) {
        guard !self.delegateStore.contains(delegate) else {
            return
        }
        self.delegateStore.add(delegate)
    }
    
    public func removeDelegate(_ delegate: Delegate) {
        self.delegateStore.remove(delegate)
    }
    
    public func notifyDelegates(_ block: (_ delegate: Delegate) -> Void) {
        self.delegateStore.notifyAll(block)
    }
}
