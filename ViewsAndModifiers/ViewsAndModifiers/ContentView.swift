//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Chris Boette on 9/19/23.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    @State private var useThick = false
    @State private var selection = 0
    
    @State var agreedToTerms = false
    @State var agreedToPrivacyPolicy = false
    @State var agreedToEmails = false
    
    let pdfUrl = Bundle.main.url(forResource: "mud", withExtension: "pdf")
    
    var body: some View {
        let binding = Binding(
            get: { selection },
            set: { selection = $0 }
        )
        
        let agreedToAll = Binding(
            get: {
                agreedToTerms && agreedToEmails && agreedToPrivacyPolicy
            },
            set: {
                agreedToTerms = $0
                agreedToPrivacyPolicy = $0
                agreedToEmails = $0
            }
        )
        
        return VStack {
            Picker("Select a number", selection: binding) {
                ForEach(0..<5) {
                    Text("Item \($0)")
                }
            }
            .pickerStyle(.segmented)
            
            VStack {
                Toggle("Terms, yes or no?", isOn: $agreedToTerms)
                Toggle("Privacy policy, yes or no?", isOn: $agreedToPrivacyPolicy)
                Toggle("Emails, yes or no?", isOn: $agreedToEmails)
                Toggle("All, yes or no?", isOn: agreedToAll)
            }
            .padding()

            Button("Hi, again", systemImage: "arrow.up") {
                useThick.toggle()
                print(type(of: self.body))
            }
            .frame(width: 100, height: 100)
            .background(.black)
            .padding()
            .background(.purple)
            .padding()
            .background(useThick ? .thickMaterial : .thinMaterial)
            
            Color.blue
                .frame(width: 300, height: 100)
                .watermarked(with: "beep boop")
            
            
            GridStack(rows: 2, cols: 3) { row, col in
                Text("R\(row) C\(col)")
            }
        }
    }
}

struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .centerFirstTextBaseline) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
                .shadow(radius: 10)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let cols: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<cols, id: \.self) { col in
                        content(row, col)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .background(.red)
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                }
            }
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    func updateUIView(_ uiView: PDFView, context: Context) {
        print("updated")
    }
    
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }
}

#Preview {
    ContentView()
}
