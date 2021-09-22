//
//  ViewController.swift
//  ProjectY
//
//  Created by Ruslan Dalgatov on 15.09.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    
    var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    let addTimerTime = UITextField()
    let addNameTimer = UITextField()
   
    let buttonAdd = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let buttunDeleteAll = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    var taskList: [Task] = []
    var timer: Timer?
    var seconds = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Мульти Таймер"
        
        self.view.addSubview(self.tableView)
        self.tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: "TimerTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.updateLayout(with: self.view.frame.size)
        
        
        
        
        let header = UIView(frame: CGRect(x: 0, y: 500, width: self.view.frame.width, height: 350))
        header.backgroundColor = .white
        tableView.tableHeaderView = header
       

        
        let labelAddTimer = UILabel(frame: header.bounds)
        labelAddTimer.text = "Добавление таймеров"
        header.addSubview(labelAddTimer)
        labelAddTimer.snp.makeConstraints { maker in
            maker.top.equalTo(header).inset(30)
            maker.left.equalTo(header).inset(20)
        }
        
        
        addNameTimer.backgroundColor = UIColor(displayP3Red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        addNameTimer.placeholder = "Название таймера"
        addNameTimer.clearButtonMode = .whileEditing
        addNameTimer.layer.borderWidth = 1.0
        addNameTimer.layer.borderColor = UIColor(displayP3Red: 242/255, green: 242/255, blue: 242/255, alpha: 1).cgColor
        addNameTimer.layer.cornerRadius = 5
        header.addSubview(addNameTimer)
        addNameTimer.snp.makeConstraints{maker in
            maker.top.equalTo(labelAddTimer).inset(50)
            maker.width.equalTo(250)
            maker.height.equalTo(30)
            maker.left.equalTo(header).inset(30)
        }
        

        addTimerTime.placeholder = "Время в секундах"
        addTimerTime.backgroundColor = UIColor(displayP3Red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        addTimerTime.layer.borderWidth = 1.0
        addTimerTime.layer.borderColor = UIColor(displayP3Red: 242/255, green: 242/255, blue: 242/255, alpha: 1).cgColor
        addTimerTime.layer.cornerRadius = 5
        addTimerTime.clearButtonMode = .whileEditing
        header.addSubview(addTimerTime)
        addTimerTime.snp.makeConstraints{maker in
            maker.top.equalTo(addNameTimer).inset(50)
            maker.width.equalTo(250)
            maker.height.equalTo(30)
            maker.left.equalTo(header).inset(30)
        }
        let buttonColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        buttonAdd.setTitle("Добавить", for: .normal)
        buttonAdd.setTitleColor(buttonColor, for: .normal)
        buttonAdd.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonAdd.backgroundColor = UIColor(displayP3Red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        buttonAdd.layer.cornerRadius = 10
        header.addSubview(buttonAdd)
        buttonAdd.snp.makeConstraints {maker in
            maker.width.equalTo(header).inset(30)
            maker.height.equalTo(60)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(header).inset(50)
            
        }
        
        createTimer()
        buttonAdd.addTarget(self, action: #selector(addTimerAction), for: .touchUpInside)

        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
        }

    private func updateLayout(with size: CGSize){
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
        
    }

    

    
    
    // MARK: - UITableViewDelegate
    extension ViewController: UITableViewDelegate {
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TimerTableViewCell else {
          return
        }
        
        cell.updateState()
        
        
        
      }
    }

    // MARK: - UITableViewDataSource
    extension ViewController: UITableViewDataSource {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimerTableViewCell", for: indexPath)
        
        if let cell = cell as? TimerTableViewCell {
          cell.task = taskList[indexPath.row]
        }
        
        return cell
      }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                taskList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

// MARK: - Actions
extension ViewController {
  @objc func addTimerAction() {
    let textInName = addNameTimer.text
    if let _ = Int(addTimerTime.text!), !(textInName?.isEmpty ?? true){
       
       
        let text = self.addNameTimer.text ?? ""
        var time = Int (self.addTimerTime.text ?? "") ?? 0
        time = time + 1
      DispatchQueue.main.async {
        let task = Task(name: text, time: time)
        
        self.taskList.append(task)
        
        let indexPath = IndexPath(row: self.taskList.count - 1, section: 0)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .top)
        self.tableView.endUpdates()
      }
    
    addTimerTime.text = nil
    addNameTimer.text = nil
    } else {
        
        let alert = UIAlertController(title: "Неверный формат", message: "Пожалуйста введите название и время для таймера корректно", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    }
  }


// MARK: - Timer
extension ViewController {
  func createTimer() {
    if timer == nil {
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        

      RunLoop.current.add(timer, forMode: .common)
      timer.tolerance = 0
      
      self.timer = timer
    }
  }
  
  @objc func updateTimer() {
    var position = 0
        taskList.forEach { Task in
            let indexPath = IndexPath(row: position, section: 0)
            Task.time = Task.time - 1
            if Task.time == 0 || Task.time < 0 {
                taskList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            
                
           
                
                
            }
            
            
            position += 1
        }
    taskList.sort(by: { $0.time < $1.time })

    tableView.reloadData()
  }
}
    
