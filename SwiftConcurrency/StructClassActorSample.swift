//
//  StructClassActorSamplee.swift
//  SwiftConcurrency
//
//  Created by FerVP on 24/04/25.
//

import SwiftUI

struct StructClassActorSample: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                runTest()
            }
    }
}

#Preview {
    StructClassActorSample()
}
struct MyStruct{
    var title: String
}
class MyClass{
    var title: String
    init(title: String) {
        self.title = title
    }
    func updateTitle(_ newTitle: String) {
        self.title = newTitle
    }
}

extension StructClassActorSample {
    private func runTest()  {
        print("Test Started")
        structTest2()
        printDivider()
        classTest2()
        printDivider()
        actorTest1()
        
    }
    private func structTest1() {
        let objA = MyStruct(title: "Starting Title")
        print("ObjectA : ", objA.title)
        
        var objB = objA
        print("ObjectB : ", objB.title)
        
        objB.title = "Second Title"
        print("ObjectB title changed.....")
        
        
        
        print("ObjectA : ", objA.title)
        
        print("ObjectB : ", objB.title)
        
    }
    private func classTest1() {
        let objA = MyClass(title: "Starting Title")
        print("ObjectA : ", objA.title)
        
        let objB = objA
        print("ObjectB : ", objB.title)
        
        objB.title = "Second Title"
        print("ObjectB title changed......")
        
        print("ObjectA : ", objA.title)
        
        print("ObjectB : ", objB.title)
        
        
    }
    private func actorTest1() {
        Task{
            let objA = MyActor(title: "Starting Title")
            await print("ObjectA : ", objA.title)
                   
                   let objB = objA
            await print("ObjectB : ", objB.title)
                   
            await objB.updateTitle( "Second Title")
                   print("ObjectB title changed......")
                   
            await print("ObjectA : ", objA.title)
                   
            await print("ObjectB : ", objB.title)
        }
       
        
        
    }
    func printDivider() {
        print("""

        ------------------------------------

        """)
    }
}

struct CustomStruct {
    let title: String
    
    func updateTitle(_ newTitle: String) -> CustomStruct {
        return .init(title: newTitle)
    }
    

}

struct MutatingStruct {
     var title: String
    
    mutating func updateTitle(_ newTitle: String) {
        self.title = newTitle
    }
}
extension StructClassActorSample {
    private func structTest2() {
        print("structTest2")
        
        var struct1: MyStruct = .init(title: "Title1")
        print("Struct1 : ",struct1.title)
        struct1.title = "Title2"
        print("Struct1 : ",struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2 : ",struct2.title)
        
        struct2=CustomStruct(title: "Title2")
        print("Struct2 : ",struct2.title)
        
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3 : ",struct3.title)

        struct3 = struct3.updateTitle("Title2")
        print("Struct3 : ",struct3.title)
        
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4 : ",struct4.title)
        struct4.title = "Title2"
        
        struct4.updateTitle("Title2")
        print("Struct4 : ",struct4.title)
  
        
    }
    
}

extension StructClassActorSample {
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1 ",class1.title)
        class1.title = "Title2"
        print("Class1 ",class1.title)
        
        
        let class2 = MyClass(title: "Title1")
        print("Class2",class2.title)
        class2.updateTitle("Title2")
        print("Class2",class2.title)
    }
}

actor MyActor{
    var title: String
    init(title: String) {
        self.title = title
    }
    func updateTitle(_ newTitle: String) {
        self.title = newTitle
    }
}
