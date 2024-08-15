//
//  SolveTransformerSetup.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/19/24.
//

import Foundation

public class SJParentValueTransformer<T: NSCoding & NSObject>: ValueTransformer {
     public override class func transformedValueClass() ->
            AnyClass{T.self }
     public override class func allowsReverseTransformation() ->
            Bool { true }
     public override func transformedValue(_ value: Any?) -> Any? {
         guard let value = value as? T else { return nil }
         return try?
             NSKeyedArchiver.archivedData(withRootObject: value,
             requiringSecureCoding: true)
     }
    public override func reverseTransformedValue(_ value: Any?) ->
    Any? {
         guard let data = value as? NSData else { return nil }
         let result = try? NSKeyedUnarchiver.unarchivedObject(
             ofClass: T.self,
             from: data as Data
         )
         return result
    }
       /// The name of this transformer. This is the name used to register the transformer using `ValueTransformer.setValueTransformer(_:forName:)`
    public static var transformerName: NSValueTransformerName {
        let className = "\(T.self.classForCoder())"
        return NSValueTransformerName("\(className)Transformer")
        // we append the Transformer due easily identify. Example. Clase name UserSetting then the name of the transformer is UserSettingTransformer
    }
          
          /// Registers the transformer by calling `ValueTransformer.setValueTransformer(_:forName:)`.
     public static func registerTransformer() {
        let transformer = SJParentValueTransformer<T>()
        ValueTransformer.setValueTransformer(transformer, forName:
        transformerName)
     }
}
