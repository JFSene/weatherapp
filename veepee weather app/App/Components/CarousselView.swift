import SwiftUI

struct CarouselView: View {
    @State var hourlyForecasts: [ForecastList]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) { // Add spacing between items
                ForEach(hourlyForecasts, id: \.self) { item in
                    VStack {
                        Text("\(item.formattedDate(format: .hour))H")
                            .padding(.bottom, 16)
                            .padding(.top, 8)
                        Text("\(String(format: "%.0f", item.main.temp))°C")
                            .padding(.bottom, 8)
                    }
                    .frame(width: 60, height: 80)
                    .background(Color.cyan.opacity(0.1))
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4) // Add shadow to each item
                }
            }
        }
    }
}
