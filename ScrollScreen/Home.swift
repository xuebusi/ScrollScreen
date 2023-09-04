//
//  Home.swift
//  ScrollScreen
//
//  Created by shiyanjun on 2023/9/3.
//

import SwiftUI

struct RecInfo: Identifiable, Hashable {
    var id = UUID().uuidString
    var color: Color
}

struct Home: View {
    @State var currentIndex: Int = 0
    
    let recInfos: [RecInfo] = [
        RecInfo(color: .red),
        RecInfo(color: .orange),
        RecInfo(color: .yellow),
        RecInfo(color: .green),
        RecInfo(color: .cyan),
        RecInfo(color: .blue),
        RecInfo(color: .purple),
    ]
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { scroll in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(recInfos) { rec in
                            rec.color
                                .frame(width: UIScreen.main.bounds.width)
                                .frame(height: geo.size.height)
                                .id(rec.id)
                                .overlay {
                                    Text(rec.color.description.uppercased())
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(10)
                                }
                        }
                        .onAppear {
                            scroll.scrollTo(recInfos.first?.id, anchor: .bottom)
                        }
                    }
                }
                .overlay(
                    VStack(spacing: 40) {
                        // top
                        ScrollButton(action: {
                            withAnimation {
                                self.currentIndex = 0
                                scroll.scrollTo(recInfos[self.currentIndex].id)
                            }
                        }, imageName: "arrow.up.to.line.circle")
                        
                        // prev
                        ScrollButton(action: {
                            withAnimation {
                                if self.currentIndex != 0 {
                                    self.currentIndex -= 1
                                }
                                scroll.scrollTo(recInfos[self.currentIndex].id)
                            }
                        }, imageName: "arrow.up.circle")
                        
                        // next
                        ScrollButton(action: {
                            withAnimation {
                                if self.currentIndex != recInfos.count - 1 {
                                    self.currentIndex += 1
                                }
                                scroll.scrollTo(recInfos[self.currentIndex].id)
                            }
                        }, imageName: "arrow.down.circle")
                        
                        // bottom
                        ScrollButton(action: {
                            withAnimation {
                                self.currentIndex = recInfos.count - 1
                                scroll.scrollTo(recInfos[self.currentIndex].id)
                            }
                        }, imageName: "arrow.down.to.line.circle")
                    }
                        .padding(.trailing, 20)
                    , alignment: .trailing
                )
                .overlay(
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(recInfos.indices, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(recInfos[index].color)
                                .frame(width: 50, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.white, lineWidth: 5)
                                )
                                .scaleEffect(index == self.currentIndex ? 1.2 : 1)
                                .onTapGesture {
                                    withAnimation {
                                        self.currentIndex = index
                                        scroll.scrollTo(recInfos[index].id, anchor: .bottom)
                                    }
                                }
                        }
                    }
                        .padding()
                    , alignment: .leading
                )
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct ScrollButton: View {
    let action: () -> ()
    let imageName: String
    
    var body: some View {
        // bottom
        Button {
            action()
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(.white)
                .background(.black.opacity(0.5))
                .clipShape(Circle())
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
