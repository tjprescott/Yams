//
//  Node.Scalar.swift
//  Yams
//
//  Created by Travis Prescott on 9/8/20.
//  Copyright (c) 2020 Yams. All rights reserved.
//

// MARK: Node+Unresolved

extension Node {
    /// Scalar node.
    public struct Unresolved {
        /// This node's string value.
        public var string: String {
            didSet {
                tag = .implicit
            }
        }
        /// This node's tag (its type).
        public var tag: Tag
        /// The style to be used when emitting this node.
        public var style: Style
        /// The location for this node.
        public var mark: Mark?
        /// The YAMLError to throw if the alias cannot be resolved.
        public var error: YamlError

        /// The style to use when emitting an `Unresolved`.
        public enum Style: UInt32 {
            /// Let the emitter choose the style.
            case any = 0
        }

        /// Create a `Node.Unresolved` using the specified parameters.
        ///
        /// - parameter alias: The unresolved alias.
        /// - parameter alias: The error to be thrown if the alias remains unresolved.
        /// - parameter tag:    This scalar's `Tag`.
        /// - parameter style:  The style to use when emitting this `Scalar`.
        /// - parameter mark:   This scalar's `Mark`.
        public init(alias: String, error: YamlError, _ tag: Tag = .implicit, _ style: Style = .any,
                    _ mark: Mark? = nil) {
            self.string = alias
            self.error = error
            self.tag = tag
            self.style = style
            self.mark = mark
        }
    }

    /// Get or set the `Node.Unresolved` value if this node is a `Node.undefined`.
    public var unresolved: Unresolved? {
        get {
            if case let .unresolved(unresolved) = self {
                return unresolved
            }
            return nil
        }
        set {
            if let newValue = newValue {
                self = .unresolved(newValue)
            }
        }
    }
}

extension Node.Unresolved: Comparable {
    /// :nodoc:
    public static func < (lhs: Node.Unresolved, rhs: Node.Unresolved) -> Bool {
        return lhs.string < rhs.string
    }
}

extension Node.Unresolved: Equatable {
    /// :nodoc:
    public static func == (lhs: Node.Unresolved, rhs: Node.Unresolved) -> Bool {
        return lhs.string == rhs.string && lhs.resolvedTag == rhs.resolvedTag
    }
}

extension Node.Unresolved: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        hasher.combine(string)
        hasher.combine(resolvedTag)
    }
}

extension Node.Unresolved: TagResolvable {
    static let defaultTagName = Tag.Name.str
    func resolveTag(using resolver: Resolver) -> Tag.Name {
        return tag.name == .implicit ? resolver.resolveTag(from: string) : tag.name
    }
}
