//
//  ViewController.swift
//  Gymlust
//
//  Created by Eric de Haan on 12-06-17.
//  Copyright © 2017 Eric de Haan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get a reference to the database service
        databaseRef = Database.database().reference()
        fillWithInitialData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fillWithInitialData() {
        self.databaseRef.child("ow2017").child("01001").setValue(["nivo":"Pre-Instap/Instap","name":"Anaïs Nieuwenhuijse","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0.0, "status": "free", "startSequence": "10101", "resultSequence":"10100000"])
        self.databaseRef.child("ow2017").child("01002").setValue(["nivo":"Pre-Instap/Instap","name":"Sophie Smit","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10102", "resultSequence":"10100000"])
        self.databaseRef.child("ow2017").child("01003").setValue(["nivo":"Pre-Instap/Instap","name":"Yelina Smit","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10103", "resultSequence":"10100000"])
        self.databaseRef.child("ow2017").child("01004").setValue(["nivo":"Pre-Instap/Instap","name":"Sophie van Leijen","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10104", "resultSequence":"10100000"])

        self.databaseRef.child("ow2017").child("02001").setValue(["nivo":"Pupil 1","name":"Maartje Beentjes","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10201", "resultSequence":"10200000"])
        self.databaseRef.child("ow2017").child("02002").setValue(["nivo":"Pupil 1","name":"Nora de Maaré","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10202", "resultSequence":"10200000"])
        self.databaseRef.child("ow2017").child("02003").setValue(["nivo":"Pupil 1","name":"Yuna Koppes","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10203", "resultSequence":"10200000"])
        self.databaseRef.child("ow2017").child("02004").setValue(["nivo":"Pupil 1","name":"Britt de Looze","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10204", "resultSequence":"10200000"])
 
        self.databaseRef.child("ow2017").child("03001").setValue(["nivo":"Pupil 2","name":"Fenna Veer","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10301", "resultSequence":"10300000"])
        self.databaseRef.child("ow2017").child("03002").setValue(["nivo":"Pupil 2","name":"Noëlle de Haan","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10302", "resultSequence":"10300000"])
        self.databaseRef.child("ow2017").child("03003").setValue(["nivo":"Pupil 2","name":"Bente Winder","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10303", "resultSequence":"10300000"])
        
        self.databaseRef.child("ow2017").child("04001").setValue(["nivo":"Jeugd 1","name":"Nneka Abu","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10401", "resultSequence":"10400000"])
        self.databaseRef.child("ow2017").child("04002").setValue(["nivo":"Jeugd 1","name":"Jill Croon","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10402", "resultSequence":"10400000"])
        self.databaseRef.child("ow2017").child("04003").setValue(["nivo":"Jeugd 1","name":"Fee Plomp","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "10403", "resultSequence":"10400000"])

        self.databaseRef.child("ow2017").child("05001").setValue(["nivo":"Jeugd 2","name":"Lune Goudsblom","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20501", "resultSequence":"20500000"])
        self.databaseRef.child("ow2017").child("05002").setValue(["nivo":"Jeugd 2","name":"Lotte Beentjes","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20502", "resultSequence":"20500000"])
        
        self.databaseRef.child("ow2017").child("06001").setValue(["nivo":"Junior","name":"Melissa Kooijman","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20601", "resultSequence":"20600000"])
        self.databaseRef.child("ow2017").child("06002").setValue(["nivo":"Junior","name":"Anne Wildenberg","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20602", "resultSequence":"20600000"])
        self.databaseRef.child("ow2017").child("06003").setValue(["nivo":"Junior","name":"Marit Hageman","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20603", "resultSequence":"20600000"])
        self.databaseRef.child("ow2017").child("06004").setValue(["nivo":"Junior","name":"Annamarijn Bos","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20604", "resultSequence":"20600000"])
        self.databaseRef.child("ow2017").child("06005").setValue(["nivo":"Junior","name":"Merel Heman","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20605", "resultSequence":"20600000"])
        self.databaseRef.child("ow2017").child("06006").setValue(["nivo":"Junior","name":"Lola Bruin","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20606", "resultSequence":"20600000"])
        
        self.databaseRef.child("ow2017").child("07001").setValue(["nivo":"Senior","name":"Roos Kooij","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20701", "resultSequence":"20700000"])
        self.databaseRef.child("ow2017").child("07002").setValue(["nivo":"Senior","name":"Nina Zondervan","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20702", "resultSequence":"20700000"])
        self.databaseRef.child("ow2017").child("07003").setValue(["nivo":"Senior","name":"Sabine Holthof","beamD":0.0, "beamE":0.0,"beamN":0,"vault1D":0.0, "vault1E":0.0,"vault1N":0,"vault2D":0.0, "vault2E":0.0,"vault2N":0,"floorD":0.0, "floorE":0.0,"floorN":0,"ponyD":0.0, "ponyE":0.0,"ponyN":0, "status": "free", "startSequence": "20703", "resultSequence":"20700000"])
        
    }

}

