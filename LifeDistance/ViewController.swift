//
//  ViewController.swift
//  LifeDistance
//
//  Created by Marino Schmid on 08.11.20.
//

import UIKit
import HealthKit
import SpriteKit;
var healthStore = HKHealthStore();
import Hero

class LifeGoal: CustomStringConvertible {
    internal init(walkingDistance: Double?, altitude: Double?, name: String, desc: String) {
        self.walkingDistance = walkingDistance
        self.altitude = altitude
        self.name = name
        self.desc = desc
    }
    var description: String {
        return "altitude: \(altitude ?? 0) / walking: \(walkingDistance ?? 0)"
    }
    
    var walkingDistance : Double?;
    var altitude : Double?;
    var name : String;
    var desc : String;
}
class LifeGoals {
    var goals : [LifeGoal] = [];
    init() {
        goals.append(LifeGoal(walkingDistance: 42195, altitude: nil, name: "Marathon", desc: "Du bist schon einen Marathon gelaufen"))
        goals.append(LifeGoal(walkingDistance: 220100, altitude: nil, name: "Schweiz", desc: "Du hast die Schweiz von Norden nach Süden durchquert"))
        goals.append(LifeGoal(walkingDistance: 6000000, altitude: nil, name: "Sahara", desc: "Du hast die Sahara von Norden nach Süden durchquert"))

        goals.append(LifeGoal(walkingDistance: nil, altitude: 4810, name: "Mont Blanc", desc: "Du hast die Höhendifferenz zum Mont Blanc in Italien/Frankreich erreicht!"))

        goals.append(LifeGoal(walkingDistance: 5000, altitude: nil, name: "Baby-Steps", desc: "Du hast eine kleine Stadt durchquert"))
        
        goals.append(LifeGoal(walkingDistance: 40000000, altitude: nil, name: "Weltreise!", desc: "Du bist einmal um die Erde entlang des Equators gegangen"))

        goals.append(LifeGoal(walkingDistance: 10921000, altitude: nil, name: "Mondreise!", desc: "Du bist einmal um den Mond entlang dessen Equator gegangen"))

        goals.append(LifeGoal(walkingDistance: nil, altitude: 8848, name: "Mount Everest", desc: "Du hast die Höhendifferenz zum Mount Everest erreicht!"))

        goals.append(LifeGoal(walkingDistance: nil, altitude: 828, name: "Burj Khalifa", desc: "Du hast die Höhendifferenz zum Burj Khalifa in Dubai erreicht!"))

        goals.append(LifeGoal(walkingDistance: nil, altitude: 4478, name: "Matterhorn", desc: "Du hast die Höhendifferenz zum Matterhorn in der Schweiz erreicht!"))

        goals.append(LifeGoal(walkingDistance: nil, altitude: 300, name: "Eiffelturm", desc: "Du hast die Höhendifferenz zum Eiffelturm in Paris erreicht!"))
        
        goals.sort { (a, b) -> Bool in
            if(a.walkingDistance != nil && b.walkingDistance == nil) {
                return true;
            }
            if(a.walkingDistance == nil && b.walkingDistance != nil) {
                return false;
            }
            if(a.walkingDistance != nil && b.walkingDistance != nil) {
                if(a.walkingDistance! > b.walkingDistance!) {
                    return false;
                } else {
                    return true;
                }
            }
            if(a.walkingDistance == nil && b.walkingDistance == nil) {
                if(a.altitude! < b.altitude!) {
                    return false;
                } else {
                    return true;
                }
            }
            return false;
        }
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count;
    }
    
    var goals : [LifeGoal] = [];

    func circleObstacle(radius : Double, percent: Double) -> SKShapeNode {
      // 1
      let path = UIBezierPath()
      // 2

      path.addArc(withCenter: CGPoint.zero,
                  radius: CGFloat(radius),
                  startAngle: 0,
                  endAngle: CGFloat(Double.pi*2*percent),
                  clockwise: true)
  
        return SKShapeNode(path: path.cgPath);
    }
    
