//
//  Home.swift
//  UI-676
//
//  Created by nyannyan0328 on 2022/09/22.
//

import SwiftUI

struct Home: View {
    @State var dragOffset : CGSize = .zero
    @State var startAnimation : Bool = false
    @State var currentBall : String = "Single"
    var body: some View {
        VStack{
            
            Text("MetaBallAnimation")
                .font(.title2.weight(.semibold))
                  .frame(maxWidth: .infinity,alignment: .leading)
            
            Picker(selection: $currentBall) {
                
                Text("Metal")
                    .tag("Single")
                
                Text("Clubbed")
                    .tag("Random")
                
            } label: {
                
                
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if currentBall == "Single"{
                
                SingleMetaBall()
                
            }
            else{
                BulbleView()
                
                
                
            }

         
        }
    }
    @ViewBuilder
    func BulbleView ()->some View{
        
        Rectangle()
            .fill(.linearGradient(colors: [Color("Gradient1"),Color("Gradient2")], startPoint: .top, endPoint: .bottom))
            .mask {
                
            
                TimelineView(.animation(minimumInterval:3.5,paused: false)){_ in
                    Canvas { context, size in
                        
                        context.addFilter(.alphaThreshold(min: 0.3,color: .white))
                        context.addFilter(.blur(radius: 10))
                        context.drawLayer { txt in
                            
                            
                            for index in 1...20{
                                
                                if let resolovedImage = context.resolveSymbol(id: index){
                                    
                                    txt.draw(resolovedImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                    
                                }
                                
                            }
                        }
                        
                    } symbols: {
                        
                        ForEach(1...15 ,id:\.self){index in
                            let offset = (startAnimation ? CGSize(width: .random(in: -180...180), height:.random(in: -240...240)) : .zero)
                        
                            ClubbedView(offset: offset)
                        }
                    }

                    
                }
                
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
                startAnimation = true
            }
        
        
        
    }
    @ViewBuilder
    func ClubbedView (offset : CGSize)->some View{
        
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white)
         .frame(width: 150,height: 150)
         .offset(offset)
         .animation(.easeIn(duration: 5), value: offset)
        
    }
    @ViewBuilder
    func SingleMetaBall ()->some View{
        
        Rectangle()
            .fill(.linearGradient(colors: [Color("Gradient1"),Color("Gradient2")], startPoint: .top, endPoint: .bottom))
            .mask {
                
                Canvas { context, size in
                    
                    context.addFilter(.alphaThreshold(min: 0.2,color: .white))
                    context.addFilter(.blur(radius: 20))
                    
                    context.drawLayer { cxt in
                        for index in [1,2]{
                            
                            if let resolvedImage = context.resolveSymbol(id: index){
                                
                                cxt.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                
                            }
                            
                        }
                    }
                    
                 
                } symbols: {
                    
                    BallView()
                        .tag(1)
                    
                    BallView(offset: dragOffset)
                        .tag(2)
                    
                    
                    
                }
               

            }
            .gesture(
            
                DragGesture().onChanged({ value in
                    dragOffset = value.translation
                })
                .onEnded({ value in
                    
                    withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7)){
                        dragOffset = .zero
                    }
                })
                
            )
        
    }
    @ViewBuilder
    func BallView(offset : CGSize = .zero)->some View{
     
        Circle()
         .fill(.white)
         .frame(width: 150,height: 150)
         .offset(offset)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
