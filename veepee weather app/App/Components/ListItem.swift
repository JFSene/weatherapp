//
//  ListItem.swift
//  veepee weather app
//
//  Created by Joel Sene on 23/06/2024.
//

import SwiftUI

struct ListItem: View {
    @State var forecastItem: HomeModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(isToday(forecastItem.fullDate) ? "Today  " : forecastItem.date)
                        .foregroundStyle(.black)
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(forecastItem.weatherDescription.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .fontWeight(.medium)
                }
                .frame(width: geometry.size.width/3)
                
                Spacer()
                
                VStack(alignment: .center) {
                    AsyncImage(url: URL(string: forecastItem.iconURL)) { image in
                        image.resizable()
                        image.scaledToFit()
                    } placeholder: {
                        Color.cyan.opacity(0.6)
                    }
                    .frame(width: 75, height: 75)
                    .clipShape(.rect(cornerRadius: 8))
                    .frame(alignment: .center)
                }
                .frame(width: geometry.size.width/3)
                VStack(alignment: .trailing) {
                    Text(String(format: "%.0f°C", forecastItem.temp))
                        .padding(.init(
                            top: 0,
                            leading: 16,
                            bottom: 8,
                            trailing: 0
                        ))
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    HStack {
                        Text(String(format: "%.0f°C", forecastItem.minTemp))
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(.trailing, 8)
                        Text(String(format: "%.0f°C", forecastItem.maxTemp))
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                .frame(width: geometry.size.width/3)
            }
        }
    }
    
    private func isToday(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date string format")
            return false
        }
        
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
}
