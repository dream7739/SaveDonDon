

import Foundation
import UIKit
import FSCalendar

class MoneyBookController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    /* 해당 뷰 누르고 컨트롤러로 delegate랑 datasource연결 해준 다음 컨트롤러에 implement한다.
     has no initializer: 초기화 되지 않은 변수가 있을 경우에 오류 발생할 수 있음. */
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var table: UITableView!
   
    var income: [Income]!
    var spend: [Spend]!

    
    var todayIncomeArray: [Income] = []
    var todaySpendArray: [Spend] = []
    let date = NSDate()
    let formatter = DateFormatter()
    var selectedDate = ""
    var todayDate:String! //오늘날짜는 캘린더에서 받아와서 무조건 있음
    

    override func viewWillAppear(_ animated: Bool) {
        newDiff() //데이터 세팅
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scrollDirection = .vertical
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //가계부 메인으로 돌아오는 세그
    @IBAction func unwindMoneyBookSegue(segue:UIStoryboardSegue){
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    
    /** 캘린더에서 선택한 날짜 받아오기 */
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = formatter.string(from: date as Date)
        table.reloadData()
    }
    
    
    /**셀에 대한 작업**/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MoneyBookCell = tableView.dequeueReusableCell(withIdentifier: "MoneyBookCell", for: indexPath) as! MoneyBookCell
        var totalIncome:Int = 0
        var totalSpend:Int =  0
        
        //3자리씩 끊어서 콤마
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        
        //테이블 표시 날짜 = 캘린더 날짜
        formatter.dateFormat = "yyyy.MM.dd"
        todayDate = selectedDate
        if todayDate == ""{
            todayDate = formatter.string(from: date as Date)
        }
        
        
        //테이블 오늘의 수입(7/26로 선택해야 나옴, 쓰레기 데이터가 7/26)
        todayIncomeArray = income.filter{ $0.date == todayDate }
        todaySpendArray = spend.filter { $0.date == todayDate }
        
        
        
        if(todayIncomeArray.count == 0){
            totalIncome = 0
        } else{
            for incomeArray in todayIncomeArray {
                totalIncome += incomeArray.price
            }
        }
        
        if(todaySpendArray.count == 0){
            totalSpend = 0
        } else{
            for totalArray in todaySpendArray {
                totalSpend += totalArray.price
            }
        }
        
        
        let todayIncomeText = numberFormatter.string(from: NSNumber(value: totalIncome))! + " 원"
        let todaySpendText = numberFormatter.string(from: NSNumber(value: totalSpend))! + " 원"
        
        
        cell.todaysDate!.text = todayDate
        cell.totalIncome.text = todayIncomeText
        cell.totalSpend!.text = todaySpendText
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue"{
            let moneyAddVC = segue.destination as! MoneyBookAddController //목적지는 버킷리스트 세팅창
            moneyAddVC.selectedDate = self.todayDate
        }
        
        if segue.identifier == "CheckSegue"{
            let moneyCheckVC = segue.destination as! MoneyBookCheckController
            moneyCheckVC.selectedDate = self.todayDate
            moneyCheckVC.todayIncomeArray = self.todayIncomeArray
            moneyCheckVC.todaySpendArray = self.todaySpendArray
            
        }
        
    }
    
    /**정보 추가, 제거 시 호출해서 업데이트**/
    func newDiff(){
        self.income = moneyPocket.income
        self.spend = moneyPocket.spend
        table.reloadData()
    }
    
    
    
    
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
}
