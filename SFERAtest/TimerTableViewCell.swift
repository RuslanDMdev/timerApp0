//
//  TimerTableViewCell.swift
//  SFERAtest
//
//  Created by Ruslan Dalgatov on 15.09.2021.
//

import UIKit
import SnapKit

class TimerTableViewCell: UITableViewCell {
    
    private var timer: Timer?
    
    let courseName = UILabel()
    let secondName = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(courseName)
        contentView.addSubview(secondName)
        secondName.textColor = .gray

        courseName.snp.makeConstraints {maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(20)
        }
        
        secondName.snp.makeConstraints {maker in
            maker.centerY.equalToSuperview()
            maker.right.equalTo(-20)
        }
        
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer22), userInfo: nil, repeats: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var task: Task? {
      didSet {
        courseName.text = task?.name
        updateTime()
      }
    }
    
    func updateState() {
      guard let task = task else {
        return
      }
      
      task.completed.toggle()
      updateTime()
    }
    
    func updateTime() {
      guard let task = task else {
        return
      }
      
      if task.completed {
        secondName.text = "Пауза"
        let time = task.time
        task.time = time + 1
        timer?.invalidate()
        
      } else {


        
            let time3 = secondsToMinutesAndSeconds(seconds: task.time)
                    let timeString = makeTimeString(minutes: time3.0, seconds: time3.1)
                    secondName.text = timeString
            
        
      }
    }
    

    
     func secondsToMinutesAndSeconds(seconds: Int) -> (Int, Int) {
         return ((seconds % 3600) / 60, ((seconds % 3600) % 60 ))
     }

     func makeTimeString(minutes: Int, seconds: Int) -> String {
        
         var timeString = ""
         timeString += String(format: "%02d", minutes)
         timeString += " : "
         timeString += String(format: "%02d", seconds)

         return timeString

     }
}
