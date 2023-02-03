//
//  Home.swift
//  WalletAppRemix
//
//  Created by Алексей Зарицький on 18.10.2022.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties...
    @State var expandCard: Bool = false
    
    //MARK: Detail View Properties...
    @State var currentCard: Card?
    @State var showDetailCard: Bool = false
    @Namespace var animation
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.purple]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea(.all)
            .overlay (
                VStack(spacing: 0) {
            
            // MARK: Text with logo
            
            
                
//                 Image(systemName: "applelogo")
//                   .resizable()
//                   .aspectRatio(contentMode: .fit)
//                  .foregroundColor(.white)
//                 .frame(height: 35)
//                .padding(.bottom,5)
                
                Text("Wallet")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,alignment: expandCard ? .leading : .center)
                    .overlay(alignment: .trailing) {
                        
                        // MARK: Close Button
                        Button {
                             // Closing Cards...
                            withAnimation(
                                .interactiveSpring(response: 0.8,
                                dampingFraction: 0.7,
                                blendDuration: 0.7)){
                                            expandCard = false
                                }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.black,in: Circle())
                        }
                        .rotationEffect(.init(degrees: expandCard ? 45 : 0))
                        .offset(x: expandCard ? 10 : 15)
                        .opacity(expandCard ? 1 : 0)
                    }
                    .padding(.horizontal,15)
                    .padding(.bottom,10)
            
            
              // MARK: End  section with text nad logo
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 0){
                    
                    // MARK: Cards...
                    ForEach(cards){card in
                        CardView(card: card)
                            .onTapGesture {
                                withAnimation (
                                    .easeInOut(duration: 0.35)) {
                                     currentCard = card
                                        showDetailCard = true
                                    }
                            }
                    }
                }
                .overlay{
                // Avoid Scrolling...
                    Rectangle()
                        .fill(.black.opacity(expandCard ? 0 : 0.01))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)){
                                expandCard = true
                            }
                        }
                }
                .padding(.top,expandCard ? 30 : 0)
            }
            .coordinateSpace(name: "SCROLL")
            .offset(y: expandCard ? 0 : 30)
                    
                    //MARK: Add Button
                    
                    Button {
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.black,in: Circle())
                    }
                    .rotationEffect(.init(degrees: expandCard ? 180 : 0))
                    // To Avoid Warning 0.01
                    .scaleEffect(expandCard ? 0.01 : 1 )
                    .opacity(!expandCard ? 1 : 0)
                    .frame(height: expandCard ? 0 : nil)
                    .padding(.bottom,expandCard ? 0 : 30)
        }
        .padding([.horizontal,.top])
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .overlay {
            if let currentCard = currentCard,showDetailCard {
                DetailView(currentCard: currentCard, showDetailCard: $showDetailCard)
             }
           }
        )
    }
        
    
    // MARK: Card View...
    @ViewBuilder
    func CardView(card: Card)->some View{
        GeometryReader{proxy in
            
            let rect = proxy.frame(in: .named("SCROLL"))
            let offset = CGFloat(getIndex(Card: card) * (expandCard ? 10 : 70))
         
            
             // MARK: adding some space between cards,change frame,change cards...And add (cordinateSpace)
            ZStack(alignment: .bottomLeading) {
                
                Image(card.cardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 330,height: 200)
                    .padding()
                
                // Card Dertails
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(card.name)
                        .fontWeight(.bold)
                    
                    Text(customiseCardNumber(number: card.cardNumber))
                        .font(.callout)
                        .fontWeight(.bold)
                }
                .padding(.leading,40)
                .padding(.bottom,45)
                .foregroundColor(.white)
            }
            // MARK: Masking it as a Stack...
            .offset(y: expandCard ? offset : -rect.minY + offset)
        }
        //Max Size...
        .frame(height: 200)
    }
    
        // Retreiving Index...
    func getIndex(Card: Card)->Int{
        return cards.firstIndex { currentCard in
            return currentCard.id == Card.id
        } ?? 0
    }
}
// MARK: Hiding all number except last four
// Global
func customiseCardNumber(number: String)->String{
    
    var newValue: String = ""
    let maxCount = number.count - 4
    
    number.enumerated().forEach { value in
        if value.offset >= maxCount{
            // Displaying text
            let string = String(value.element)
                newValue.append(contentsOf: string)
        }
        else{
            // Simply Displaying  Star
            //Avoid Space
            let string = String(value.element)
            if string == " " {
                newValue.append(contentsOf: " ")
            }
            else {
                newValue.append(contentsOf: "*")
            }
        }
    }
    
    return newValue
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Detail View
struct DetailView: View{
    var currentCard: Card
    @Binding var showDetailCard: Bool
    // MAtched Geometry Effect...
    //var animation: Namespace.ID
    var body: some View {
        
        VStack {
            CardView()
               // .matchedGeometryEffect(id: currentCard.id, in: animation)
                .frame(height: 200)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
    }
    
    @ViewBuilder
    func CardView()->some View{
        ZStack(alignment: .bottomLeading) {
            
            Image(currentCard.cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 330,height: 200)
                .padding()
            
            // Card Dertails
            VStack(alignment: .leading, spacing: 10) {
                
                Text(currentCard.name)
                    .fontWeight(.bold)
                
                Text(customiseCardNumber(number:
                    currentCard.cardNumber))
                    .font(.callout)
                    .fontWeight(.bold)
            }
            .padding(.leading,40)
            .padding(.bottom,45)
            .foregroundColor(.white)
        }
    }
}