    func sceneFor(row : Int) -> SKScene {
        let scene = SKScene(size: CGSize(width: 200, height: 200))
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        var i = row+1;
        if(i%2 == 0) {
            i = goals.count - i/2;
        } else {
            i = Int(i/2)
        }
        print(goals.count);
        let goal = goals[i];
        var percent : Double = 0.0;
        if let altitude = goal.altitude {
            var alt = defaults.double(forKey: "altitude");
            percent = alt/altitude
        }
        if let walkingDistance = goal.walkingDistance {
            var wd = defaults.double(forKey: "walkingDistance");
            percent = wd/walkingDistance
        }
        let circle = circleObstacle(radius: 85, percent: percent > 1 ? 1 : percent)
        circle.strokeColor = .blue;
        circle.lineWidth = 15;
        if(percent >= 1) {
            circle.fillColor = UIColor.init(red: 100, green: 80, blue: 200, alpha: 0.9)
        }
        scene.addChild(circle);
        return scene
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKCollectionViewCell", for: indexPath) as! SKCollectionViewCell;
        var i = indexPath.row+1;
        if(i%2 == 0) {
            i = goals.count - i/2;
        } else {
            i = Int(i/2)
        }
        let goal = goals[i];
        cell.width.constant = self.view.frame.width/2-20;
        cell.height.constant = self.view.frame.width/2-20;
        if(indexPath.row == 0) {
          //  cell.width.constant = self.view.frame.width*0.9;
         //   cell.height.constant = self.view.frame.width*0.9;
        }
        let scene = sceneFor(row: indexPath.row)
        cell.skview.presentScene(scene)
        cell.skview.hero.id = "transition\(indexPath.row)";
        cell.textLabel.text = goal.name;
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        let vc = self.storyboard?.instantiateViewController(identifier: "vc2") as! ViewControllerDetail
        vc.id = indexPath.row
        vc.scene = sceneFor(row: indexPath.row)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var defaults = UserDefaults.standard;
    @IBAction func update(_ sender: Any) {
        updateData();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        goals = LifeGoals().goals;
        updateData();
    }
    
    func updateData() {
        let center =  UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (result, error) in
           //handle result of request failure
        }
        
        
        // Access Step Count
        collectionView.delegate = self;
        collectionView.dataSource = self;
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!]
        // Check for Authorization
        healthStore.requestAuthorization(toShare: [], read: healthKitTypes) { (bool, error) in
            if (bool) {
                // Authorization Successful
                self.getDistanceWalkingRunning() { (result) in
                    DispatchQueue.main.async {
                        self.defaults.set(result, forKey: "walking")
                        self.updateUI();
                        //let stepCount = String(Int(result))
                        //self.stepsLabel.text = String(stepCount)
                    }
                }
                self.getDistanceCycling() { (result) in
                    DispatchQueue.main.async {
                        self.defaults.set(result, forKey: "cycling")
                        self.updateUI();
                        //let stepCount = String(Int(result))
                        //self.stepsLabel.text = String(stepCount)
                    }
                }
                self.getDistanceWheelChair() { (result) in
                    DispatchQueue.main.async {
                        self.defaults.set(result, forKey: "wheelchair")
                        self.updateUI();
                        //let stepCount = String(Int(result))
                        //self.stepsLabel.text = String(stepCount)
                    }
                }
                self.getFlights() { (result) in
                    DispatchQueue.main.async {
                        self.defaults.set(result, forKey: "flights")
                        self.updateUI();
                        //let stepCount = String(Int(result))
                        //self.stepsLabel.text = String(stepCount)
                    }
                }
            } // end if
        } 
    }
    func updateUI() {
        let walking = self.defaults.double(forKey: "walking");
        let cycling = self.defaults.double(forKey: "cycling");
        let flights = self.defaults.double(forKey: "flights");
        let wheelchair = self.defaults.double(forKey: "wheelchair");
        let oldDistance = self.defaults.double(forKey: "walkingDistance");
        distance.text = "\(((walking+cycling+wheelchair)*1000).rounded()/1000) Kilometer";
        altitude.text = "\((flights*3.0*1000.0).rounded()/1000) Höhenmeter";
        
        self.defaults.setValue((walking+cycling+wheelchair)*1000, forKey: "walkingDistance")
        self.defaults.setValue((flights*3.0), forKey: "altitude")
        //get the notification center
        let center =  UNUserNotificationCenter.current()

        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Walking distance improved!"
        content.subtitle = "OK"
        content.body = "Distanz: \(distance.text ?? "") \n Höhe: \(altitude.text ?? "")"
        content.sound = UNNotificationSound.default

        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:2.0, repeats: false)

        //create request to display
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)

        //add request to notification center
        if((walking+cycling+wheelchair) > oldDistance+100) {
            center.add(request) { (error) in
                if error != nil {
                    print("error \(String(describing: error))")
                }
            }
        }
        collectionView.reloadData();
    }
    func getDistanceWalkingRunning(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        getValue(type: type, unit: HKUnit.meterUnit(with: HKMetricPrefix.kilo), completion: completion);
    }
    func getDistanceCycling(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .distanceCycling)!
        getValue(type: type, unit: HKUnit.meterUnit(with: HKMetricPrefix.kilo), completion: completion);
    }
    func getDistanceWheelChair(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .distanceWheelchair)!
        getValue(type: type, unit: HKUnit.meterUnit(with: HKMetricPrefix.kilo), completion: completion);
    }
    func getFlights(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        getValue(type: type, unit: HKUnit.count(), completion: completion);
    }
    
    
    func getValue(type: HKQuantityType, unit: HKUnit, completion: @escaping (Double) -> Void) {
        let now = Calendar.current.date(byAdding: .year, value: 222, to: Date())!
        let startOfDay = Date(timeIntervalSince1970: 0);
        var interval = DateComponents()
        interval.year = 999
        let query = HKStatisticsCollectionQuery(quantityType: type,
                                               quantitySamplePredicate: nil,
                                               options: [.cumulativeSum],
                                               anchorDate: startOfDay,
                                               intervalComponents: interval)
        
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0

                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: unit)
                } // end if

                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in

            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: unit)
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            } // end if
        }
        
        healthStore.execute(query)
    }

}

