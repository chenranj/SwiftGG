import Foundation

@MainActor
class SwiftGuideViewModel: ObservableObject {
    @Published private(set) var chapters: [Chapter] = []
    @Published private(set) var isLoading = false
    
    struct Chapter: Identifiable {
        let id = UUID()
        let title: String
        let sections: [Section]
        
        struct Section: Identifiable {
            let id = UUID()
            let title: String
            let url: String
        }
    }
    
    func loadChapters() {
        let baseURL = "https://doc.swiftgg.team/documentation/the-swift-programming-language-----"
        
        chapters = [
            Chapter(title: "欢迎使用 Swift", sections: [
                .init(title: "关于 Swift", url: "\(baseURL)/aboutswift"),
                .init(title: "版本兼容性", url: "\(baseURL)/compatibility")
            ]),
            Chapter(title: "语言教程", sections: [
                .init(title: "基础部分", url: "\(baseURL)/thebasics"),
                .init(title: "基本运算符", url: "\(baseURL)/basicoperators"),
                .init(title: "字符串和字符", url: "\(baseURL)/stringsandcharacters"),
                .init(title: "集合类型", url: "\(baseURL)/collectiontypes"),
                .init(title: "控制流", url: "\(baseURL)/controlflow"),
                .init(title: "函数", url: "\(baseURL)/functions"),
                .init(title: "闭包", url: "\(baseURL)/closures"),
                .init(title: "枚举", url: "\(baseURL)/enumerations"),
                .init(title: "结构体和类", url: "\(baseURL)/classesandstructures"),
                .init(title: "属性", url: "\(baseURL)/properties"),
                .init(title: "方法", url: "\(baseURL)/methods"),
                .init(title: "下标", url: "\(baseURL)/subscripts"),
                .init(title: "继承", url: "\(baseURL)/inheritance"),
                .init(title: "构造过程", url: "\(baseURL)/initialization"),
                .init(title: "析构过程", url: "\(baseURL)/deinitialization"),
                .init(title: "可选链", url: "\(baseURL)/optionalchaining"),
                .init(title: "错误处理", url: "\(baseURL)/errorhandling"),
                .init(title: "并发", url: "\(baseURL)/concurrency"),
                .init(title: "类型转换", url: "\(baseURL)/typecasting"),
                .init(title: "嵌套类型", url: "\(baseURL)/nestedtypes"),
                .init(title: "扩展", url: "\(baseURL)/extensions"),
                .init(title: "协议", url: "\(baseURL)/protocols"),
                .init(title: "泛型", url: "\(baseURL)/generics"),
                .init(title: "不透明类型", url: "\(baseURL)/opaquetypes"),
                .init(title: "自动引用计数", url: "\(baseURL)/automaticreferencecounting"),
                .init(title: "内存安全", url: "\(baseURL)/memorysafety"),
                .init(title: "访问控制", url: "\(baseURL)/accesscontrol"),
                .init(title: "高级运算符", url: "\(baseURL)/advancedoperators")
            ]),
            Chapter(title: "语言参考", sections: [
                .init(title: "关于语言参考", url: "\(baseURL)/aboutthelanguagereference"),
                .init(title: "词法结构", url: "\(baseURL)/lexicalstructure"),
                .init(title: "类型", url: "\(baseURL)/types"),
                .init(title: "表达式", url: "\(baseURL)/expressions"),
                .init(title: "声明", url: "\(baseURL)/declarations"),
                .init(title: "特性", url: "\(baseURL)/attributes"),
                .init(title: "模式", url: "\(baseURL)/patterns"),
                .init(title: "语法总结", url: "\(baseURL)/summaryofthegrammar")
            ])
        ]
    }
} 
